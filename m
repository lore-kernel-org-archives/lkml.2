Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1DMN25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:28:57 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58831 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751402Ab1DMN24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:28:56 -0400
Date: Wed, 13 Apr 2011 15:28:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Zaurus-devel] 8250 vs pxa_serial (was Re: pxa27x/spitz:
 serials in recent kernels)
Message-ID: <20110413132821.GA1874@ucw.cz>
References: <20110315192111.GA2983@ucw.cz>
 <AANLkTikJD3+HSoHbq2BxAyYbtGik8QizuRv=rkPEtJXN@mail.gmail.com>
 <20110412193943.GA30089@elf.ucw.cz>
 <BANLkTimTmhXYHYOQwh_Q1uohFJdaKecJkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimTmhXYHYOQwh_Q1uohFJdaKecJkA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > I cculd not get serial port to work in recent kernels (2.6.35 was
> >> > oldest I tried). I know they are little used but still very useful for
> >> > debugging.
> >> >
> >> > Is there some special config that needs to be done?
> >> >                                                        Pavel
> >>
> >> I have output on ttyS0 using the Sharp cable, never had issues.
> >> Remember that bootloader is 9600n8 while kernels are usually 115200n8.
> >
> > Ok, I know what is going on. I need both PXA_SERIAL and 8250... and
> > these two don't go well together.
...
> > ...but no luck. As soon as I enable 8250, pxa serials stop working
> > :-(.
> 
> Please try attached patch (then PXA consoles become ttySA0-3)

Thanks, this works for me. Can we get it into the tree?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
