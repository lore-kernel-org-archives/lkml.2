Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab1CaA4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:56:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756556Ab1CaA4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110331001502.GB6680@n2100.arm.linux.org.uk>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <20110331001502.GB6680@n2100.arm.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 17:55:45 -0700
Message-ID: <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 5:15 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> In this merge window, I deleted at least 6000 lines from arch/arm, and
> by quoting diffstat percentages, you're using that against the ARM
> community.  Why did I bother (that's not a question).

Umm. The actual stats are still:

 1349 files changed, 62230 insertions(+), 33993 deletions(-)

which is sad. And the end result speaks for itself: this is lines per
architecture:

  ...
  124022 total arch/sh
  124418 total arch/sparc
  181997 total arch/m68k
  246717 total arch/mips
  254785 total arch/x86
  370912 total arch/powerpc
  732732 total arch/arm

notice how ARM ends up being in a class of its own. This is a PROBLEM.

And ARM fanbois can say "oh, but arm is special" all they want, but
they need to realize that the lack of common platform for ARM is a
real major issue. It's not a "feature", and I'm sorry, but anybody who
calls x86 "peanuts" is a moron and should be ashamed of himself.
Instead of trying to feel superior, those people should feel like
pariah.

The fact that x86 has a platform, and people have cared about
compatibility, and actually gets things to work with less code is a
good thing. I know ARM people who think that x86 is an "ugly"
architecture. But the fact is, of all the architectures out there, ARM
right now is the ugliest BY FAR. Exactly because of people who don't
seem to understand that this kind of crap is a problem.

                    Linus
