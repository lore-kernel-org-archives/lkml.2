Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2BVMhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:37:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2BVMh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:37:27 -0500
Date: Wed, 22 Feb 2012 13:37:25 +0100
From: Jan Kara <jack@suse.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MM: fix a typo of truncate_inode_pages_range
Message-ID: <20120222123725.GB28373@quack.suse.cz>
References: <1329793040-21406-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329793040-21406-1-git-send-email-liubo2009@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-02-12 10:57:20, Liu Bo wrote:
> The typo of API truncate_inode_pages_range is not updated.
  It's better to add more specific recipients of patches. It's too easy to
overlook a patch in 400+ daily messages on LKML. In this particular case
using trivial tree for merging would be appropriate. Added CCs.

								Honza
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  mm/truncate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 632b15e..a188058 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -184,7 +184,7 @@ int invalidate_inode_page(struct page *page)
>  }
>  
>  /**
> - * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
> + * truncate_inode_pages_range - truncate range of pages specified by start & end byte offsets
>   * @mapping: mapping to truncate
>   * @lstart: offset from which to truncate
>   * @lend: offset to which to truncate
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
