Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2GYSDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:03:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50222 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2GYSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:03:47 -0400
Date: Wed, 25 Jul 2012 11:03:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/34] mm: migration: clean up unmap_and_move()
Message-ID: <20120725180342.GB12723@kroah.com>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
 <1343050727-3045-16-git-send-email-mgorman@suse.de>
 <20120725154526.GA18901@kroah.com>
 <20120725160434.GC9222@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725160434.GC9222@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 05:04:34PM +0100, Mel Gorman wrote:
> On Wed, Jul 25, 2012 at 08:45:26AM -0700, Greg KH wrote:
> > On Mon, Jul 23, 2012 at 02:38:28PM +0100, Mel Gorman wrote:
> > > commit 0dabec93de633a87adfbbe1d800a4c56cd19d73b upstream.
> > > 
> > > Stable note: Not tracked in Bugzilla. This patch makes later patches
> > > 	easier to apply but has no other impact.
> > > 
> > > unmap_and_move() is one a big messy function.  Clean it up.
> > > 
> > > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> > > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Cc: Mel Gorman <mgorman@suse.de>
> > > Cc: Rik van Riel <riel@redhat.com>
> > > Cc: Michal Hocko <mhocko@suse.cz>
> > > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > ---
> > >  mm/migrate.c |   59 ++++++++++++++++++++++++++++++++--------------------------
> > >  1 file changed, 33 insertions(+), 26 deletions(-)
> > 
> > Mel, you didn't sign-off-on this patch.  Any reason why?
> > 
> 
> Another patch that was merged to the distribution kernel before picked
> up by mainline. In this case, I copied across the signed-off-bys and
> missed my own
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Thanks, I've now added it.

greg k-h
