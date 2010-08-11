Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0HKOlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:41:50 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:10584 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0HKOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:41:49 -0400
Message-ID: <4C62B6A9.8090709@tilera.com>
Date: Wed, 11 Aug 2010 10:41:45 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: remove unused ISA_DMA_THRESHOLD define
References: <20100811111000J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100811111000J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2010 10:11 PM, FUJITA Tomonori wrote:
> No need to define ISA_DMA_THRESHOLD
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/tile/include/asm/scatterlist.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/arch/tile/include/asm/scatterlist.h b/arch/tile/include/asm/scatterlist.h
> index c560424..ad8deec 100644
> --- a/arch/tile/include/asm/scatterlist.h
> +++ b/arch/tile/include/asm/scatterlist.h
> @@ -15,8 +15,6 @@
>  #ifndef _ASM_TILE_SCATTERLIST_H
>  #define _ASM_TILE_SCATTERLIST_H
>  
> -#define ISA_DMA_THRESHOLD	(~0UL)
> -
>  #include <asm-generic/scatterlist.h>
>  
>  #endif /* _ASM_TILE_SCATTERLIST_H */
>   

Thanks, accepted (though I modified it to remove the comments and header
guard too, so it's just a one-line forwarding #include file, to match
other similar files in that directory).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

