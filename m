Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0HAGYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:24:45 -0400
Received: from swm.pp.se ([212.247.200.143]:42099 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0HAGYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:24:44 -0400
Date: Sun, 1 Aug 2010 08:24:43 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100801054816.GI2470@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.1008010812450.24755@uplift.swm.pp.se>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010, Paul E. McKenney wrote:

> available to do the programming and how valuable power-awareness is for 
> the application in question.  Given that people who program PC-class 
> applications are much more common than are people who program with 
> energy efficiency in mind, the power-naive choice will be attractive in 
> many cases.

I own a Nokia N900. Some applications are ported straight from regular 
Linux and they're definitely power-naive, as they have little or no 
optimization for mobile. I agree that this is not "sloppy" or "bad", it's 
just that mobile (low power) wasn't the intended target of the application 
when it was written, and this commonly shows.

Just like some people will burn CPU cycles by writing their application in 
a high-level language because it requires fewer man-hours and that you get 
thousands of cpu-hours for the cost of a man-hour programming the thing 
(often by externalising the true cost of power which makes power even less 
of a problem), not caring much about power is rational behaviour when 
creating an application for pc.

Just look at flash ads, they consume huge amounts of power and they 
commonly never stop. I imagine that the power used by PCs around the world 
displaying web pages with advertising with the monitor in power-save mode 
(powered down) can be counted in gigawatts. When I need my battery to last 
on my laptop I make sure I don't have any unneccessary tabs enabled 
because it seriously affects my battery time. I think laptop users would 
benefit from more power optimized applications as well, so if the OS could 
do the same for laptop/desktop use as well (spending less time on programs 
updating display when the display is off), I think there are real world 
benefits for every desktop/laptop/mobile user.

If nothing else, it's environmentally friendly.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
