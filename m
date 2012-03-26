Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab2CZS66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:58:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43494 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188Ab2CZS64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:58:56 -0400
Date: Mon, 26 Mar 2012 20:58:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Tracking regressions for next release(s)
Message-ID: <20120326185849.GA19481@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>
References: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com>
 <20120323101431.GA8832@liondog.tnic>
 <201203261847.17521.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203261847.17521.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 06:47:17PM +0200, Maciej Rutecki wrote:
> Hi,
> 
> On piątek, 23 marca 2012 o 11:14:31 Borislav Petkov wrote:
> > On Fri, Mar 23, 2012 at 07:01:19AM +0100, Maciej Rutecki wrote:
> > > I am interested in the opinion of the developers, testers, and
> > > everyone involved in the development of the kernel, if they thing that
> > > tracking regressions and monitoring the quality makes sense,
> > 
> > Absolutely.
> > 
> > > especially since I met several times (put it mildly) dislike of such
> > > work and the bugs are repaired relatively slowly.
> > 
> > I can imagine people getting cranky when someone points out that there's
> > a "boring" bug they need to fix instead of them working on the cool new
> > feature they have thought of. It is the same old story we've been having
> > since forever: people don't really love to fix bugs, especially if the
> > code works for them and the bug doesn't appear on their boxes.
> > 
> > > Perhaps someone has comments or proposals for change (in the way of
> > > work or me).
> > 
> > Yeah, we need a big bad assh*le :) who screams at everyone until their
> > bugs is fixed.
> > 
> > But serioulsy, this hasn't changed: we definitely need a regression
> > list, I think it works even better when Linus goes over it and says
> > this is fixed, that is this commit, etc. because he pulls all the trees
> > in the end, ... so yeah, I think what you guys are doing is good and
> > important.
> > 
> > It would be even cooler if this list be expanded also to regressions in
> > kernel performance which people have noticed from running benchmarks on
> > different -rcs and have noticed differences there, maybe a website (not
> > bugzilla) which lists all those regressions for interested parties to
> > fix in addition to the LKML mails..., etc...
> > 
> > Thanks for your hard work, btw.
> 
> 
> Borislav,  Bjorn Helgaas: thank you for the answer, but observing the 
> reactions I get the impression that tracking the regression is not likely 
> anyone's interest. In addition - especially on the last release cycle - 
> sometimes encountered difficulties in cooperation on this topic with developers: 
> ignoring request to update the status of the regression, or even add your e-
> mail to bugzilla.

Well, sounds like you've already decided and that's just sad :(. Let's
add some more people to Cc, see what they think.

Guys, thread starts here: http://lkml.org/lkml/2012/3/23/31

> I give up tracking the regression, but not the kernel testing. Even now I have 
> a few hours per week more for it.

Well, if you still can report your results from it, I think maintainers
who are still interested in the quality of their code will be interested
in your testing reports.

Thanks again for your work.

-- 
Regards/Gruss,
    Boris.
