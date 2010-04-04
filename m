Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0DDNWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 09:22:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54854 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753255Ab0DDNWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 09:22:32 -0400
Date: Sun, 4 Apr 2010 15:22:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Philippe Troin <phil@fifi.org>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
Message-ID: <20100404132223.GA1346@ucw.cz>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com> <201003310125.26266.laurent.pinchart@ideasonboard.com> <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com> <20100401165606.GA1677@ucw.cz> <87aatn9k7j.fsf@old-tantale.fifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aatn9k7j.fsf@old-tantale.fifi.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Do you mean the dmesg output ?
> > > A full dmesg is included in this address :
> > > http://pastebin.com/8XU619Uk
> > > Not in all suspend/hibernate the problem comes, only in some of them
> > > and this included dmesg output is just after a non working case of
> > > webcam fault.
> > > 
> > > 
> > > I also have found this in `/var/log/messages | grep uvcvideo`
> > > Mar 31 00:31:16 linux-l365 kernel: [399905.714743] usbcore:
> > > deregistering interface driver uvcvideo
> > > Mar 31 00:31:24 linux-l365 kernel: [399914.121386] uvcvideo: Found UVC
> > > 1.00 device LG Webcam (0c45:62c0)
> > > Mar 31 00:31:24 linux-l365 kernel: [399914.135661] usbcore: registered
> > > new interface driver uvcvideo
> > 
> > Also try unloading uvcvideo before suspend and reloading it after
> > resume...
> 
> I have a similar problem with a Creative Optia webcam.
> 
> I have found that removing the ehci_hcd module and reinserting it
> fixes the problem.
> 
> If your kernel ships with ehci_hcd built-in (F11 and later), the
> script included also fixes the problem (it rebind the device).
> 
> Of course, I'd love to see this issue fixed.

If unload/reload of uvcvideo helps, it is most likely problem in that.

If unload/reload of ehci_hcd is needed, it is most likely ehci problem.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
