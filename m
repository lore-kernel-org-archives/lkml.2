Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2GHPMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 11:12:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38689 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2GHPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 11:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <1341739547-17254-1-git-send-email-yamanetoshi@gmail.com>
References: <1341739547-17254-1-git-send-email-yamanetoshi@gmail.com>
Date: Sun, 8 Jul 2012 20:42:35 +0530
Message-ID: <CAHdPZaOBiO8onji718m4caXjpAwoS9Fd1SKT5fM-hX8xxUbFZw@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] asus_oled: Use pr_err(...) rather than
 printk(KERN_ERR ...)
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: greg@kroah.com, sjakub@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git format-patch -s --subject-prfix="PATCH V2' will be better,


On Sun, Jul 8, 2012 at 2:55 PM, Toshiaki Yamane <yamanetoshi@gmail.com> wrote:
> This change is inspired by checkpatch.
>
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/asus_oled/asus_oled.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
> index 510d796..f63c1d3 100644
> --- a/drivers/staging/asus_oled/asus_oled.c
> +++ b/drivers/staging/asus_oled/asus_oled.c
> @@ -782,20 +782,20 @@ static int __init asus_oled_init(void)
>         oled_class = class_create(THIS_MODULE, ASUS_OLED_UNDERSCORE_NAME);
>
>         if (IS_ERR(oled_class)) {
> -               printk(KERN_ERR "Error creating " ASUS_OLED_UNDERSCORE_NAME " class\n");
> +               pr_err("Error creating " ASUS_OLED_UNDERSCORE_NAME " class\n");
>                 return PTR_ERR(oled_class);
>         }
>
>         retval = class_create_file(oled_class, &class_attr_version.attr);
>         if (retval) {
> -               printk(KERN_ERR "Error creating class version file\n");
> +               pr_err("Error creating class version file\n");
>                 goto error;
>         }
>
>         retval = usb_register(&oled_driver);
>
>         if (retval) {
> -               printk(KERN_ERR "usb_register failed. Error number %d\n", retval);
> +               pr_err("usb_register failed. Error number %d\n", retval);
>                 goto error;
>         }
>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
