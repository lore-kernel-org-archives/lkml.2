Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0KPU7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:59:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab0KPU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:59:43 -0500
Subject: Re: nouveau build failure (was Re: Linux 2.6.37-rc2)
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Martin Peres <martin.peres@ensi-bourges.fr>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20101116125055.74f78634.randy.dunlap@oracle.com>
References: <AANLkTi=34dJ1HJco8gw=Y+7Ear3mC+XnahqODhnn+56u@mail.gmail.com>
	 <20101116125055.74f78634.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 06:58:18 +1000
Message-ID: <1289941098.20058.1.camel@nisroch>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 12:50 -0800, Randy Dunlap wrote:
> On Tue, 16 Nov 2010 12:45:43 -0800 Linus Torvalds wrote:
> 
> > Looks like commit 34e9d85a1aae ("drm/nouveau: Add temperature support
> > (vbios parsing, readings, hwmon)") didn't make things properly
> > dependent on CONFIG_HWMON (or do the appropriate "select HWMON" or
> > whatever).
> > 
> > Added some collection of hopefully more relevant people to the discussion..
> > 
> >                   Linus
> 
> 
> This build error was reported for linux-next on 2010.1011 and 2010.1025,
> with no replies.
> 
> Some process fix would be nice to see.
It's actually been fixed in the nouveau tree, I have to go through and
get fixes out of it and send them to Dave.

Ben.
> 
> 
> > On Tue, Nov 16, 2010 at 12:35 PM, Zimny Lech
> > <napohybelskurwysynom2010@gmail.com> wrote:
> > >
> > >  LD      vmlinux.o
> > >  MODPOST vmlinux.o
> > > WARNING: modpost: Found 7 section mismatch(es).
> > > To see full details build your kernel with:
> > > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > >  GEN     .version
> > >  CHK     include/generated/compile.h
> > >  UPD     include/generated/compile.h
> > >  CC      init/version.o
> > >  LD      init/built-in.o
> > >  LD      .tmp_vmlinux1
> > > drivers/built-in.o: In function `nouveau_pm_fini':
> > > (.text+0xe1857): undefined reference to `hwmon_device_unregister'
> > > drivers/built-in.o: In function `nouveau_pm_init':
> > > (.text+0xe1b4d): undefined reference to `hwmon_device_register'
> > > drivers/built-in.o: In function `nouveau_pm_init':
> > > (.text+0xe1bef): undefined reference to `hwmon_device_unregister'
> > > make[1]: *** [.tmp_vmlinux1] Error 1
> > > make: *** [sub-make] Error 2
> > --
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


