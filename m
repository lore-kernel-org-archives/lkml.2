Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2FNDyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:54:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2FNDyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:54:35 -0400
Date: Thu, 14 Jun 2012 11:54:23 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH][TRIVIAL] Fix comments in mm/memblock.c
Message-ID: <20120614035423.GC15262@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1339645650.12607.9.camel@ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339645650.12607.9.camel@ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:47:30AM +0800, Li Zhong wrote:
>Make the parameter names in comments consistent with the actual ones
>used in the function.
>
>Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
>---
> mm/memblock.c |    6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)

Hi Li Zhong,

I have already send a path to fix this issues. 
title is "mm:fix kernel-doc warnings"

Regards,
Wanpeng Li

>
>diff --git a/mm/memblock.c b/mm/memblock.c
>index 952123e..76cb09f 100644
>--- a/mm/memblock.c
>+++ b/mm/memblock.c
>@@ -540,9 +540,9 @@ int __init_memblock memblock_reserve(phys_addr_t
>base, phys_addr_t size)
>  * __next_free_mem_range - next function for for_each_free_mem_range()
>  * @idx: pointer to u64 loop variable
>  * @nid: nid: node selector, %MAX_NUMNODES for all nodes
>- * @p_start: ptr to phys_addr_t for start address of the range, can be
>%NULL
>- * @p_end: ptr to phys_addr_t for end address of the range, can be %
>NULL
>- * @p_nid: ptr to int for nid of the range, can be %NULL
>+ * @out_start: ptr to phys_addr_t for start address of the range, can
>be %NULL
>+ * @out_end: ptr to phys_addr_t for end address of the range, can be %
>NULL
>+ * @out_nid: ptr to int for nid of the range, can be %NULL
>  *
>  * Find the first free area from *@idx which matches @nid, fill the out
>  * parameters, and update *@idx for the next iteration.  The lower
>32bit of
>-- 
>1.7.9.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
