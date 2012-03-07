Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031725Ab2CGAbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:31:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031503Ab2CGAbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:31:12 -0500
Date: Tue, 6 Mar 2012 16:31:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Copot Alexandru <alex.mihai.c@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] mm: fix spelling error
Message-Id: <20120306163110.56f67676.akpm@linux-foundation.org>
In-Reply-To: <1330783996-7955-1-git-send-email-alex.mihai.c@gmail.com>
References: <1330783996-7955-1-git-send-email-alex.mihai.c@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Mar 2012 16:13:16 +0200
Copot Alexandru <alex.mihai.c@gmail.com> wrote:

> Signed-off-by: Copot Alexandru <alex.mihai.c@gmail.com>
> ---
>  mm/vmscan.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c52b235..8a7c989 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2250,13 +2250,13 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
>  				continue;	/* Let kswapd poll it */
>  			if (COMPACTION_BUILD) {
>  				/*
> -				 * If we already have plenty of memory free for
> -				 * compaction in this zone, don't free any more.
> -				 * Even though compaction is invoked for any
> -				 * non-zero order, only frequent costly order
> -				 * reclamation is disruptive enough to become a
> -				 * noticable problem, like transparent huge page
> -				 * allocations.
> +				 * If we already have plenty of memory free
> +				 * for compaction in this zone, don't free any
> +				 * more.  Even though compaction is invoked
> +				 * for any non-zero order, only frequent
> +				 * costly order reclamation is disruptive
> +				 * enough to become a noticeable problem, like
> +				 * transparent huge page allocations.
>  				 */
>  				if (compaction_ready(zone, sc)) {
>  					aborted_reclaim = true;

hm, you appear to have reformatted the comment to fit into 78 column or
something.  We have 80 to use!

AFACIT the sole spelling mistake was s/noticable/noticeable/.

More significantly, the comment is hard to follow.  Perhaps removing
the "only" wold fix it up.


