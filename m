Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0GCT5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 15:57:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36905 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0GCT5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 15:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VrAK5N0XefQmEyLs8jPoRwkAsQmzMQ7N8H5YXMy6/w9rA0uQAFQ2Lk+kA3WLZoBx+/
         vcYBJ/liL5S6NUgezZDnqB5M3jPewQ/ABDI2q4RPAxbmAqmPg7siTO8urSQxF3GnnqN+
         n6rrI0BbHpOsnSptZEjSF39N674zTIgfODrfg=
MIME-Version: 1.0
In-Reply-To: <4C2F9292.708@hardwarefreak.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F87C1.8000701@hardwarefreak.com>
	<AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>
	<4C2F9292.708@hardwarefreak.com>
Date: Sat, 3 Jul 2010 12:57:44 -0700
Message-ID: <AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 3, 2010 at 12:42 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Mark Knecht put forth on 7/3/2010 2:21 PM:
>
>> Note two things:
>>
>> 1) All the drives are always reported by BIOS at boot time. Now, that
>> doesn't guarantee that the drives spin up. It may only mean they can
>> be read by BIOS, but they are there as far as I can tell. They show up
>> in the boot screens and in BIOS itself if I drop in to play with
>> settings.
>
> I missed that.  I thought I read it was both.  My bad.
>

Not a problem. It's good to be as clear as possible for all involved.

>> QUESTION: There are some settings in BIOS for delaying the drive. (Or
>> something. I'm using the machine and not in BIOS) There were settings
>> from 0 to 35 seconds if I remember correctly. Possibly I should try
>> setting each drive to a different value to different value to stagger
>> power up?
>
> If that PSU meets published specs you shouldn't need delayed spin up with
> those 5 drives.
>

I've not dropped into BIOS yet as the machine is in use but from the
Asus manual it appears the delay is not on a drive by drive basis so I
don't think I can do much there.

>> If you need more info or have other ideas please let me know.
>
> Your answers here should have pretty much eliminated hardware issues as the
> cause, unless that particular mobo has BIOS or other issues I'm unaware of.
>
> I've found it's always best to ask about hardware with this kind of report
> just to eliminate possibilities.  All that gear is good quality stuff.  If the
> problem is due to hardware, it's because one of your components is defective,
> but we don't see evidence of that at this point.
>
> Also, TTBOMK, if a SATA drive motor doesn't spin up, the drive firmware won't
> report the drive as ready upstream, thus the BIOS won't list the drive.

An off-list response suggested possibly setting some drive jumpers on
non-boot drives to power up in standby. Apparently the kernel will
then spin up those drives later? If I cannot stagger the drives in
BIOS then I will likely try that. Technically I guess I only need
/boot on sda to get the kernel booted. The mdadm RAID1 on sda/sdb/sdc
could start slightly later, and technically the RAID0 on sdd/sde could
start very late as there are only VMWare images on that drive.

Cheers,
Mark
