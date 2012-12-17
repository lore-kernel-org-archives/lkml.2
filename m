Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2LQJ2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:28:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53147 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab2LQJ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:28:07 -0500
Date: Mon, 17 Dec 2012 10:28:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI: Overriding ACPI tables via initrd only works
 with an initrd
Message-ID: <20121217092802.GA31947@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
References: <1351694147-10904-1-git-send-email-trenn@suse.de>
 <1351694147-10904-4-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351694147-10904-4-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this one sanitizes the Kconfig entry prompt so can we pick it up for
-rc1 or later, please?

Thanks.

On Wed, Oct 31, 2012 at 03:35:47PM +0100, Thomas Renninger wrote:
> Reflect this dependency in Kconfig.
> Shorten the config description as suggested by Borislav Petkov
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  drivers/acpi/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 44cea5d..ca939b4 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -262,7 +262,8 @@ config ACPI_CUSTOM_DSDT
>  	default ACPI_CUSTOM_DSDT_FILE != ""
>  
>  config ACPI_INITRD_TABLE_OVERRIDE
> -	bool "ACPI tables can be passed via uncompressed cpio in initrd"
> +	bool "ACPI tables override via initrd"
> +	depends on BLK_DEV_INITRD
>  	default n
>  	help
>  	  This option provides functionality to override arbitrary ACPI tables
> -- 
> 1.7.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
