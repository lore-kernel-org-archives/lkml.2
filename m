Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2HGQry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:47:54 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:39621 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751210Ab2HGQrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:47:53 -0400
Message-ID: <50214669.2020200@xenotime.net>
Date: Tue, 07 Aug 2012 09:46:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] Fix typo in various Kconfig
References: <1344347699-26434-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1344347699-26434-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 06:54 AM, Masanari Iida wrote:

> Correct spelling typo in various Kconfig files.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/arm/mach-omap2/Kconfig      |  2 +-
>  arch/arm/mach-tegra/Kconfig      |  2 +-
>  arch/blackfin/mach-bf609/Kconfig |  2 +-
>  arch/openrisc/Kconfig            |  2 +-
>  crypto/Kconfig                   |  2 +-
>  drivers/hwspinlock/Kconfig       |  2 +-
>  drivers/md/Kconfig               |  2 +-
>  drivers/media/video/Kconfig      |  2 +-
>  drivers/thermal/Kconfig          |  2 +-
>  drivers/tty/serial/8250/Kconfig  |  2 +-
>  drivers/usb/host/Kconfig         |  4 ++--
>  lib/Kconfig.debug                | 10 +++++-----
>  12 files changed, 17 insertions(+), 17 deletions(-)
> 



We normally accept either British or American spellings,
so these don't need to be changed.  The rest are OK.

Thanks.

> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index dd2db02..60b026a 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -399,7 +399,7 @@ config OMAP4_ERRATA_I688
>  	  before issuing WFI. This condition will be met if one Strongly ordered
>  	  access is performed to the target right before executing the WFI.
>  	  In MPU case, L3 T2ASYNC FIFO and DDR T2ASYNC FIFO needs to be drained.
> -	  IO barrier ensure that there is no synchronisation loss on initiators
> +	  IO barrier ensure that there is no synchronization loss on initiators
>  	  operating on both interconnect port simultaneously.
>  endmenu
>  
> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> index c7c3128..8ae898b 100644
> --- a/drivers/hwspinlock/Kconfig
> +++ b/drivers/hwspinlock/Kconfig
> @@ -24,7 +24,7 @@ config HSEM_U8500
>  	select HWSPINLOCK
>  	help
>  	  Say y here to support the STE Hardware Semaphore functionality, which
> -	  provides a synchronisation mechanism for the various processor on the
> +	  provides a synchronization mechanism for the various processor on the
>  	  SoC.
>  
>  	  If unsure, say N.
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index d949b78..97f3f0b 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -40,7 +40,7 @@ config MD_AUTODETECT
>  
>  	  If you don't use raid and say Y, this autodetection can cause 
>  	  a several-second delay in the boot time due to various
> -	  synchronisation steps that are part of this step.
> +	  synchronization steps that are part of this step.
>  
>  	  If unsure, say Y.
>  



-- 
~Randy
