Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab2DFUbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:31:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab2DFUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:31:34 -0400
Date: Fri, 6 Apr 2012 13:31:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [RFC PATCH 0/2] Removal of lumpy reclaim
In-Reply-To: <20120406123439.d2ba8920.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1204061316580.3057@eggly.anvils>
References: <1332950783-31662-1-git-send-email-mgorman@suse.de> <20120406123439.d2ba8920.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Andrew Morton wrote:
> On Wed, 28 Mar 2012 17:06:21 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > (cc'ing active people in the thread "[patch 68/92] mm: forbid lumpy-reclaim
> > in shrink_active_list()")
> > 
> > In the interest of keeping my fingers from the flames at LSF/MM, I'm
> > releasing an RFC for lumpy reclaim removal.
> 
> I grabbed them, thanks.

I do have a concern with this: I was expecting lumpy reclaim to be
replaced by compaction, and indeed it is when CONFIG_COMPACTION=y.
But when CONFIG_COMPACTION is not set, we're back to 2.6.22 in
relying upon blind chance to provide order>0 pages.

Hugh
