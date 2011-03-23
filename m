Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1CWIQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:16:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52501 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1CWIQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FfB3+dvjKYCwGc3rLJIQf2wWey3MmEgH8ha9vSQY7rBX8oe27fqJVKq827BDyYPFmj
         qjm7tbPxbhh545/+Q1o+ALjiplg7gZkWODKAMqpMXpHO3F6/MFrCM2MBINcLCNKD82b+
         G8l8CjDKM7VK4nxClAv7JI0BBmMGaQ43nrotI=
MIME-Version: 1.0
In-Reply-To: <1300864998.3522.71.camel@thor.local>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
Date: Wed, 23 Mar 2011 18:16:18 +1000
Message-ID: <AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/23 Michel Dänzer <michel@daenzer.net>:
> On Mit, 2011-03-23 at 04:18 +0000, Dave Airlie wrote:
>>
>> One radeon, 2 core fixes, and an interface update to allow for > 2 crtcs
>> in vblank.
>
> [...]
>
>> Ilija Hadzic (1):
>>       drm/kernel: vblank wait on crtc > 1
>
> This patch was still being debated yesterday, are you deliberately
> pushing it regardless? Once it hits mainline, it'll be pretty much set
> in stone.

>From what I can see it was the userspace patches being debated, this
one seemed fine and the interface looked okay to me.

Dave.
