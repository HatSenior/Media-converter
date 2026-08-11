using System;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Windows.Forms;

internal static class MediaForgeLauncher
{
    [STAThread]
    private static void Main()
    {
        try
        {
            string root = AppDomain.CurrentDomain.BaseDirectory.TrimEnd(Path.DirectorySeparatorChar);
            string errorLog = Path.Combine(root, "launch-error.log");
            if (File.Exists(errorLog)) File.Delete(errorLog);
            string scriptPath = Path.Combine(root, "MediaForge2.ps1");
            if (!File.Exists(scriptPath))
                throw new FileNotFoundException("Не найден файл приложения MediaForge2.ps1.", scriptPath);

            Environment.SetEnvironmentVariable("MEDIAFORGE_ROOT", root, EnvironmentVariableTarget.Process);
            string script = File.ReadAllText(scriptPath, Encoding.UTF8);

            InitialSessionState state = InitialSessionState.CreateDefault();
            using (Runspace runspace = RunspaceFactory.CreateRunspace(state))
            using (PowerShell shell = PowerShell.Create())
            {
                runspace.ApartmentState = System.Threading.ApartmentState.STA;
                runspace.ThreadOptions = PSThreadOptions.UseCurrentThread;
                runspace.Open();
                shell.Runspace = runspace;
                shell.AddScript(script);
                shell.Invoke();
                if (shell.HadErrors)
                {
                    string details = string.Join(Environment.NewLine,
                        shell.Streams.Error.Select(error => error.ToString()).ToArray());
                    throw new InvalidOperationException(details);
                }
            }
        }
        catch (Exception error)
        {
            try
            {
                File.WriteAllText(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "launch-error.log"),
                    error.ToString(), Encoding.UTF8);
            }
            catch { }
            MessageBox.Show(error.GetBaseException().Message, "Media Forge — ошибка запуска",
                MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
}
