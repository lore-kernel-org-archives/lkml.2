Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab1DMVrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:47:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab1DMVry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:47:54 -0400
Date: Wed, 13 Apr 2011 23:47:51 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] writeback: add bdi_dirty_limit() kernel-doc
Message-ID: <20110413214751.GC4648@quack.suse.cz>
References: <20110413085937.981293444@intel.com>
 <20110413090415.389888354@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413090415.389888354@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-04-11 16:59:38, Wu Fengguang wrote:
> Clarify the bdi_dirty_limit() comment.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Looks fine.

  Acked-by: Jan Kara <jack@suse.cz>

							Honza
> ---
>  mm/page-writeback.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-03-03 14:38:12.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-03-03 14:40:52.000000000 +0800
> @@ -437,10 +437,17 @@ void global_dirty_limits(unsigned long *
>  	*pdirty = dirty;
>  }
>  
> -/*
> +/**
>   * bdi_dirty_limit - @bdi's share of dirty throttling threshold
> + * @bdi: the backing_dev_info to query
> + * @dirty: global dirty limit in pages
> + *
> + * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
> + * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
> + * And the "limit" in the name is not seriously taken as hard limit in
> + * balance_dirty_pages().
>   *
> - * Allocate high/low dirty limits to fast/slow devices, in order to prevent
> + * It allocates high/low dirty limits to fast/slow devices, in order to prevent
>   * - starving fast devices
>   * - piling up dirty pages (that will take long time to sync) on slow devices
>   *
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
