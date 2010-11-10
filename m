Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0KJPUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:20:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61396 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0KJPUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:20:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rj+Vc2EC3+JAoR2ryVpz7fBAwztv/h0R3BMNd5jtuBPQyI59O/kFvitULrfJ2sRyv8
         7Bzc+Qw1bKfxntyUoLGUfuQzaE8e9rKEmNy2JjufMrSZp3GvCqryeBgf3pUFGx+dZzE3
         JZjemuypF8w44EiFilbjazZRckptTAnFYKHew=
MIME-Version: 1.0
In-Reply-To: <20101110151801.GC24305@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<20101107165745.GB1759@n2100.arm.linux.org.uk>
	<AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>
	<20101107171726.GF1759@n2100.arm.linux.org.uk>
	<20101108171930.GA1471@alchark-u3s.lan>
	<AANLkTinqpP8WN2h-kR7svZ6GZxi+0RMPBfPyMnzCpAuO@mail.gmail.com>
	<20101110151801.GC24305@n2100.arm.linux.org.uk>
Date: Wed, 10 Nov 2010 17:20:45 +0200
Message-ID: <AANLkTimBG91U8yqVpi=X0iu0ibbJihBMQYSA-y+WNqoW@mail.gmail.com>
Subject: Re: [PATCH 1/6 v4] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: saeed bishara <saeed.bishara@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 5:18 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Nov 10, 2010 at 05:16:17PM +0200, saeed bishara wrote:
>> > diff --git a/arch/arm/mach-vt8500/include/mach/uncompress.h b/arch/arm/mach-vt8500/include/mach/uncompress.h
>> > new file mode 100644
>> > index 0000000..bb9e2d2
>> > --- /dev/null
>> > +++ b/arch/arm/mach-vt8500/include/mach/uncompress.h
>> > @@ -0,0 +1,37 @@
>> > +/* arch/arm/mach-vt8500/include/mach/uncompress.h
>> > + *
>> > + * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
>> > + *
>> > + * Based on arch/arm/mach-dove/include/mach/uncompress.h
>> please  replace dove with vt8500
>
> That doesn't make sense - how can a file be created, based upon itself?
your are right, please ignore my comment.
saeed
