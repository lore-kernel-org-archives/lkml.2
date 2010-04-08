Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab0DHLFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 07:05:37 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57731 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758455Ab0DHLFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:05:33 -0400
Date: Thu, 8 Apr 2010 13:05:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
       maciej.rutecki@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       thommycheck@gmail.com, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org
Subject: Re: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Message-ID: <20100408110532.GA14451@atrey.karlin.mff.cuni.cz>
References: <20100313122754.GD2192@elf.ucw.cz> <20100401060624.GA1329@ucw.cz> <201004072226.34272.maciej.rutecki@gmail.com> <201004072252.08354.marek.vasut@gmail.com> <20100408044409.GA14982@elf.ucw.cz> <i2mf17812d71004080353oa8459642v33f88993eee87a99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <i2mf17812d71004080353oa8459642v33f88993eee87a99@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> > > > > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
> >> > > > > seem to even reset the framebuffer (I'm using kexec -- so it stays
> >> > > > > stuck on on previous screen).
> >> > >
> >> > > Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
> >> > > time to set up serial console, yet :-(. Any ideas?
> >> >
> >> > I created a Bugzilla entry at
> >> > https://bugzilla.kernel.org/show_bug.cgi?id=15712
> >> > for your bug report, please add your address to the CC list in there,
> >> >  thanks!
> >> >
> >> Pavel, you broke it ... and here you say something about sane arm maintainers
> >> ;-)
> >
> > ? You know which patch causes it ?
> 
> Just have some time to try this out on my corgi, and the kernel runs
> happily.
> 
> Pavel,
> 
> Which exact model are you running your kernel?

It is Zaurus SL-C3000 (aka spitz). I'm using kexec, but that used to
work. Should I try minimal config?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
