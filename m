Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1JJQGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:06:01 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:55804 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147Ab1JJQF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:05:59 -0400
Message-ID: <4E9317E4.4090209@xenotime.net>
Date: Mon, 10 Oct 2011 09:05:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Kconfig: remove CONFIG_ prefix on two symbols
References: <1318239891.29265.7.camel@x61.thuisdomein>
In-Reply-To: <1318239891.29265.7.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/11 02:44, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> These two changes are trivial in the sense that it's clear what is
> intended here. On the other hand I assume they influence the output of
> the config tools. So perhaps these two changes need review by the
> maintainers of these files.

Looks correct to me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

>  arch/powerpc/platforms/85xx/Kconfig |    2 +-
>  drivers/ide/Kconfig                 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
> index 498534c..12f5932 100644
> --- a/arch/powerpc/platforms/85xx/Kconfig
> +++ b/arch/powerpc/platforms/85xx/Kconfig
> @@ -80,7 +80,7 @@ config P1010_RDB
>  config P1022_DS
>  	bool "Freescale P1022 DS"
>  	select DEFAULT_UIMAGE
> -	select CONFIG_PHYS_64BIT	# The DTS has 36-bit addresses
> +	select PHYS_64BIT	# The DTS has 36-bit addresses
>  	select SWIOTLB
>  	help
>  	  This option enables support for the Freescale P1022DS reference board.
> diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
> index 9827c5e..075f322 100644
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -681,7 +681,7 @@ config BLK_DEV_IDE_AU1XXX
>         select IDE_XFER_MODE
>  choice
>         prompt "IDE Mode for AMD Alchemy Au1200"
> -       default CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
> +       default BLK_DEV_IDE_AU1XXX_PIO_DBDMA
>         depends on SOC_AU1200 && BLK_DEV_IDE_AU1XXX
>  
>  config BLK_DEV_IDE_AU1XXX_PIO_DBDMA


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
