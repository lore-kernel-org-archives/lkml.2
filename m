Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HWNfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:35:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0HWNfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:35:46 -0400
Date: Mon, 23 Aug 2010 15:35:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Stephan Sperber <sperberstephan@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kconfig: deleted a word which apeared twice
In-Reply-To: <1281946965.1799.11.camel@monkey>
Message-ID: <alpine.LRH.2.00.1008231535240.2372@twin.jikos.cz>
References: <1281946965.1799.11.camel@monkey>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010, Stephan Sperber wrote:

> Signed-off-by: Stephan Sperber <sperberstephan@googlemail.com>
> ---
>  init/Kconfig |    2 +-
>  usr/Kconfig  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 5cff9a9..5d78655 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -179,7 +179,7 @@ config KERNEL_LZO
>  	depends on HAVE_KERNEL_LZO
>  	help
>  	  Its compression ratio is the poorest among the 4. The kernel
> -	  size is about about 10% bigger than gzip; however its speed
> +	  size is about 10% bigger than gzip; however its speed
>  	  (both compression and decompression) is the fastest.
>  
>  endchoice
> diff --git a/usr/Kconfig b/usr/Kconfig
> index e2721f5..c2c7fe2 100644
> --- a/usr/Kconfig
> +++ b/usr/Kconfig
> @@ -144,7 +144,7 @@ config INITRAMFS_COMPRESSION_LZO
>  	depends on RD_LZO
>  	help
>  	  Its compression ratio is the poorest among the four. The kernel
> -	  size is about about 10% bigger than gzip; however its speed
> +	  size is about 10% bigger than gzip; however its speed
>  	  (both compression and decompression) is the fastest.
>  
>  endchoice

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

