Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab0JRV3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:29:55 -0400
Received: from fifo99.com ([67.223.236.141]:37325 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab0JRV3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:29:53 -0400
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@fifo99.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
In-Reply-To: <20101018205847.GB23642@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
	 <20101018110207.131b56ee.sfr@canb.auug.org.au>
	 <20101018081520.GA10551@flint.arm.linux.org.uk>
	 <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com>
	 <20101018182044.GA558@flint.arm.linux.org.uk>
	 <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1010181525000.2764@xanadu.home>
	 <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
	 <20101018205847.GB23642@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 14:29:22 -0700
Message-ID: <1287437362.5588.57.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 21:58 +0100, Russell King wrote:
> On Mon, Oct 18, 2010 at 01:12:54PM -0700, Daniel Walker wrote:
> > On Mon, 2010-10-18 at 15:29 -0400, Nicolas Pitre wrote:
> > 
> > > > Ok, well in that case why not accept this immediately after the merge
> > > > window? A point when everything is quiet, and most of the tree's are
> > > > empty?
> > > 
> > > RMK has his own merge window which closes about at the same time as 
> > > Linus' one opens.  We thought this was happening last week and therefore 
> > > this change was supposed to be the last one.
> > 
> > It seems like that could potentially make these kinds of problem worse,
> > since your merging things immediately before sending them to Linus. Like
> > right now we only have a fairly short amount of time to correct this
> > conflict. 
> 
> What I would like to do in an ideal world is stop merging stuff into my
> tree one week before the merge window opens precisely so that people can
> regression test it.  If I were to conform to that, I'd be saying "tough,
> it's your problem" right now.  Why?
> 
> This change has been discussed at length on the linux-arm-kernel mailing
> list, where patches have been posted and reviewed for it several times
> since July:
> 
> 	http://marc.info/?l=linux-arm-kernel&w=2&r=1&s=late+mdesc&q=b
> 
> In September it became ready for merging, and this is what I said:
> 
> 	http://marc.info/?l=linux-arm-kernel&m=128332699032679&w=2
> 
> So, there should be absolutely no surprise over it, except from people
> who ignore what's going on in the generic ARM world.  No, you can't
> expect people to copy every single board maintainer - we have something
> like 300 odd board files with various maintainers.  It's one of the
> reasons that we have mailing lists.

That's why we have get_maintainer.pl, it adds in all the CC's
automatically .. I can notice the thread on the list, but I have no idea
it's modifying my tree unless I examine every patch's diffstat .. To me
it's way more reasonable to ask the patch author to get the CC's right.
That way we all get active notification when something is modifying our
tree's ..

> What I should be saying at this point is "tough, you've got a problem"
> but I won't.  I've rewound my tree to drop these changes, because it
> seems several people need more time.  You have it - until Tuesday - when
> Nicolas will re-do his patch set on top of whatever my tree is at that
> point.
> 
> If you haven't sent me a pull request by Tuesday[*] evening my time, it
> becomes _your_ problem to fix the resulting breakage.  A warning: make
> sure your tree is not based on my devel branch - it's regressed to
> 'unstable' state because of this.
> 

Ok ..

Daniel

