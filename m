Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2CZQrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:47:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60348 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2CZQrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:47:22 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Borislav Petkov <bp@alien8.de>
Subject: Re: Tracking regressions for next release(s)
Date: Mon, 26 Mar 2012 18:47:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0; KDE/4.7.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org,
        Bjorn Helgaas <bhelgaas@google.com>
References: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com> <20120323101431.GA8832@liondog.tnic>
In-Reply-To: <20120323101431.GA8832@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203261847.17521.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On piątek, 23 marca 2012 o 11:14:31 Borislav Petkov wrote:
> On Fri, Mar 23, 2012 at 07:01:19AM +0100, Maciej Rutecki wrote:
> > I am interested in the opinion of the developers, testers, and
> > everyone involved in the development of the kernel, if they thing that
> > tracking regressions and monitoring the quality makes sense,
> 
> Absolutely.
> 
> > especially since I met several times (put it mildly) dislike of such
> > work and the bugs are repaired relatively slowly.
> 
> I can imagine people getting cranky when someone points out that there's
> a "boring" bug they need to fix instead of them working on the cool new
> feature they have thought of. It is the same old story we've been having
> since forever: people don't really love to fix bugs, especially if the
> code works for them and the bug doesn't appear on their boxes.
> 
> > Perhaps someone has comments or proposals for change (in the way of
> > work or me).
> 
> Yeah, we need a big bad assh*le :) who screams at everyone until their
> bugs is fixed.
> 
> But serioulsy, this hasn't changed: we definitely need a regression
> list, I think it works even better when Linus goes over it and says
> this is fixed, that is this commit, etc. because he pulls all the trees
> in the end, ... so yeah, I think what you guys are doing is good and
> important.
> 
> It would be even cooler if this list be expanded also to regressions in
> kernel performance which people have noticed from running benchmarks on
> different -rcs and have noticed differences there, maybe a website (not
> bugzilla) which lists all those regressions for interested parties to
> fix in addition to the LKML mails..., etc...
> 
> Thanks for your hard work, btw.


Borislav,  Bjorn Helgaas: thank you for the answer, but observing the 
reactions I get the impression that tracking the regression is not likely 
anyone's interest. In addition - especially on the last release cycle - 
sometimes encountered difficulties in cooperation on this topic with developers: 
ignoring request to update the status of the regression, or even add your e-
mail to bugzilla.

I give up tracking the regression, but not the kernel testing. Even now I have 
a few hours per week more for it.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
