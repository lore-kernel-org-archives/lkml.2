Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0F2NKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:10:45 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:28979 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0F2NKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:10:44 -0400
Message-ID: <4C29F0D1.7030704@tilera.com>
Date: Tue, 29 Jun 2010 09:10:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] tile: remove homegrown L1_CACHE_ALIGN macro
References: <20100629163018L.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100629163018L.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks fine, thanks.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

On 6/29/2010 3:32 AM, FUJITA Tomonori wrote:
> Let's use the standard L1_CACHE_ALIGN macro instead.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/tile/include/asm/cache.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
> index c2b7dcf..ee59714 100644
> --- a/arch/tile/include/asm/cache.h
> +++ b/arch/tile/include/asm/cache.h
> @@ -20,7 +20,6 @@
>  /* bytes per L1 data cache line */
>  #define L1_CACHE_SHIFT		CHIP_L1D_LOG_LINE_SIZE()
>  #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
> -#define L1_CACHE_ALIGN(x)	(((x)+(L1_CACHE_BYTES-1)) & -L1_CACHE_BYTES)
>  
>  /* bytes per L1 instruction cache line */
>  #define L1I_CACHE_SHIFT		CHIP_L1I_LOG_LINE_SIZE()
>   

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

