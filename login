using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Security.Cryptography;

namespace SchoolManagementSystem
{
    public partial class LoginForm : Form
    {
        public LoginForm()
        {
            InitializeComponent();
        }

        private void btn_login_Click(object sender, EventArgs e)
        {
            try
            { 
                var username = tbx_username.Text;
                var password = tbx_password.Text;

                var password_encrypted = this.MD5Hash(password);

                using (EntityModelContext ctx = new EntityModelContext())
                {

                    var is_valid = ctx.tbl_users.Where(a => a.usr_email.Equals(username) && a.usr_password.Equals(password_encrypted)).FirstOrDefault();


                    if (is_valid != null)
                    {
                        //this.ParentForm.MainMenuStrip.Visible = true;
                        //this.ParentForm.toolStrip.Visible = true;

                        //SANI: Show navigation on click event
                        //this.ParentForm.MainMenuStrip.Visible = true;

                        //SANI: Dynamic navigation
                        
                            int parentId = 0;
                            var roleid = is_valid.urs_rol_idfk;

                            ((DashboardForm)this.MdiParent).GetMenuData(parentId, (int)roleid);

                        
                        System.Threading.Thread.Sleep(1000);
                        this.Dispose(); //SANI: Close login form
                    } else {
                        lbl_login_error.Text = "Invalid login credentials.";
                    }
                }

            }catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
        }

        //SANI: Encrypt to md5
        public string MD5Hash(string text)
        {
            MD5 md5 = new MD5CryptoServiceProvider();

            //compute hash from the bytes of text  
            md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));

            //get hash result after compute it  
            byte[] result = md5.Hash;

            StringBuilder strBuilder = new StringBuilder();
            for (int i = 0; i < result.Length; i++)
            {
                //change it into 2 hexadecimal digits  
                //for each byte  
                strBuilder.Append(result[i].ToString("x2"));
            }

            return strBuilder.ToString();
        }

        private void LoginForm_Load(object sender, EventArgs e)
        {
           // DashboardForm dashboard = new DashboardForm();
           // dashboard.MainMenuStrip.Visible = false;
        }
    }
}
