Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1ESMUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:20:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab1ESMUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:20:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Date: Thu, 19 May 2011 14:20:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
References: <201105181047.17309.arnd@arndb.de> <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
In-Reply-To: <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191420.33269.arnd@arndb.de>
X-Provags-ID: V02:K0:cu7Ye2OgWjUlPnApGZiyB7ZcwHDRfkSEDbE7OLM1aKd
 T5rQvvsWmZd9GolsiZHgKDEfzAV6N7c4y6YI6YehRZMP9D2ShK
 uZZdOkM3WEF8WLJ/xPghcA+1f/Z17uWlXsR+A9aQ5C6TdLm5Of
 f3urg10G5fXjqf3KY81LDPrJ+Y1Xjs8a1U6dSJXz4hVqHUdjbz
 29QNRF7NKpkJgUdn+7w1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011, Barry Song wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8fce5e6..942d052 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -630,6 +630,17 @@ S: Maintained
> >  F:     drivers/amba/
> >  F:     include/linux/amba/bus.h
> >
> > +ARM SUBARCHITECTURES
> > +M:     Arnd Bergmann <arnd@arndb.de>
> > +M:     Nicolas Pitre <nico@fluxnic.net>
> > +M:     Thomas Gleixner <tglx@linutronix.de>
> > +M:     arm@kernel.org
> > +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > +S:     MAINTAINEDftp.arm.linux.org.uk Git - linux-2.6-arm.git/summary
> > +F:     arch/arm/mach-*/
> > +F:     arch/arm/plat-*/
> > +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git
> > +
> 
> does it mean if we want to add a new SoC plat/mach, we will send
> patches againest this tree?

You should submit it for inclusion into this tree, but as a new branch
(or multiple branches) forked off from the mainline tree. We will make sure
it cleanly merges with the other subarchitectures.

> will this tree merge into rmk's tree? then rmk's tree will only manage
> arm common codes?

We'll see. My current idea is that we will push all subarchitecture branches
upstream to Linus directly, while Russell pushes the core branch(es) upstream
in parallel, but the master branch of the subarch tree could end up pulling
in the core tree as well, in order to make life easier for Stephen's
linux-next tree that needs both. This depends to some degree on whether
Russell wants to keep some subarchitectures in his own tree, or we put all
of them in the new subarch tree.

	Arnd
