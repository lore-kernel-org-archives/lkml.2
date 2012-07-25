Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2GYQEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:04:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab2GYQEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:04:38 -0400
Date: Wed, 25 Jul 2012 17:04:34 +0100
From: Mel Gorman <mgorman@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/34] mm: migration: clean up unmap_and_move()
Message-ID: <20120725160434.GC9222@suse.de>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343050727-3045-16-git-send-email-mgorman@suse.de>
 <20120725154526.GA18901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120725154526.GA18901@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 08:45:26AM -0700, Greg KH wrote:
> On Mon, Jul 23, 2012 at 02:38:28PM +0100, Mel Gorman wrote:
> > commit 0dabec93de633a87adfbbe1d800a4c56cd19d73b upstream.
> > 
> > Stable note: Not tracked in Bugzilla. This patch makes later patches
> > 	easier to apply but has no other impact.
> > 
> > unmap_and_move() is one a big messy function.  Clean it up.
> > 
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> >  mm/migrate.c |   59 ++++++++++++++++++++++++++++++++--------------------------
> >  1 file changed, 33 insertions(+), 26 deletions(-)
> 
> Mel, you didn't sign-off-on this patch.  Any reason why?
> 

Another patch that was merged to the distribution kernel before picked
up by mainline. In this case, I copied across the signed-off-bys and
missed my own

Signed-off-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
