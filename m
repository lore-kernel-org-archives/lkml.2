Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0KLRzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:55:37 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:53369
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288Ab0KLRzf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:55:35 -0500
Subject: Re: PING: David Miller - SPARC64
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101103.144945.226779604.davem@davemloft.net>
References: <1288812739.12638.2.camel@lithium>
	 <20101103.144945.226779604.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Fri, 12 Nov 2010 17:53:12 +0000
Message-ID: <1289584392.26034.11.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4cdd7f8c.8fb-6996-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 14:49 -0700, David Miller wrote:

> > Can you drop me an e-mail with your current e-mail address? I need to
> > talk to you about getting the X11 fbdev driver to work on the sunxvr500
> > console framebuffer device. 
> 
> First, I don't discuss things privately with anyone about
> free software development.

Alright, thank you for setting me straight. 

> I always tell people to ask their questions on the appropriate
> mailing list, but feel free to CC: me.  That way if I am too
> busy someone else has the chance to help you.

OK. 

I have a Sun Blade 2000 here with dual 1.2GHz processors, 2 x 73GB FC-AL
disks, 4GB of RAM and a XVR-500 graphic adapter. I am quite happy with
the machine, but for one very small problem. 

It seems that the XVR-500 console driver has a few problems. If I use
the X11 fbdev 0.4.2 driver with xorg-server 1.7.7, in 8 bit colour
depth, the X11 display looks quite corrupted. I have checked and the X11
server is definitely running in 8 bit depth, same as the console. I am
using the machine in 1600 x 1280 @ 76 video mode, set from PROM. After
exiting from X11, console gets restored normally, everything works, I
just get a severely corrupted display - but I can move the mouse and use
the keyboard to log in as normal. Any ideas why what might be wrong? 

As a temporary workaround I just log onto the Blade via GDM from my
laptop and everything looks OK in 24bit @ 1600x1200. 

I cannot even get the X11 fbdev driver to start in 24 bit as the X11
fbdev driver fails with errors. Is it even possible to force the PROM to
start in 24 bit depth? 

Perhaps I could do a nouveau and find how how the XVR-500 graphic
adapter works? Just thinking things out here. 
-- 
Tactical Nuclear Kittens
