Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DDKBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:01:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0DDKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:01:15 -0400
Date: Sun, 4 Apr 2010 12:01:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100404100108.GA18855@one.firstfloor.org>
References: <20100401011725.GA27567@basil.fritz.box> <20100401190205.GD6027@erda.amd.com> <1270149084.19685.9249.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270149084.19685.9249.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:11:24PM -0400, Steven Rostedt wrote:
> On Thu, 2010-04-01 at 21:02 +0200, Robert Richter wrote:
> > On 01.04.10 03:17:25, Andi Kleen wrote:
> > > Got confirmation now this patch fixes most of the dropped oprofile
> > > samples problem on a particular intensive test on a large system.
> > > So now submitting the previous RFC formally.
> > > .34 / Stable candidate.
> > 
> > Thanks Andi, will take a look at this next week.
> 
> Note, I just sent out a patch set yesterday which will conflict with
> this change.
> 
> I Cc'd both you and Andi on that patch.

Steve, is your ring buffer patch intended for stable? 

I plan to submit the oprofile patch for stable and if your is not
it would be more convenient if your patch was based on mine instead
of the other way round. If yours is for stable I can rebase on top
of yours.

Thanks,

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
