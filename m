Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1KQIWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:22:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1KQIWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:22:46 -0500
Date: Thu, 17 Nov 2011 09:22:42 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] mm: cleanup the comment for head/tail pages of compound
 pages in mm/page_alloc.c
Message-ID: <20111117082148.GA30544@tiehlicka.suse.cz>
References: <4EC21D78.4080508@gmail.com>
 <20111115132409.GA7551@tiehlicka.suse.cz>
 <4EC2FE33.7030905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC2FE33.7030905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing trivial tree]

Unquoted patch at https://lkml.org/lkml/2011/11/15/402

On Wed 16-11-11 08:05:07, Wang Sheng-Hui wrote:
[...]
> Thanks, Michal.
> 
> New patch generated.
> 
> 
> [PATCH] mm: cleanup the comment for head/tail pages of compound pages in mm/page_alloc.c
> 
> Only tail pages point at the head page using their ->first_page fields.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/page_alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6e8ecb6..e7dd848 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -332,8 +332,8 @@ out:
>   *
>   * The remaining PAGE_SIZE pages are called "tail pages".
>   *
> - * All pages have PG_compound set.  All pages have their ->private pointing at
> - * the head page (even the head page has this).
> + * All pages have PG_compound set.  All tail pages have their ->first_page
> + * pointing at the head page.
>   *
>   * The first tail page's ->lru.next holds the address of the compound page's
>   * put_page() function.  Its ->lru.prev holds the order of allocation.
> -- 
> 1.7.1

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
