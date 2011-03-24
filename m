Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1CXLbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:31:34 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:57368 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab1CXLb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:31:29 -0400
Date: Thu, 24 Mar 2011 06:31:17 -0500 (CDT)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: Dave Airlie <airlied@gmail.com>
cc: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
In-Reply-To: <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
Message-ID: <Pine.GSO.4.62.1103240628490.1156@umail>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
 <1300864998.3522.71.camel@thor.local> <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
 <1300868532.3522.81.camel@thor.local> <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
 <Pine.GSO.4.62.1103230633160.12612@umail> <1300880747.16522.13.camel@thor.local>
 <AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-1804928587-1300966277=:1156"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-1804928587-1300966277=:1156
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


OK, I'll update libdrm side to match this change and send the patch later=
=20
today

-- Ilija

On Thu, 24 Mar 2011, Dave Airlie wrote:

> 2011/3/23 Michel D=E4nzer <michel@daenzer.net>:
>> On Mit, 2011-03-23 at 06:40 -0500, Ilija Hadzic wrote:
>>> On Wed, 23 Mar 2011, Dave Airlie wrote:
>>>
>>>> 2011/3/23 Michel D=E4nzer <michel@daenzer.net>:
>>>>> On Mit, 2011-03-23 at 18:16 +1000, Dave Airlie wrote:
>>>>>> 2011/3/23 Michel D=E4nzer <michel@daenzer.net>:
>>>>>>> On Mit, 2011-03-23 at 04:18 +0000, Dave Airlie wrote:
>>>>>>>>
>>>>>>>> One radeon, 2 core fixes, and an interface update to allow for > 2=
 crtcs
>>>>>>>> in vblank.
>>>>>>>
>>>>>>> [...]
>>>>>>>
>>>>>>>> Ilija Hadzic (1):
>>>>>>>> =A0 =A0 =A0 drm/kernel: vblank wait on crtc > 1
>>>>>>>
>>>>>>> This patch was still being debated yesterday, are you deliberately
>>>>>>> pushing it regardless? Once it hits mainline, it'll be pretty much =
set
>>>>>>> in stone.
>>>>>>
>>>>>> From what I can see it was the userspace patches being debated, this
>>>>>> one seemed fine and the interface looked okay to me.
>>>>>
>>>>> The author ignored my suggestions to make the patch smaller and simpl=
er,
>>>>> more maintainable and more future-proof all at once.
>>>>
>>>> It was already small and I'm not sure merging the flags made it more
>>>> maintainable. Its always
>>>> being a slightly painful ioctl, and hopefully any future changes add a
>>>> new ioctl esp if we want 64-bit values.
>>>>
>>>> The only comment I really thought was necessary was changing the CAP
>>>> name, but since that isn't
>>>> part of the ABI (just the number) we can quickly fix it with a follow-=
up.
>>>>
>>>> Dave.
>>>
>>> All of the issues debated yesterday, except one, boil down to renaming =
a
>>> handful on #defines without changing the values nor interface nor behav=
ior
>>> of the kernel.
>>
>> No, one central point is not to leave two holes between
>> _DRM_VBLANK_FLAGS_MASK, _DRM_VBLANK_HIGH_CRTC_MASK and
>> _DRM_VBLANK_TYPES_MASK .
>
> Okay I've pushed this to my tree before this discussion got on my
> radar and I'm just catching up now.
>
> I'll push the following patch to Linus to keep the biggest gap in the
> 32-bit word for future use, then
> we can fixup the userspace patches.
>
> Kernel interfaces aren't considered unchangeable usually on the kernel
> is released.
>
> Dave.
>
---559023410-1804928587-1300966277=:1156--
