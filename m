Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2KBUCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:02:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2KBUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:02:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] acpi: add missing newline to printk
Date: Fri, 02 Nov 2012 21:06:30 +0100
Message-ID: <2755585.b9GScQZuQJ@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351875078-5843-1-git-send-email-cesarb@cesarb.net>
References: <1351875078-5843-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 02, 2012 02:51:18 PM Cesar Eduardo Barros wrote:
> The missing newline causes messages like this on dmesg:
> 
> [    2.578212] ACPI: Invalid Power Resource to register!<5>[2.578456] ...
> 
> Cc: Lin Ming <ming.m.lin@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

An equivalent patch has been applied already.

Thanks,
Rafael


> ---
>  drivers/acpi/power.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 40e38a0..7db61b8 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -473,7 +473,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
>  	return ret;
>  
>  no_power_resource:
> -	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
> +	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!\n");
>  	return -ENODEV;
>  }
>  EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
