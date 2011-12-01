Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1LAUf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:35:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52279 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1LAUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:35:26 -0500
Date: Thu, 1 Dec 2011 20:35:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Message-ID: <20111201203506.GG9581@n2100.arm.linux.org.uk>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org> <1322752657.3704.2.camel@m0nster> <20111201181736.GA13182@huya.qualcomm.com> <1322764745.3704.9.camel@m0nster> <20111201192705.GA23641@huya.qualcomm.com> <1322767992.3704.13.camel@m0nster> <20111201194353.GA24293@huya.qualcomm.com> <20111201201950.GE9581@n2100.arm.linux.org.uk> <1322771147.3704.21.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322771147.3704.21.camel@m0nster>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 12:25:47PM -0800, Daniel Walker wrote:
> On Thu, 2011-12-01 at 20:19 +0000, Russell King - ARM Linux wrote:
> > Now, the obvious question to ask now is this: as you sent your question,
> > and Daniel obviously objects, was Daniel one of your respondants?  If
> > not, then he carries some of the blame for this patch being created
> > in the first place by having missed the email/not replied/etc.
> > 
> 
> What if the people using the hardware aren't even on the list ? It's not
> their fault is it?

Did you notice I mentioned six months?

The way to remove non-broken code is:
1. to ask.  If no one responds, then
2. submit a patch to put an entry in feature-removal-schedule.txt giving a
   description of what will be removed and when - and then flag it
   with a patch to remove it.  If no one responds to that, then
3. the patch to remove it re-posted, and if no one objects it gets
   merged.

So, if people care about bits of code _and_ they're not on the relevant
subsystem mailing lists, they need to keep an eye on the feature removal
file - otherwise they're in for nasty surprises.
