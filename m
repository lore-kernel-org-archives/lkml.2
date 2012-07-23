Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab2GWJUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 05:20:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2GWJUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 05:20:11 -0400
Date: Mon, 23 Jul 2012 10:20:08 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/34] vmscan: add shrink_slab tracepoints
Message-ID: <20120723092008.GO9222@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
 <1342708604-26540-7-git-send-email-mgorman@suse.de>
 <20120719203017.GC19392@burratino>
 <20120719220411.GZ9222@suse.de>
 <20120719220721.GE19392@burratino>
 <20120720100623.GE9222@suse.de>
 <20120720155417.GA2885@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120720155417.GA2885@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 10:54:17AM -0500, Jonathan Nieder wrote:
> Mel Gorman wrote:
> > On Thu, Jul 19, 2012 at 05:07:21PM -0500, Jonathan Nieder wrote:
> 
> >> Some of the other patches of this type made sense, but I'd personally
> >> prefer if this one was dropped, yes.  Though I am just a nobody that
> >> reads patches rather than one of the relevant people. ;-)
> >
> > It's a valid point but I'm going to leave it in for now and see what the
> > general opinion is.
> 
> Ok.  To be more precise, this patch has two properties that other patches
> of the "make later patches easier to apply" class tend not to:
> 
>  * it introduces a significant functional change (adding tracepoints)
>  * it would have been very easy to skip
> 
> Have fun, and sorry for not explaining my reasoning before.
> 

Don't be sorry at all as your reasoning is solid. I'm not leaving the patch
in because I think you're wrong. I feel it is preferable to minimise the
deviation of upstream patches as much as possible but stable reviewers may
prefer to minimise functional change. We'll see where the consensus lies
if I leave the patch in but learn nothing if I take it out at this point.

-- 
Mel Gorman
SUSE Labs
