Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2K2RJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:09:29 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35369 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2K2RJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:09:28 -0500
Date: Thu, 29 Nov 2012 12:08:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: George Spelvin <linux@horizon.com>
Cc: mgorman@suse.de, dave@linux.vnet.ibm.com, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Message-ID: <20121129170843.GJ2301@cmpxchg.org>
References: <20121128113920.GU8218@suse.de>
 <20121129145414.9415.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129145414.9415.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:54:14AM -0500, George Spelvin wrote:
> Mel Gorman <mgorman@suse.de> wrote:
> > On Tue, Nov 27, 2012 at 04:25:14PM -0500, George Spelvin wrote:
> >> Well, it just made it to 24 hours, 
> >> it did before.  I'm going to wait a couple more days before declaring
> >> victory, but it looks good so far.
> >> 
> >>  19:19:10 up 1 day, 0 min,  2 users,  load average: 0.15, 0.20, 0.22
> >>  21:24:05 up 1 day,  2:05,  2 users,  load average: 0.25, 0.19, 0.18
> >
> > Superb. The relevant patches *should* be in flight for 3.7 assuming they
> > make it through the confusion of last-minute fixes.
> 
>  14:53:54 up 2 days, 19:35,  2 users,  load average: 0.20, 0.24, 0.23
> 
> Almost three days, when it wouldn't live overnight before.
> As promised, I'm declaring victory.
> 
> The patch that worked (on top of -rc7) was Johannes Weiner's
> "mm: vmscan: fix endless loop in kswapd balancing"
> that added the zone_balanced() function to mm/vmscan.c:2400.

Thanks for testing!

Love,
Georgina
