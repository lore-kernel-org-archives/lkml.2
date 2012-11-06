Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2KFNpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:45:08 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:58350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab2KFNpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:45:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 043/104] drivers/cpufreq: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 06 Nov 2012 14:49:16 +0100
Message-ID: <5936896.ObBXSaEhRc@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1352156701-4038-44-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org> <1352156701-4038-44-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 03:04:00 PM Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/cpufreq/Kconfig.arm |    4 ++--
>  drivers/cpufreq/Kconfig.x86 |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 5961e64..b63c335 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -21,8 +21,8 @@ config ARM_S3C2416_CPUFREQ
>  	  If in doubt, say N.
>  
>  config ARM_S3C2416_CPUFREQ_VCORESCALE
> -	bool "Allow voltage scaling for S3C2416 arm core (EXPERIMENTAL)"
> -	depends on ARM_S3C2416_CPUFREQ && REGULATOR && EXPERIMENTAL
> +	bool "Allow voltage scaling for S3C2416 arm core"
> +	depends on ARM_S3C2416_CPUFREQ && REGULATOR
>  	help
>  	  Enable CPU voltage scaling when entering the dvs mode.
>  	  It uses information gathered through existing hardware and
> diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
> index 934854a..0715d8e 100644
> --- a/drivers/cpufreq/Kconfig.x86
> +++ b/drivers/cpufreq/Kconfig.x86
> @@ -174,7 +174,7 @@ config X86_SPEEDSTEP_ICH
>  config X86_SPEEDSTEP_SMI
>  	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
>  	select CPU_FREQ_TABLE
> -	depends on X86_32 && EXPERIMENTAL
> +	depends on X86_32
>  	help
>  	  This adds the CPUFreq driver for certain mobile Intel Pentium III
>  	  (Coppermine), all mobile Intel Pentium III-M (Tualatin)
> @@ -206,7 +206,7 @@ config X86_P4_CLOCKMOD
>  
>  config X86_CPUFREQ_NFORCE2
>  	tristate "nVidia nForce2 FSB changing"
> -	depends on X86_32 && EXPERIMENTAL
> +	depends on X86_32
>  	help
>  	  This adds the CPUFreq driver for FSB changing on nVidia nForce2
>  	  platforms.
> @@ -242,7 +242,7 @@ config X86_LONGHAUL
>  config X86_E_POWERSAVER
>  	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
>  	select CPU_FREQ_TABLE
> -	depends on X86_32 && EXPERIMENTAL
> +	depends on X86_32
>  	help
>  	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
>  	  does not have any safeguards to prevent operating the CPU out of spec
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
