Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2DQWNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:13:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:58613 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2DQWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:13:38 -0400
Date: Wed, 18 Apr 2012 00:13:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sven Joachim <svenjoac@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel panic after suspend/resume
In-Reply-To: <CA+55aFychSQgAG8raDq9rvXm3Lq7GFdByCd3-NZERieyTdAc2g@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204180013180.2542@ionos>
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com> <87pqb6fkji.fsf@turtle.gmx.de> <CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com> <878vhufcrk.fsf@turtle.gmx.de>
 <CA+55aFychSQgAG8raDq9rvXm3Lq7GFdByCd3-NZERieyTdAc2g@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1317375203-1334700811=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1317375203-1334700811=:2542
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


On Tue, 17 Apr 2012, Linus Torvalds wrote:

> On Tue, Apr 17, 2012 at 11:12 AM, Sven Joachim <svenjoac@gmx.de> wrote:
> >
> > So far, it has repeated itself every time I suspended with 3.4-rc3,
> > i.e. three times.  That's a small sample, so the bisection might not be
> > reliable (especially since the crashes happened with delay), but I can
> > try.
> >
> >>  - how sure are you that rc2 is fine?
> >
> > Reasonably sure, I had been running rc2 for the whole last week and
> > suspended about 20 times without any problems whatsoever.
> 
> Ok, that sounds very hopeful for bisection. If it has happened three
> out of three times, it doesn't sound like it's some subtle timing
> race.

Sven, can you please provide the output of /proc/timer_list befor you
suspend ?

Thanks,

        tglx
--8323328-1317375203-1334700811=:2542--
