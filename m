Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1CWJGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:06:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37862 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1CWJGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gXurxC4DFudkXUdnuVncHvN0MwV2ex4HYPQEtYH6qL9k7ax8qFJPT5eyensEpi/LjM
         sU/gov+vvbjvpQWdulyzksSSS+pl6+PBBdgK8g+eR54SeBwEPZ9ruxU3NCT0FtwAg5TW
         S5ji9q/244PI/OVC/PbZ35hXU0/1Ki6MqGcDs=
MIME-Version: 1.0
In-Reply-To: <1300868532.3522.81.camel@thor.local>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
Date: Wed, 23 Mar 2011 19:06:16 +1000
Message-ID: <AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Michel Dänzer <michel@daenzer.net>:
> On Mit, 2011-03-23 at 18:16 +1000, Dave Airlie wrote:
>> 2011/3/23 Michel Dänzer <michel@daenzer.net>:
>> > On Mit, 2011-03-23 at 04:18 +0000, Dave Airlie wrote:
>> >>
>> >> One radeon, 2 core fixes, and an interface update to allow for > 2 crtcs
>> >> in vblank.
>> >
>> > [...]
>> >
>> >> Ilija Hadzic (1):
>> >>       drm/kernel: vblank wait on crtc > 1
>> >
>> > This patch was still being debated yesterday, are you deliberately
>> > pushing it regardless? Once it hits mainline, it'll be pretty much set
>> > in stone.
>>
>> From what I can see it was the userspace patches being debated, this
>> one seemed fine and the interface looked okay to me.
>
> The author ignored my suggestions to make the patch smaller and simpler,
> more maintainable and more future-proof all at once.

It was already small and I'm not sure merging the flags made it more
maintainable. Its always
being a slightly painful ioctl, and hopefully any future changes add a
new ioctl esp if we want 64-bit values.

The only comment I really thought was necessary was changing the CAP
name, but since that isn't
part of the ABI (just the number) we can quickly fix it with a follow-up.

Dave.
Dave.
