Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab0KPUvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:51:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17938 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0KPUvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:51:50 -0500
Date: Tue, 16 Nov 2010 12:50:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Martin Peres <martin.peres@ensi-bourges.fr>,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nouveau build failure (was Re: Linux 2.6.37-rc2)
Message-Id: <20101116125055.74f78634.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=34dJ1HJco8gw=Y+7Ear3mC+XnahqODhnn+56u@mail.gmail.com>
References: <AANLkTi=34dJ1HJco8gw=Y+7Ear3mC+XnahqODhnn+56u@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 12:45:43 -0800 Linus Torvalds wrote:

> Looks like commit 34e9d85a1aae ("drm/nouveau: Add temperature support
> (vbios parsing, readings, hwmon)") didn't make things properly
> dependent on CONFIG_HWMON (or do the appropriate "select HWMON" or
> whatever).
> 
> Added some collection of hopefully more relevant people to the discussion..
> 
>                   Linus


This build error was reported for linux-next on 2010.1011 and 2010.1025,
with no replies.

Some process fix would be nice to see.


> On Tue, Nov 16, 2010 at 12:35 PM, Zimny Lech
> <napohybelskurwysynom2010@gmail.com> wrote:
> >
> >  LD      vmlinux.o
> >  MODPOST vmlinux.o
> > WARNING: modpost: Found 7 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >  GEN     .version
> >  CHK     include/generated/compile.h
> >  UPD     include/generated/compile.h
> >  CC      init/version.o
> >  LD      init/built-in.o
> >  LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `nouveau_pm_fini':
> > (.text+0xe1857): undefined reference to `hwmon_device_unregister'
> > drivers/built-in.o: In function `nouveau_pm_init':
> > (.text+0xe1b4d): undefined reference to `hwmon_device_register'
> > drivers/built-in.o: In function `nouveau_pm_init':
> > (.text+0xe1bef): undefined reference to `hwmon_device_unregister'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [sub-make] Error 2
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
