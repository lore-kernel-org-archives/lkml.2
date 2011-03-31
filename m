Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1CaBPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:15:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44732 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1CaBPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<20110331001502.GB6680@n2100.arm.linux.org.uk>
	<AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
Date: Wed, 30 Mar 2011 20:15:02 -0500
Message-ID: <AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com>
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

On Wed, Mar 30, 2011 at 7:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  124022 total arch/sh
>  124418 total arch/sparc
>  181997 total arch/m68k
>  246717 total arch/mips
>  254785 total arch/x86
>  370912 total arch/powerpc
>  732732 total arch/arm

I'm not sure this metric is completely fair to ARM.  If you want to
level the field, I think you have to divide each result by the number
of SoC's (or equivalent, in the case of x86) represented by that
architecture.  Otherwise you aren't taking the diversity of the
various implementations of that instruction set into account.

Doing that, I think you'll find that ARM is in much better shape than
it appears.

> And ARM fanbois can say "oh, but arm is special" all they want, but
> they need to realize that the lack of common platform for ARM is a
> real major issue. It's not a "feature", and I'm sorry, but anybody who
> calls x86 "peanuts" is a moron and should be ashamed of himself.
> Instead of trying to feel superior, those people should feel like
> pariah.

I didn't say it was peanuts, but I agreed with the statement and I
stand by it.  I don't think x86 is even close to the diversity you
find in the various ARM implementations.

> The fact that x86 has a platform, and people have cared about
> compatibility, and actually gets things to work with less code is a
> good thing.

Depends on who you ask.  I have had to completely re-do entire
projects because we weren't able to bend the x86's notion of
"platform" to fit the task at hand (the decision to go with x86 was
made before I was involved in those projects, fwiw).

Furthermore, why aren't you saying the same thing about SH?  They
don't appear to have a concept of "platform" that's any more evolved
than ARM.  But there are a lot fewer SH SoCs supported in-kernel, so
the "problem" doesn't look as pronounced.

> I know ARM people who think that x86 is an "ugly" architecture.

You don't know me, but I think x86 is an ugly architecture.

> But the fact is, of all the architectures out there, ARM
> right now is the ugliest BY FAR. Exactly because of people who don't
> seem to understand that this kind of crap is a problem.

It's an OPPORTUNITY, not a problem.  ARM's absence of a "platform"
concept allows developers to bend ARM into the shape needed to solve
the problem--- something that you can't say about x86.

This is a kernel architecture problem, not an SoC problem.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
