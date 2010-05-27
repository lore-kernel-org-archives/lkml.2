Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab0E0EpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:45:22 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40527 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382Ab0E0EpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:45:21 -0400
Date: Thu, 27 May 2010 06:45:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, trivial@kernel.org
Subject: Re: [PATCH] kernel/power/swap.c: fix typos in comments
Message-ID: <20100527044511.GA19625@elf.ucw.cz>
References: <1274921340-4894-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274921340-4894-1-git-send-email-cesarb@cesarb.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-05-26 21:49:00, Cesar Eduardo Barros wrote:
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

ACK.

> ---
>  kernel/power/swap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 66824d7..5846a02 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -114,7 +114,7 @@ sector_t alloc_swapdev_block(int swap)
>  
>  /**
>   *	free_all_swap_pages - free swap pages allocated for saving image data.
> - *	It also frees the extents used to register which swap entres had been
> + *	It also frees the extents used to register which swap entries had been
>   *	allocated.
>   */
>  
> @@ -315,7 +315,7 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
>  /*
>   *	The swap map is a data structure used for keeping track of each page
>   *	written to a swap partition.  It consists of many swap_map_page
> - *	structures that contain each an array of MAP_PAGE_SIZE swap entries.
> + *	structures that contain each an array of MAP_PAGE_ENTRIES swap entries.
>   *	These structures are stored on the swap and linked together with the
>   *	help of the .next_swap member.
>   *

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
