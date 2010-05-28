Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0E1NJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:09:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44983 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab0E1NJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:09:41 -0400
Message-ID: <4BFFC5DF.5030504@nokia.com>
Date: Fri, 28 May 2010 16:32:15 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Brian Swetland <swetland@google.com>
CC: ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>	<20100527220949.GB10602@srcf.ucam.org>	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>	<20100527223605.GB11364@srcf.ucam.org>	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>	<20100528043114.GC26177@thunk.org>	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>	<20100528114123.GA22947@srcf.ucam.org>	<4BFFB681.1000105@nokia.com> <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
In-Reply-To: <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 13:09:05.0509 (UTC) FILETIME=[F3469950:01CAFE66]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Brian Swetland wrote:

> At a certain point, if one side of the argument is using "N900 / OMAP3
> works just fine as is" (which has certainly been the case stated by a
> number of folks throughout these discussions), I think it's a little
> unrealistic to express shock that somebody argues the opposing point.
>   
The problem lies in the definition of the goal and means to achieve it.
We do rely on repositories to discriminate on the quality of applications.
As I stated some are accessible and run by our community.

So, in this scenario, it works well enough.

> I've personally avoided commenting on specific power management issues
> or properties of competitive platforms because it can easily be viewed
> as rather rude or unprofessional.  (though in theory we all could
> benefit from any improvements to the kernel regarding power
> management, no?).
>   

What I consider plain wrong i to claim that since there are this many 
units out, some code should be merged.
A company needs to cut corners sometimes when making a product but this 
should not affect upstream code.
> I am quite willing to state that on both MSM and OMAP based Android
> platforms, we've found that the suspend blocker model allows us to
> obtain a lower average power draw than if we don't use it -- Mike Chan
> provided some numbers earlier in another thread in the trivial device
> idle case, the win is of course much larger in the case of several
> poorly behaved apps being active.
>   

That's very good. But if it is done in a conceptually flawed way, some 
better solution should be considered for upstream merge.

[snip]
> A reality of a mass market device with a completely open and
> unrestricted application development and distribution ecosystem is
> that there will be plenty of non-optimal apps available to users
> (Sturgeon's Law applies everywhere, after all).  Worse yet, many of
> these non-optimal apps may be beloved by users for various reasons.  I
> think there's value in trying to do the best you can power-wise even
> in the face of such horrible foes as the dreaded Bouncing Cows App
> that Matthew is fond of citing as an example.

Sure.

I simply disagree on the methods proposed (suspend_blockers) and some of 
the rationale used for promoting them (volume of otherwise unsupported 
units).

igor
