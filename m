Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab0KPVUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:20:47 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55123 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab0KPVUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:20:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uMKfg/WoyxLuGthUL1yEX8eGJClCSJ5UG46coDQ5GBC6Vi+HYSO8pzCesP57oVmZLn
         Kfq4RqznRswhJKojjS70M3Txwyi1tyGEIFpDnkifqMWSFQ/Ibs6bCf3mwGzmExZo/JF/
         NH9vyph9ixlpHy1/lxgdc+j60cSeayNC/SMDI=
MIME-Version: 1.0
In-Reply-To: <1289941098.20058.1.camel@nisroch>
References: <AANLkTi=34dJ1HJco8gw=Y+7Ear3mC+XnahqODhnn+56u@mail.gmail.com>
	<20101116125055.74f78634.randy.dunlap@oracle.com>
	<1289941098.20058.1.camel@nisroch>
Date: Tue, 16 Nov 2010 22:20:45 +0100
Message-ID: <AANLkTikViSXMO3wSi_=2FjwQhSzmx2Lndi7tdofLeDs0@mail.gmail.com>
Subject: Re: nouveau build failure (was Re: Linux 2.6.37-rc2)
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: bskeggs@redhat.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Peres <martin.peres@ensi-bourges.fr>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salve!

2010/11/16 Ben Skeggs <bskeggs@redhat.com>:
> On Tue, 2010-11-16 at 12:50 -0800, Randy Dunlap wrote:
>> On Tue, 16 Nov 2010 12:45:43 -0800 Linus Torvalds wrote:
>>
>> > Looks like commit 34e9d85a1aae ("drm/nouveau: Add temperature support
>> > (vbios parsing, readings, hwmon)") didn't make things properly
>> > dependent on CONFIG_HWMON (or do the appropriate "select HWMON" or
>> > whatever).
>> >
>> > Added some collection of hopefully more relevant people to the discussion..
>> >
>> >                   Linus
>>
>>
>> This build error was reported for linux-next on 2010.1011 and 2010.1025,
>> with no replies.
>>
>> Some process fix would be nice to see.
> It's actually been fixed in the nouveau tree, I have to go through and
> get fixes out of it and send them to Dave.

thanks for the info

>
> Ben.
>>
>>
>> > On Tue, Nov 16, 2010 at 12:35 PM, Zimny Lech
>> > <napohybelskurwysynom2010@gmail.com> wrote:
>> > >
>> > >  LD      vmlinux.o
>> > >  MODPOST vmlinux.o
>> > > WARNING: modpost: Found 7 section mismatch(es).
>> > > To see full details build your kernel with:
>> > > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>> > >  GEN     .version
>> > >  CHK     include/generated/compile.h
>> > >  UPD     include/generated/compile.h
>> > >  CC      init/version.o
>> > >  LD      init/built-in.o
>> > >  LD      .tmp_vmlinux1
>> > > drivers/built-in.o: In function `nouveau_pm_fini':
>> > > (.text+0xe1857): undefined reference to `hwmon_device_unregister'
>> > > drivers/built-in.o: In function `nouveau_pm_init':
>> > > (.text+0xe1b4d): undefined reference to `hwmon_device_register'
>> > > drivers/built-in.o: In function `nouveau_pm_init':
>> > > (.text+0xe1bef): undefined reference to `hwmon_device_unregister'
>> > > make[1]: *** [.tmp_vmlinux1] Error 1
>> > > make: *** [sub-make] Error 2
>> > --
>>
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
>
>



-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
