Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1CGIhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:37:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48491 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:37:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/8] Add alloc_page_vma_node
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1299182391-6061-4-git-send-email-andi@firstfloor.org>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org> <1299182391-6061-4-git-send-email-andi@firstfloor.org>
Message-Id: <20110307173659.8A0A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 17:37:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a alloc_page_vma_node that allows passing the "local" node in.
> Used in a followon patch.
> 
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/gfp.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 782e74a..814d50e 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -343,6 +343,8 @@ extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
>  #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
>  #define alloc_page_vma(gfp_mask, vma, addr)			\
>  	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
> +#define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
> +	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
>  
>  extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
>  extern unsigned long get_zeroed_page(gfp_t gfp_mask);

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


