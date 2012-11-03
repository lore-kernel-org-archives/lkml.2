Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2KCOjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:39:03 -0400
Received: from blackhole.sdinet.de ([176.9.52.58]:51149 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2KCOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:39:00 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2012 10:39:00 EDT
Date: Sat, 3 Nov 2012 15:28:51 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Daniel Mack <zonque@gmail.com>
cc: Christof Meerwald <cmeerw@cmeerw.org>,
        "Artem S. Tashkinov" <t.artem@lycos.com>, pavel@ucw.cz,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
In-Reply-To: <50952744.4090203@gmail.com>
Message-ID: <alpine.DEB.2.02.1211031527540.28042@aurora.sdinet.de>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05> <20121020162759.GA12551@liondog.tnic> <966148591.30347.1350754909449.JavaMail.mail@webmail08> <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04> <20121103141049.GA24238@edge.cmeerw.net> <50952744.4090203@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Daniel Mack wrote:

> On 03.11.2012 15:10, Christof Meerwald wrote:
> > On Sat, 20 Oct 2012 23:15:17 +0000 (GMT), Artem S. Tashkinov wrote:
> >> It's almost definitely either a USB driver bug or video4linux driver bug:
> >>
> >> I'm CC'ing linux-media and linux-usb mailing lists, the problem is described here:
> >> https://lkml.org/lkml/2012/10/20/35
> >> https://lkml.org/lkml/2012/10/20/148
> > 
> > Not sure if it's related, but I am seeing a kernel freeze with a
> > usb-audio headset (connected via an external USB hub) on Linux 3.5.0
> > (Ubuntu 12.10) - see
> 
> Does Ubuntu 12.10 really ship with 3.5.0? Not any more recent

They ship 3.5.7 plus some more fixes, but call it 3.5.0-18.29

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
