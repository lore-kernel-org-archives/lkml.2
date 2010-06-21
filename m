Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0FVLO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:14:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46633 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502Ab0FVLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:14:27 -0400
Date: Mon, 21 Jun 2010 17:57:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve Hj?nnev?g <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100621155749.GD1447@ucw.cz>
References: <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
 <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
 <20100527140655.GA28048@srcf.ucam.org>
 <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
 <20100527155201.GA31937@srcf.ucam.org>
 <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
 <20100527165931.GB1062@srcf.ucam.org>
 <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
 <20100527172343.GB2468@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527172343.GB2468@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(ok, so I'm little late to the party).

> > Nonsense, if we want to push the system into suspend from the idle
> > state we can do that. It's just not implemented and we've never tried
> > to do it as it requires a non trivial amount of work, but I have done
> > it on an ARM two years ago as a prove of concept and it works like a
> > charm.
> 
> ACPI provides no guarantees about what level of hardware functionality 
> remains during S3. You don't have any useful ability to determine which 
> events will generate wakeups. And from a purely practical point of view, 

We'll need ACPI extensions, then (or very conservative
drivers). suspend blockers do *not* help here.

> since the latency is in the range of seconds, you'll never have a low 
> enough wakeup rate to hit it.

I did 'sleepy linux' prototype on PC, and yes I was able to get to
'once in 5 seconds' wakeup rate... good enough...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
