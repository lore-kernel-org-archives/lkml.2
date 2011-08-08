Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1HHJfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:35:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58221 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1HHJfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:35:03 -0400
Date: Mon, 8 Aug 2011 11:34:57 +0200
From: Tejun Heo <tj@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] memblock: add NO_BOOTMEM config symbol
Message-ID: <20110808093457.GG23937@htj.dyndns.org>
References: <20110806191111.GB8494@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806191111.GB8494@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing hpa)

On Sat, Aug 06, 2011 at 09:11:11PM +0200, Sam Ravnborg wrote:
> With the NO_BOOTMEM symbol added archistectures may now
> use the following syntax to tell that they do not need bootmem:
> 
> 	select NO_BOOTMEM
> 
> This is much more convinient than adding a new kconfig symbol
> which was otherwise required.
> 
> Addign this symbol does not conflict with the architctures that
> already define their own symbol.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

> ---
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 7c56971..af0047d 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -137,6 +137,9 @@ config HAVE_MEMBLOCK_NODE_MAP
>  config ARCH_DISCARD_MEMBLOCK
>  	boolean
>  
> +config NO_BOOTMEM
> +	boolean
> +
>  # eventually, we can have this option just 'select SPARSEMEM'
>  config MEMORY_HOTPLUG
>  	bool "Allow for memory hot-add"

-- 
tejun
