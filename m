Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1CRKQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 06:16:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39546 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab1CRKQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 06:16:09 -0400
Date: Fri, 18 Mar 2011 10:15:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110318101512.GA15375@n2100.arm.linux.org.uk>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 07:50:36PM -0700, Linus Torvalds wrote:
> On Thu, Mar 17, 2011 at 11:30 AM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > Please pull omap changes for this merge window from:
> 
> Gaah. Guys, this whole ARM thing is a f*cking pain in the ass.

Please be more specific.  ARM is not small.  ARM as an architecture is
_massive_, with lots of people working in it.  By blaming 'ARM', it's a
bit like blaming the entire planet for problems in one country.

You've only had merge conflicts with IMX/MXC and OMAP so far, and that
hardly warrants taring the "whole ARM thing" with the same brush.

Most people are trying very hard to do the right thing.

> Somebody needs to get a grip in the ARM community. I do want to do
> these merges, just to see how screwed up things are, but guys, this is
> just ridiculous.

It isn't as bad as you think it is for the majority of ARM stuff.

> The pure amount of crazy churn is annoying in itself,
> but when I then get these "independent" pull requests from four
> different people, and they touch the same files, that indicates that
> something is wrong.

I have already complained to Uwe and Sascha about the IMX/MXC conflicts.
It already struck me that there's something seriously wrong at
pengutronix.com as both Uwe and Sascha work in the same area, yet don't
coordinate their efforts.  It seems to me that Uwe is completely
independent of everyone else.

As for anything else, I really don't see a problem.  There are changes
in core ARM code which have impacts on _every_ ARM platform.  It's just
a fact of life that there could be conflicts between core changes and
platform changes.  That's not because things are uncoordinated - I do
try to ensure that such patches receive as many acks from maintainers
as possible.

> Somebody in the ARM community really needs to step up and tell people
> to stop dicking around.

You mean like I've already done with Uwe and Sascha?

I do get the impression that you're extremely unhappy with the way ARM
stuff works, and I've no real idea how to solve that.  I think much of
it is down to perception rather than anything tangible.

Maybe the only solution is for ARM to fork the kernel, which is something
I really don't want to do - but from what I'm seeing its the only solution
which could come close to making you happy.
