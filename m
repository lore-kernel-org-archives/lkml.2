Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0INHMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:12:54 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51027 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751848Ab0INHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:12:52 -0400
Date: Tue, 14 Sep 2010 09:12:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Felipe Balbi <me@felipebalbi.com>,
        Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>,
        "matthias.nyman@nokia.com" <matthias.nyman@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2]
 input: CMA3000 Accelerometer driver)
Message-ID: <20100914071244.GA2672@ucw.cz>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <20100829184904.GC26209@core.coreip.homeip.net>
 <36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>
 <20100830214025.2f9677a1@lxorguk.ukuu.org.uk>
 <20100830204412.GA28711@core.coreip.homeip.net>
 <AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>
 <20100830214355.GB28865@core.coreip.homeip.net>
 <AANLkTinPConD62Ky7mvMn2ZgS=V9+Q5YUdaF5Vma8mn+@mail.gmail.com>
 <20100830224352.GF28865@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830224352.GF28865@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> (or GPS device, for that matter) really be?
> > >
> > > But why GPS should be input device? It has nothing to do with user
> > > input.
> > 
> > What? OF COURSE it is an input driver. It's the user moving the device
> > around. It's EXACTLY the same thing as an accelerometer in that
> > respect. Sure, it's a bit less precise and measures movement wrt some
> > external frame, but technically they are almost exactly the same.
> > 
> > If you se doing a navigation app, the accelerometer, the compass and
> > the GPS are all equally (but differently) important.
> > 
> > Again - it's not a user touching buttons. But it IS a user moving around.
> 
> Right, but do you expect that movement to cause an immediate action?
> When you press a key - something happens; when you swing a Wii
> controller - the device reacts. And really you can swap joysticks,
> motion controllers, Sony's 6-axis and so forth and the application would
> be hard pressed to tell the difference. I am unsure how you would play a
> game with GPS as an input device.

Well, there's cross between geocaching and game called 'whereigo'; I
played it once, it is quite fun...

"You bought a horse. Check if horse was fast enough by running to the
trees you see north of you". And so you run. "Your horse is too
slow. Try again".

OTOH, for the GPS... I guess it is more complex because you have
important and non-trivial metadata, such as precisions, fix type,
#sats used and their positions. So NMEA might be right interface for
that...

...unless there are more chips like nokia n900 one that talk strange
protocols. Or should we just translate them at kernel level?

Anyway it would be good to have gps hardware abstraction one day.
       	  	   	   	    	     		     Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
