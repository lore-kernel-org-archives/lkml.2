Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0FAFiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:38:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:58085 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752194Ab0FAFiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:38:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+U+l9qkiSU1vFplS8nUxYH4URk1kriEXl9k7CTuM
	K/K/7NqM1qXu0Y
Subject: Re: Article in Phoronix about loss of performance in 2.6.35
 release candidates
From: Mike Galbraith <efault@gmx.de>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, alex.buell@munted.org.uk,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>
In-Reply-To: <AANLkTin-kNPeEsyweU1dJM7Jbe0TzbRfLWlkqdbr4GlQ@mail.gmail.com>
References: <1275347969.29006.5.camel@lithium.local.net>
	 <4C0448B5.7090904@gmail.com> <4C047B38.9050506@tmr.com>
	 <AANLkTin-kNPeEsyweU1dJM7Jbe0TzbRfLWlkqdbr4GlQ@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 Jun 2010 07:38:14 +0200
Message-Id: <1275370694.9751.58.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 21:22 -0600, Robert Hancock wrote:
> On Mon, May 31, 2010 at 9:15 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> > Robert Hancock wrote:
> >>
> >> On 05/31/2010 05:19 PM, Alex Buell wrote:
> >>>
> >>> http://www.phoronix.com/vr.php?view=14976
> >>>
> >>> Question: Why?
> >>
> >> Good question.. I guess it would too much to ask of them to try to figure
> >> out what area the problem lies in (even to the point of figuring out if it's
> >> a CPU or IO-bound problem), or try to bisect, or at least report it to LKML
> >> before going to the trouble of creating 5 pages of graphs.. Given the 20x
> >> slowdown in some of the benchmarks you'd think it wouldn't be too hard to
> >> narrow down.
> >
> > That's true, but 20x should be too hard for people to detect when they do QA
> > after creating a patch, before sending it to LKML in the first place,
> > either. If such a regression made it to an -rc1 then it really is kind of a
> > big deal. Of course Phoronics running the tests on netbook processors is
> > probably a good thing, I doubt many developers and testers are compiling
> > kernels on a rig like that, or doing much of anything else demanding.
> >
> > I guess I would expect people to react with dismay to the fact that such a
> > problem made it undetected to rc stage, but perhaps I have too much respect
> > for developers. This looks more like "how dare they not keep it quiet and
> > just tell us" indignation. In the end I doubt it makes a lot of difference,
> > if someone posted to LKML and Slashdot picked it up, be sure it would have
> > hit the media anyway.
> >
> > Should any media keep a defect quiet when they make their living informing
> > the readers? I see a lot of glee among Linux users every few days when a new
> > Windows bug becomes public. Phoronics tested and reported, why is that less
> > honorable than Tom's Hardware telling us a new CPU sucks?
> 
> Of course they shouldn't keep it quiet. The problem is they went and
> wrote an article that was basically "OMG HUGE PERFORMANCE LOSS!!1!!"
> without reporting the problem to people that can actually do something
> about it, and also didn't provide any very useful details like dmesg,
> config, etc. that might let someone figure out what's going on.

Shrug.  If eggshells land in our omelet, they can make a buck telling
people about it.  Who cares?  If tasty bacon bits land, they'll make a
buck on that event.  Either way, we get some test coverage.

	-Mike

