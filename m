Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2CWKOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 06:14:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46818 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab2CWKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 06:14:39 -0400
Date: Fri, 23 Mar 2012 11:14:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org
Subject: Re: Tracking regressions for next release(s)
Message-ID: <20120323101431.GA8832@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, florian@mickler.org
References: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG9S4UjTtm_Zx89udbB=Qew7vToWkE_GHc_f78Q-kbOuqh4NRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 07:01:19AM +0100, Maciej Rutecki wrote:
> I am interested in the opinion of the developers, testers, and
> everyone involved in the development of the kernel, if they thing that
> tracking regressions and monitoring the quality makes sense,

Absolutely.

> especially since I met several times (put it mildly) dislike of such
> work and the bugs are repaired relatively slowly.

I can imagine people getting cranky when someone points out that there's
a "boring" bug they need to fix instead of them working on the cool new
feature they have thought of. It is the same old story we've been having
since forever: people don't really love to fix bugs, especially if the
code works for them and the bug doesn't appear on their boxes.

> Perhaps someone has comments or proposals for change (in the way of
> work or me).

Yeah, we need a big bad assh*le :) who screams at everyone until their
bugs is fixed.

But serioulsy, this hasn't changed: we definitely need a regression
list, I think it works even better when Linus goes over it and says
this is fixed, that is this commit, etc. because he pulls all the trees
in the end, ... so yeah, I think what you guys are doing is good and
important.

It would be even cooler if this list be expanded also to regressions in
kernel performance which people have noticed from running benchmarks on
different -rcs and have noticed differences there, maybe a website (not
bugzilla) which lists all those regressions for interested parties to
fix in addition to the LKML mails..., etc...

Thanks for your hard work, btw.

-- 
Regards/Gruss,
    Boris.
