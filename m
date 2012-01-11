Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2AKIhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:37:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2AKIhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:37:13 -0500
Date: Wed, 11 Jan 2012 09:36:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Olof Johansson <olof@lixom.net>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc
 tree
In-Reply-To: <CAOesGMh0W1hvpySB8jtVBojZtoniHXur98Bzq1Feh3vAD4CkOg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201110933480.1191@axis700.grange>
References: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au>
 <CAOesGMh0W1hvpySB8jtVBojZtoniHXur98Bzq1Feh3vAD4CkOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:2dLp/CRZWBSC2mEPm6gp+z8mYb9fV8bwETbvDgskynC
 A5aFfT9Fn6ZvgJAhdsp3fTgC3hvGvkQr+ZXRaTgBYAaMvI7sF4
 fDj8QsWIfHPOPKqCctmyvhwH9SlIrGFnTYC9++/WxtlFR748f8
 q43ox03MKluskThvdR+qqdPS75SdndYROcw26Txuu94eUSh0J1
 aO8Rw8+yPZgb05+y89SJb9BXGDV5YMgu/0H8EXuhJie9p/fwYL
 eORnZXJvnVlRn5fNv64avXQJ2ANwMkB2qQvQGF1RDdUR/Q3XSX
 mKpP1V0xrY5WEoN7foCsgg/n5J7ub3Hai59keKUvcfsaXB8YU9
 c3XTrcm05RPlY+kCkSjED62hAX0CKlKmX0+q1EZiSGO9H8LJxi
 G14kVDRCVP4+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012, Olof Johansson wrote:

> On Tue, Jan 10, 2012 at 6:31 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Mauro,
> >
> > Today's linux-next merge of the v4l-dvb tree got conflicts in a large
> > number of files between commits from the arm-soc tree and commits from the
> > v4l-dvb tree.  You have rebased the v4l-dvb tree onto v3.2 while the
> > arm-soc tree had merged a previous version. you have then added a lot
> > more commits on top of the result - which produces all the conflicts.  :-(
> >
> > This is exactly the sort of pain I alluded to when I first noted that the
> > v4l-dvb tree had been merged into the arm-soc tree ...
> 
> We do this every now and then though, it's not an issue as long as
> nothing stupid is done with the dependent branch at the other end.
> I.e. if it's actually a stable branch (which we got promised that it
> was).
> 
> So, why was the whole v4l tree rebased? Guennadi, you said it was
> going to be a stable branch? What happened?

Sorry, I don't think I _promised_ anything, I even don't think I said 
anything at all about the stability of that branch. On the contrary - I 
suggested you to only take _one_ patch, about which we knew, that some ARM 
patches depended upon, for which I've got Mauro's ack. This has been done 
with the sole purpose for you to avoid any dependencies. Instead you 
decided to pull the whole branch.

> > Not happy.
> 
> No kidding.  Mauro, can you undo your rebase or should I remove the
> dependent branch (and the at91 branch that needs it) from arm-soc
> instead?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
