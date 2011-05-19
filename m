Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1ESMNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:13:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1ESMN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:13:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Thu, 19 May 2011 14:13:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
References: <201105181047.17309.arnd@arndb.de> <20110518152237.GA26055@S2100-06.ap.freescale.net>
In-Reply-To: <20110518152237.GA26055@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191413.10480.arnd@arndb.de>
X-Provags-ID: V02:K0:g7WBKh3IXb22m/cAa/8NSl2gcMgrmFXiflnF2arR75k
 1E7eAHBVpPeg6bHeC0tvMj6ruovCeuaA0K6myQKOx5QcxzG+OU
 MqIH+PBHVt4NXqfaNKf/XLPxDDVJxIODAUd0dYnwio20t21pVE
 AmC8euFCc6IMr4dVSxc+7GZEHHlYe9sUaAWtgQ/ySIP3aiwWJH
 3XIgZuDxITILrUPilA9Wg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 May 2011, Shawn Guo wrote:
> On Wed, May 18, 2011 at 10:47:16AM +0200, Arnd Bergmann wrote:
> [...]
> > +ARM SUBARCHITECTURES
> > +M:	Arnd Bergmann <arnd@arndb.de>
> > +M:	Nicolas Pitre <nico@fluxnic.net>
> > +M:	Thomas Gleixner <tglx@linutronix.de>
> > +M:	arm@kernel.org
> > +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:	MAINTAINED
> > +F:	arch/arm/mach-*/
> > +F:	arch/arm/plat-*/
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git
> 
> Is this repository ready for use yet?  It seems not for me.

No, not yet. Once we are sure about the initial set of people in the group,
we can set up the arm@kernel.org alias and the group that lets us write
into the /pub/scm/linux/kernel/git/arm directory.

Also, I wouldn't mind changing the name, if someone comes up with a better
term than arm-subarch.git.

	Arnd
