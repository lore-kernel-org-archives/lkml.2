Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2LRARF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:17:05 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:36598 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2LRARD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:17:03 -0500
Date: Mon, 17 Dec 2012 19:16:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 152/241] mm: vmscan: fix endless loop in kswapd balancing
Message-ID: <20121218001656.GB7147@cmpxchg.org>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
 <1355407206-17100-153-git-send-email-herton.krzesinski@canonical.com>
 <1355601411.18807.26.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355601411.18807.26.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 07:56:51PM +0000, Ben Hutchings wrote:
> On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > commit 60cefed485a02bd99b6299dad70666fe49245da7 upstream.
> [...]
> 
> Greg, you missed this in 3.{0,4}.y.  I'm attaching the version I used
> for 3.2.y, which seems to be applicable to 3.0.y.  One or other of these
> should work for 3.4.y.

Please don't put this in anything earlier than 3.4 as this was the
first version that exhibited the problem.

I apologize for letting it slip into 3.2; a result of failing to
properly mention the origin of the problem in the changelog, tagging
it stable for 3.4+, and noticing the email proposing it for 3.2.  Time
for vacation, I guess... :/
