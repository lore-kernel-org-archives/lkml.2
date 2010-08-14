Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0HNGjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 02:39:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:32889 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab0HNGji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 02:39:38 -0400
Date: Sat, 14 Aug 2010 15:39:31 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] arch/tile: rename ARCH_KMALLOC_MINALIGN to
 ARCH_DMA_MINALIGN
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201008140047.o7E0lTiQ006412@farm-0002.internal.tilera.com>
References: <201008140047.o7E0lTiQ006412@farm-0002.internal.tilera.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100814153825L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Aug 2010 15:39:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 20:43:39 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> See commit a6eb9fe105d5de0053b261148cee56c94b4720ca.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/cache.h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
> index f610184..08a2815 100644
> --- a/arch/tile/include/asm/cache.h
> +++ b/arch/tile/include/asm/cache.h
> @@ -27,11 +27,10 @@
>  #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
>  
>  /*
> - * TILE-Gx is fully coherents so we don't need to define
> - * ARCH_KMALLOC_MINALIGN.
> + * TILE-Gx is fully coherent so we don't need to define ARCH_DMA_MINALIGN.
>   */
>  #ifndef __tilegx__
> -#define ARCH_KMALLOC_MINALIGN	L2_CACHE_BYTES
> +#define ARCH_DMA_MINALIGN	L2_CACHE_BYTES
>  #endif

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
