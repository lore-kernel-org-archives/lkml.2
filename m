Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0HPRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:10:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab0HPRKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:10:45 -0400
Message-ID: <4C697115.3020902@suse.cz>
Date: Mon, 16 Aug 2010 19:10:45 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephan Sperber <sperberstephan@googlemail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Kconfig: deleted a word which apeared twice
References: <1281946965.1799.11.camel@monkey>
In-Reply-To: <1281946965.1799.11.camel@monkey>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 16.8.2010 10:22, Stephan Sperber napsal(a):
> Hi all,
> 
> please be not too hard on me with this patch. it is my first one.
> at least give me input what needs to be better.
> thanks in advance

Your patch is fine, let's just add trivial@kernel.org to Cc.

Michal

> 
> Stephan
> ps: i am not subscribed to the list
> 
>>From e81719fabd94594b342114c6060c21da72dc9257 Mon Sep 17 00:00:00 2001
> From: Stephan Sperber <sperberstephan@googlemail.com>
> Date: Wed, 14 Jul 2010 11:23:08 +0200
> Subject: [PATCH] Kconfig: deleted a word which apeared twice
> 
> Deleted a word which apeared twice.
> 
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

