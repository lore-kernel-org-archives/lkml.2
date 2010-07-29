Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887Ab0G2P7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:59:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:54718 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0G2P7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:59:01 -0400
Date: Thu, 29 Jul 2010 16:58:57 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Mattia Jona-Lasinio <mattia.jona@gmail.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lcd-linux-users@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>
Subject: Re: Introducing the LCD-Linux project
In-Reply-To: <AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1007291617290.7618@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com> <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk> <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com> <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
 <loom.20100724T155117-833@post.gmane.org> <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com> <AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> <geert@linux-m68k.org> wrote:
> > On Sat, Jul 24, 2010 at 16:43, Florian Tobias Schandinat
> > <FlorianSchandinat@gmx.de> wrote:
> >> Mattia Jona-Lasinio <mattia.jona <at> gmail.com> writes:
> >>> Moreover I wanted something that COULD be used as a console but not
> >>> necessarily, that is
> >>> something that could run happily in the presence of a normal monitor
> >>> as well. It seems to me, but I may be
> >>> wrong, that through the standard console system only the current
> >>> visible console is actually updated
> >>> while other consoles are just "software" updated. An external LCD
> >>> would therefore be updated
> >>> only when you "switch" to it, so it would not be possible to use it to
> >>> display diagnostics.
> >>
> >> True, that's a general problem one has when multiple framebuffers exist.
> >> Therefore I'd be very happy if someone could come up with a general solution.
> >
> > Fixing that was (one of the) goal of the linux-console project. James?
> 
> Hmmm, the linux-console project seems to be dead. There are no file
> releases after nearly ten
> years and the CVS is three years old.

	We never did file releases. Mostly people just checked out cvs 
and then built and tested out the kernel. At first it was a massive
project which covered several areas. That tree was used as a staging 
ground for the input api and the new fbdev api. We even for a time had had 
the serial api that you find drivers/serial. All of that has been made 
main stream :-) Then we saw graphics cards all becoming agp and mother 
boards with multiple apg slots where extremely rare. So interest in the 
project died off. Now with usb and pcie plus graphics cards with multiple 
crtcs its is becoming possible again. 
	Recently I have been looking at and working on the DRI mode setting api
since it covers the bulk of the graphics cards out there for the PC market which
are pcie which means the possiblity of multiple graphics cards in 
parrallel. You are not the only one looking at this solution.  

> Implementing this  in the standard Linux terminal emulation
> would require
> a rewrite of most of the code, which I personally would do only if
> there is some interest from
> the community in improving the standard Linux console, and I don't
> think it is the case
> looking at the age of the Linux console project. So I decided to keep
> it separate.
> But never say never! In the future the two consoles could merge in a
> single one. ;)

Hum. Only in the last year have I started to see a interest in this area 
again. A few months ago someone else was discussing with me the 
limitations of the linux console system. I have a few drm changes I like 
to push first for the next merge widow. Perhaps if Andrew Morton is 
willing to merge the my linuxconsole git tree into his -mm branch for wide 
area testing then I can start the linux console stuff up again. Currently 
my console git tree has no commits. Its just a raw tree. BTW yes it is 
alot of work to cleanup the console system.


