Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2DPQcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:32:42 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46393 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752265Ab2DPQcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:32:41 -0400
Message-ID: <4F8C73DD.3080804@xenotime.net>
Date: Mon, 16 Apr 2012 12:32:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] Fix typo in various Kconfig file
References: <1334330051-20051-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1334330051-20051-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 08:14 AM, Masanari Iida wrote:

> Correct spelling typo in various Kconfig file.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/m68k/Kconfig.cpu                  |    2 +-
>  arch/mips/Kconfig                      |    4 ++--
>  arch/mips/Kconfig.debug                |    2 +-
>  arch/openrisc/Kconfig                  |    2 +-
>  arch/powerpc/platforms/Kconfig.cputype |    4 ++--
>  arch/powerpc/platforms/pseries/Kconfig |    2 +-
>  arch/sh/Kconfig.cpu                    |    2 +-
>  drivers/devfreq/Kconfig                |    2 +-
>  drivers/hid/Kconfig                    |    2 +-
>  drivers/hwmon/Kconfig                  |    2 +-
>  drivers/i2c/busses/Kconfig             |    2 +-
>  drivers/mfd/Kconfig                    |    6 +++---
>  drivers/ptp/Kconfig                    |    2 +-
>  drivers/watchdog/Kconfig               |    2 +-
>  drivers/xen/Kconfig                    |    2 +-
>  15 files changed, 19 insertions(+), 19 deletions(-)

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

A few more possible corrections are noted below.

Thanks.


> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ce30e2f..923a6c3 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -1001,12 +1001,12 @@ config HOLES_IN_ZONE
>  	bool
>  
>  #
> -# Endianess selection.  Sufficiently obscure so many users don't know what to
> +# Endianness selection.  Sufficiently obscure so many users don't know what to
>  # answer,so we try hard to limit the available choices.  Also the use of a


space after ','

>  # choice statement should be more obvious to the user.
>  #
>  choice
> -	prompt "Endianess selection"
> +	prompt "Endianness selection"
>  	help
>  	  Some MIPS machines can be configured for either little or big endian
>  	  byte order. These modes require different kernels and a different
> diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
> index a478719..66dff20 100644
> --- a/arch/openrisc/Kconfig
> +++ b/arch/openrisc/Kconfig
> @@ -141,7 +141,7 @@ config DEBUG_STACKOVERFLOW
>  	bool "Check for kernel stack overflow"
>  	default y
>  	help
> -	  Make extra checks for space avaliable on stack in some
> +	  Make extra checks for space available on stack in some
>            critical functions. This will cause kernel to run a bit slower,
>  	  but will catch most of kernel stack overruns and exit gracefuly.


	                                                        gracefully.

>  


-- 
~Randy
