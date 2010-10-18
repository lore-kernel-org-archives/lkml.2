Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab0JRU7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:59:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56428 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0JRU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:59:10 -0400
Date: Mon, 18 Oct 2010 21:58:47 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20101018205847.GB23642@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <20101018110207.131b56ee.sfr@canb.auug.org.au> <20101018081520.GA10551@flint.arm.linux.org.uk> <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com> <20101018182044.GA558@flint.arm.linux.org.uk> <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1010181525000.2764@xanadu.home> <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:12:54PM -0700, Daniel Walker wrote:
> On Mon, 2010-10-18 at 15:29 -0400, Nicolas Pitre wrote:
> 
> > > Ok, well in that case why not accept this immediately after the merge
> > > window? A point when everything is quiet, and most of the tree's are
> > > empty?
> > 
> > RMK has his own merge window which closes about at the same time as 
> > Linus' one opens.  We thought this was happening last week and therefore 
> > this change was supposed to be the last one.
> 
> It seems like that could potentially make these kinds of problem worse,
> since your merging things immediately before sending them to Linus. Like
> right now we only have a fairly short amount of time to correct this
> conflict. 

What I would like to do in an ideal world is stop merging stuff into my
tree one week before the merge window opens precisely so that people can
regression test it.  If I were to conform to that, I'd be saying "tough,
it's your problem" right now.  Why?

This change has been discussed at length on the linux-arm-kernel mailing
list, where patches have been posted and reviewed for it several times
since July:

	http://marc.info/?l=linux-arm-kernel&w=2&r=1&s=late+mdesc&q=b

In September it became ready for merging, and this is what I said:

	http://marc.info/?l=linux-arm-kernel&m=128332699032679&w=2

So, there should be absolutely no surprise over it, except from people
who ignore what's going on in the generic ARM world.  No, you can't
expect people to copy every single board maintainer - we have something
like 300 odd board files with various maintainers.  It's one of the
reasons that we have mailing lists.

What I should be saying at this point is "tough, you've got a problem"
but I won't.  I've rewound my tree to drop these changes, because it
seems several people need more time.  You have it - until Tuesday - when
Nicolas will re-do his patch set on top of whatever my tree is at that
point.

If you haven't sent me a pull request by Tuesday[*] evening my time, it
becomes _your_ problem to fix the resulting breakage.  A warning: make
sure your tree is not based on my devel branch - it's regressed to
'unstable' state because of this.

You have the opportunity to sort this out avoiding conflicts and bisect
problems.  I suggest you take advantage of that.  But don't expect me
to keep on making these kinds of concessions.

* - I really don't like making deadlines for Tuesdays and Wednesdays
because I tend to only be around in the evening - but there is no option.
So don't expect something which arrives here at midnight Tuesday to get
merged.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
