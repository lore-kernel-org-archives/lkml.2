Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1LAVeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:34:31 -0500
Received: from fifo99.com ([67.223.236.141]:34275 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab1LAVe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:34:29 -0500
Message-ID: <1322775267.3704.57.camel@m0nster>
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
From: Daniel Walker <dwalker@fifo99.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 01 Dec 2011 13:34:27 -0800
In-Reply-To: <20111201210332.GI9581@n2100.arm.linux.org.uk>
References: <1322752657.3704.2.camel@m0nster>
	 <20111201181736.GA13182@huya.qualcomm.com>
	 <1322764745.3704.9.camel@m0nster>
	 <20111201192705.GA23641@huya.qualcomm.com>
	 <1322767992.3704.13.camel@m0nster>
	 <20111201194353.GA24293@huya.qualcomm.com>
	 <20111201201950.GE9581@n2100.arm.linux.org.uk>
	 <1322771147.3704.21.camel@m0nster>
	 <20111201203506.GG9581@n2100.arm.linux.org.uk>
	 <1322772598.3704.33.camel@m0nster>
	 <20111201210332.GI9581@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 21:03 +0000, Russell King - ARM Linux wrote:
> On Thu, Dec 01, 2011 at 12:49:58PM -0800, Daniel Walker wrote:
> > On Thu, 2011-12-01 at 20:35 +0000, Russell King - ARM Linux wrote:
> > > On Thu, Dec 01, 2011 at 12:25:47PM -0800, Daniel Walker wrote:
> > > > On Thu, 2011-12-01 at 20:19 +0000, Russell King - ARM Linux wrote:
> > > > > Now, the obvious question to ask now is this: as you sent your question,
> > > > > and Daniel obviously objects, was Daniel one of your respondants?  If
> > > > > not, then he carries some of the blame for this patch being created
> > > > > in the first place by having missed the email/not replied/etc.
> > > > > 
> > > > 
> > > > What if the people using the hardware aren't even on the list ? It's not
> > > > their fault is it?
> > > 
> > > Did you notice I mentioned six months?
> > 
> > Yeah I did notice..
> > 
> > > The way to remove non-broken code is:
> > > 1. to ask.  If no one responds, then
> > > 2. submit a patch to put an entry in feature-removal-schedule.txt giving a
> > >    description of what will be removed and when - and then flag it
> > >    with a patch to remove it.  If no one responds to that, then
> > > 3. the patch to remove it re-posted, and if no one objects it gets
> > >    merged.
> > > 
> > > So, if people care about bits of code _and_ they're not on the relevant
> > > subsystem mailing lists, they need to keep an eye on the feature removal
> > > file - otherwise they're in for nasty surprises.
> > 
> > I agree with the steps, but I'm not sure David knows about (or would be
> > following) those steps. Not to mention these devices are still readily
> > available used .. I wouldn't expect anyone to even remotely ponder
> > removing this code for at least another 10 years.. In order to even
> > start the process above there has to be some good probability that no
> > has the device or cares at all about the device..
> 
> Actually... no.  We've removed entire SoCs which have lost their
> maintainers well under this '10 years'.

In this case we have a maintainer (3 of them even)..

> One of the key decisions for removing code is the cost of keeping it
> in a buildable state when there's no one actively looking after it.
> If it has a high cost it'll get deleted much earlier...

I'm not trying to suggest rules for the entire ARM architecture .. In
this particular case it's totally uncalled for to even try to remove the
code.. I don't know the details of the case which your bringing up, but
it doesn't seem (from what you've said) similar to this one. These
devices are widely available, lots of developers and non-developers have
them, the devices are widely available for purchase (with kernels on
them), we have maintainers for the area where the code lives..

In the case your bringing up I could argue with you, but I really don't
know the circumstances.. To me I think it should be hard to remove code
for devices you can easily get a hold of..

Daniel

