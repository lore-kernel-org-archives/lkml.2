Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1CaCUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:20:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58573 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab1CaCUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:20:09 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimtO7vR2AQvJj1hHMqHCDqtoiJX_eENE9o3dPpV@mail.gmail.com>
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<20110331001502.GB6680@n2100.arm.linux.org.uk>
	<AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
	<AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com>
	<AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com>
	<AANLkTimS_8BnBz9MSdxYJVL6oreEpH=W61BsyuX2G+Xz@mail.gmail.com>
	<AANLkTimtO7vR2AQvJj1hHMqHCDqtoiJX_eENE9o3dPpV@mail.gmail.com>
Date: Wed, 30 Mar 2011 21:20:08 -0500
Message-ID: <AANLkTimPJCiaUyTfcR1NSPivJ2YjSwazhiWRC-CPLy6J@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Bill Gatliff <bgat@billgatliff.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus:

On Wed, Mar 30, 2011 at 8:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  (a) we don't have to be stupid and think it's a good design and an
> "opportunity" like you do.

The complexity that is the current state of the ARM ecosystem presents
the opportunity to find a way to accommodate all those chips within
the Linux kernel.

If it isn't opportunity, then you must be arguing that we shouldn't
add any new ARM SoC support to the kernel.  Is that what you are
saying?

>  (b) the kernel source code doesn't have to be the mess of code that
> it is. Those things should be abstracted out somehow (and yes,
> devicetree is hopefully one way)

We are in violent agreement here.

> I really don't understand why you seem to be arguing against trying to
> fix a real problem, and why you also seem to be arguing that the messy
> ARM situation is somehow "good". I find your attitude about the lack
> of platform being "good" be to incomprehensibly stupid. There is
> absolutely _no_ advantage to anybody from the crazy arm fragmentation.

I guess I wasn't being clear.

Some of the proposals in this thread seemed to argue for the creation
of a one-size-fits-all kernel solution for ARM.  I think pursuit of
such a solution is a complete waste of time, because it denies the
reality that ARM machines aren't very uniform.  It's far better to
admit to and embrace that diversity than it is to try to deny it.

What we have today clearly isn't optimal, and it isn't going to scale
much farther.  But we can't entertain the option of chucking the whole
mess over the wall into bootloader-land, or VHDL-land, or whatever.
Those simply aren't options.  We have to find a solution that will
work in kernel space.

> I know, I know, a lot of companies make money supporting the whole
> crazy mess. I guess that can make people confused and think that being
> messy is good, and could be seen as an advantage.

No, I don't think messy is good.  And I'm an individual who makes his
living making Linux run on ARM (among others) platforms.  Messy wastes
my time, because I have to deal with the mess rather than making
platforms that solve real problems.  Messy equates to overhead and
tedium.  Messy invites error.  Messy sucks.

> But most embedded companies seem to have realized that they should
> move up the stack, rather than worry about some crazy GPIO or stupid
> driver details.

Now that you mention it, GPIO is a perfect example of what I'm talking
about.  Every ARM chip does that differently.  Rather than deny that,
David Brownell came up with some code that embraces it.  His code
might not be perfect, but we're learning as we go along.  Same can be
said about the kernel's ARM situation as a whole.

And I still don't think that ARM is as bad as you think it is.  Sure
it's ugly, but I don't think it's uglier than SH or PPC.  It's just
ugly at a larger scale, because there are so many more ARM chips to
choose from.

Does ARM need some fixing?  Yes!  But let's be realistic about what
forms the solution might take.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
