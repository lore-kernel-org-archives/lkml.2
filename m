Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2EHFcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 01:32:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49623 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2EHFcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 01:32:21 -0400
Date: Tue, 8 May 2012 08:32:11 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Joonsoo Kim <js1304@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org
Subject: Re: [PATCH] slub: fix incorrect return type of get_any_partial()
In-Reply-To: <1327651943-28225-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.LFD.2.02.1205080831580.4372@tux.localdomain>
References: <1327651943-28225-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Joonsoo Kim wrote:

> Commit 497b66f2ecc97844493e6a147fd5a7e73f73f408 ('slub: return object pointer
> from get_partial() / new_slab().') changed return type of some functions.
> This updates missing part.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index ffe13fd..18bf13e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1579,7 +1579,7 @@ static void *get_partial_node(struct kmem_cache *s,
>  /*
>   * Get a page from somewhere. Search in increasing NUMA distances.
>   */
> -static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
> +static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
>  		struct kmem_cache_cpu *c)
>  {
>  #ifdef CONFIG_NUMA
> -- 
> 1.7.0.4

Applied, thanks!
