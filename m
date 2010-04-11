Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab0DKHxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 03:53:13 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:43984 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050Ab0DKHxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 03:53:12 -0400
Date: Sun, 11 Apr 2010 09:53:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>
Cc: thommycheck@gmail.com, lenz@cs.wisc.edu, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Marek Vasut <marek.vasut@gmail.com>,
       rpurdie@rpsys.net, Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel@lists.infradead.org, maciej.rutecki@gmail.com
Subject: Re: [Zaurus-devel] [regression] 2.6.34-rc1 to -rc3 on zaurus: no
	longer boots
Message-ID: <20100411075300.GC1534@ucw.cz>
References: <20100408110533.GA14451@atrey.karlin.mff.cuni.cz> <20100408154749.GE3269@jama> <20100408204204.GA26902@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408204204.GA26902@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > It is Zaurus SL-C3000 (aka spitz). I'm using kexec, but that used to
> > > work. Should I try minimal config?
> > 
> > FYI:
> > 
> > I've just booted on my spitz 2.6.34-rc3 built with OE (config from Andrea), then kexec to 2.6.33.
> > http://git.openembedded.org/cgit.cgi/openembedded/commit/?id=adadb0343015894e33032b53d87e3e03a368a594
> > 

Ok, so I could only find 

> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.33-rc6
> # Tue Feb  9 22:56:42 2010
> #

33-rc6 config there. I tried my best answers, and got config
(attached), but that one still does not boot :-(.
								Pavel
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
