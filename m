Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab0DHEoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:44:21 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46408 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829Ab0DHEoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:44:18 -0400
Date: Thu, 8 Apr 2010 06:44:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, maciej.rutecki@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, thommycheck@gmail.com,
       dbaryshkov@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       eric.y.miao@gmail.com, zaurus-devel@www.linuxtogo.org
Subject: Re: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
Message-ID: <20100408044409.GA14982@elf.ucw.cz>
References: <20100313122754.GD2192@elf.ucw.cz>
 <20100401060624.GA1329@ucw.cz>
 <201004072226.34272.maciej.rutecki@gmail.com>
 <201004072252.08354.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004072252.08354.marek.vasut@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-04-07 22:52:08, Marek Vasut wrote:
> Dne St 7. dubna 2010 22:26:34 Maciej Rutecki napsal(a):
> > On czwartek, 1 kwietnia 2010 o 08:06:25 Pavel Machek wrote:
> > > Hi!
> > >
> > > > > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
> > > > > seem to even reset the framebuffer (I'm using kexec -- so it stays
> > > > > stuck on on previous screen).
> > >
> > > Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
> > > time to set up serial console, yet :-(. Any ideas?
> > 
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=15712
> > for your bug report, please add your address to the CC list in there,
> >  thanks!
> > 
> Pavel, you broke it ... and here you say something about sane arm maintainers 
> ;-)

? You know which patch causes it ?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
