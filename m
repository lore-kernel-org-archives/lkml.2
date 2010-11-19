Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0KSPqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:46:23 -0500
Received: from THUNK.ORG ([69.25.196.29]:56041 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0KSPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:46:21 -0500
Date: Fri, 19 Nov 2010 10:45:40 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use memory compaction instead of lumpy reclaim
 during high-order allocations
Message-ID: <20101119154540.GG10039@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <1290010969-26721-1-git-send-email-mel@csn.ul.ie>
 <20101117154641.51fd7ce5.akpm@linux-foundation.org>
 <20101118081254.GB8135@csn.ul.ie>
 <20101118172627.cf25b83a.kamezawa.hiroyu@jp.fujitsu.com>
 <20101118083828.GA24635@cmpxchg.org>
 <20101118092044.GE8135@csn.ul.ie>
 <20101118114928.ecb2d6b0.akpm@linux-foundation.org>
 <20101119104856.GB28613@csn.ul.ie>
 <4B8266CB-F658-4CC8-BCA3-677C22BAFAE0@mit.edu>
 <20101119140532.GH28613@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119140532.GH28613@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 02:05:32PM +0000, Mel Gorman wrote:
> > 
> > How about making the default before 2.6.40, as an initial step?
> > 
> 
> It'd be a reasonable way of ensuring it's being tested everywhere
> and not by those that are interested or using distro kernel configs.
> I guess we'd set to "default y" in the same patch that adds the note to
> feature-removal-schedule.txt.

I'd suggest doing it now (or soon, before 2.6.40), just to make sure
there aren't massive complaints about performance regressions, etc.,
and then deprecating it at say 2.6.42, and then waiting 6-9 months
before removing it.  But, I'm a bit more conservative about making
such changes.

(Said the person who has reluctantly agreed to keep the minixdf mount
option after we found users when we tried deprecating it.  :-)

       	     	      	    	    	  - Ted
