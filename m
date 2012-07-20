Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2GTKG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:06:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab2GTKG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:06:27 -0400
Date: Fri, 20 Jul 2012 11:06:24 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/34] vmscan: add shrink_slab tracepoints
Message-ID: <20120720100623.GE9222@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-7-git-send-email-mgorman@suse.de>
 <20120719203017.GC19392@burratino>
 <20120719220411.GZ9222@suse.de>
 <20120719220721.GE19392@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120719220721.GE19392@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 05:07:21PM -0500, Jonathan Nieder wrote:
> Mel Gorman wrote:
> > On Thu, Jul 19, 2012 at 03:30:17PM -0500, Jonathan Nieder wrote:
> 
> >> It doesn't sound like it fixes a serious issue.
> >
> > You're right, it doesn't. There are a few patches in this series that
> > were applied because they made other patches easier to apply and this is
> > one of them.  I should have noted this properly. Unlike other patches of
> > this type in the series, this particular one would have been easy to work
> > around. How about this as an updated note or would you prefer it was
> > dropped entirely?
> 
> Some of the other patches of this type made sense, but I'd personally
> prefer if this one was dropped, yes.  Though I am just a nobody that
> reads patches rather than one of the relevant people. ;-)
> 

It's a valid point but I'm going to leave it in for now and see what the
general opinion is. I'm happy to go either way with this patch. I'll
repost shortly with the "stable note" updates and the linux-mm included
as I managed to screw up its mail address in the sending script.

Thanks.

-- 
Mel Gorman
SUSE Labs
