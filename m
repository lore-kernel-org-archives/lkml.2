Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522Ab1LPShx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:37:53 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50317 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759730Ab1LPShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:37:47 -0500
Date: Fri, 16 Dec 2011 10:37:04 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radix_tree: remove radix_tree_indirect_to_ptr
In-Reply-To: <4EEB270C.4010903@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.00.1112161034370.2909@eggly.anvils>
References: <4EEB2690.1050401@linux.vnet.ibm.com> <4EEB270C.4010903@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, Xiao Guangrong wrote:

> It is not used anymore, remove it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Good, yes, thank you: I'm doing a little there at the moment, so let me add
Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  include/linux/radix-tree.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> index 9d4539c..07e360b 100644
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -49,9 +49,6 @@
>  #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
>  #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
> 
> -#define radix_tree_indirect_to_ptr(ptr) \
> -	radix_tree_indirect_to_ptr((void __force *)(ptr))
> -
>  static inline int radix_tree_is_indirect_ptr(void *ptr)
>  {
>  	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
> -- 
> 1.7.7.4
