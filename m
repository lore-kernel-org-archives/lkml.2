Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2GSWEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:04:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2GSWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:04:14 -0400
Date: Thu, 19 Jul 2012 23:04:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/34] vmscan: add shrink_slab tracepoints
Message-ID: <20120719220411.GZ9222@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-7-git-send-email-mgorman@suse.de>
 <20120719203017.GC19392@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120719203017.GC19392@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 03:30:17PM -0500, Jonathan Nieder wrote:
> Mel Gorman wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > commit 095760730c1047c69159ce88021a7fa3833502c8 upstream.
> >
> > Stable note: Not tracked in Bugzilla. This is a diagnostic patch that
> > 	was part of a series addressing excessive slab shrinking after
> > 	GFP_NOFS failures. There is detailed information on the series'
> > 	motivation at https://lkml.org/lkml/2011/6/2/42 .
> 
> Thanks.  Why would we want this particular patch in stable@? 

That's a reasonable question and thanks for taking a look at this series.

> It doesn't sound like it fixes a serious issue.
> 

You're right, it doesn't. There are a few patches in this series that
were applied because they made other patches easier to apply and this is
one of them.  I should have noted this properly. Unlike other patches of
this type in the series, this particular one would have been easy to work
around. How about this as an updated note or would you prefer it was
dropped entirely?

Stable note: This patch makes later patches easier to apply but otherwise
	has little to justify it. It is a diagnostic patch that was part
	of a series addressing excessive slab shrinking after GFP_NOFS
	failures. There is detailed information on the series' motivation
	at https://lkml.org/lkml/2011/6/2/42 .

-- 
Mel Gorman
SUSE Labs
