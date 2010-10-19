Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0JSSfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:35:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53143 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0JSSfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:35:23 -0400
Date: Tue, 19 Oct 2010 19:34:48 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20101019183448.GA11088@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <alpine.LFD.2.00.1010181833440.2764@xanadu.home> <1287442418.5376.38.camel@Joe-Laptop> <201010191518.04147.arnd@arndb.de> <1287507806.10071.16.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287507806.10071.16.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 10:03:26AM -0700, Daniel Walker wrote:
> On Tue, 2010-10-19 at 15:18 +0200, Arnd Bergmann wrote:
> > On Tuesday 19 October 2010, Joe Perches wrote:
> > > This could have been done:
> > > 
> > > $ git show 08a610d9ef5394525b0328da0162d7b58c982cc4 | ./scripts/get_maintainer.pl --nogit | wc -l
> > > 35
> > > 
> > > Even then, using 35 CCs is generally silly.
> > > 
> > > It might make some sense for a cover letter and a
> > > patch series where the series made tree-wide changes
> > > in multiple directories.
> > 
> > Probably not even then: When a single mail header gets too long, you usually land
> > in some spam filter and get hate mail from the list owners. The lkml limit is 1024
> > characters (this may come from an official RFC, don't know), which is usually less
> > than 35 recipients.
> 
> Patches just shouldn't be this large.

Patches get large.  Sometimes they can't be sensibly broken up.  We
have to accept them as is sometimes.  This is one of those occasions.
See the example Nicolas gave you - it's no different.

As for you saying that I'm the one getting excited about this - I'm not.
I'm getting pissed off by how much discussion effort this trivial matter
is taking and how much time it's wasting, which really isn't necessary.
There's far better things to be done (such as testing) rather than taking
hours to sort out what is basically a trivial merge issue.

Now, you've said in your pull request:

| Here is your pull request Russell. This has the patch which was part of
| the conflict in MSM, "msm: allow uart to be conditionally disabled"..
| 
| It's on top of v2.6.36-rc5, and it has one patch that is already in your
| tree. It's "GIC: Dont disable INT in ack callback" .
| 
| This pull request is exactly what I would send to Linus is the merge
| window was open.

As I'm merging it into a tree which does _not_ have the changes from
Jeremy and Nicolas, what's this "the patch which was part of the
conflict" and what's it going to do without Nicolas' changes?

The point of dropping Jeremy and Nicolas' changes are to return to a
state where things were before the troublesome change, so that the
existing code works.  Then Nicolas was going to take what is in my
tree, and update the patches to take account of what's there.

If you're going to pre-empt that by fixing the stuff yourself, this
whole exercise has been pointless, because it means that the code in
your tree currently won't build without these other changes.

So at the moment I don't know whether or not I should pull your tree.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
