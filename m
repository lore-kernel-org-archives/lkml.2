Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1ALPzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:55:31 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:36482 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1ALPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:55:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hu37hkxB2oqAIxj7H6NZPD1Dol++KBVyAgavcs8UVnYWzxdur0YGVyzNbm1W3B5urf
         bG4rQQxx1DyZ6aHYWyoRE65cQAnyeeolbDV5YCSIXvlIh41qnP03rKo5tisMTOTbSnE1
         Hq1VWuYGHB6pRQRqIQkhQeNgEb7si7HOsj8CU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101121538470.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<4D2CE5C8.60601@de.ibm.com>
	<AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
	<4D2D8ED0.6080807@de.ibm.com>
	<AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
	<alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
	<AANLkTimdnYHWfBE1nB+2EDRouO7_FoRByVboMYw8WaHB@mail.gmail.com>
	<AANLkTik=HYzW8--_W+qxi8S9QbAkf9ZZy=uLyaTeV+PC@mail.gmail.com>
	<alpine.LFD.2.00.1101121538470.8212@casper.infradead.org>
Date: Wed, 12 Jan 2011 17:55:27 +0200
Message-ID: <AANLkTimtd9nGKrnMJJQyRbF3=n3S5yfKJs6MBwUYObD1@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 5:40 PM, James Simmons <jsimmons@infradead.org> wrote:
>
>> >>> I tested the revert: the boot screen did change the resolution
>> >>> (without it don't), but my PC still hangs. (using an nvidia 8800GT).
>> >>
>> >> Try my most recent patch. Where does it hang at? Any logs?
>> >>
>> >
>> > With your patch, I can boot the system. But nouveau is not loaded.
>> > dmesg attached.
>> >
>>
>> Forget to mention: the revert makes first steps of boot look the same
>> (change the resolution of the text)
>> but with your patch, I see a big ugly ununtu logo, (I think that is
>> because nouveau is not loaded)
>
> Is nouveau a module? Does X run? From my understanding is the xorg driver

I didn't modified any option, from the standard Ubuntu 10.10

> need KMS to run. I didn't see nouveau at all in your dmesg.

Exact. I mentioned this when I tested 'next' versions from last year.
The answer is in dfe63bb0ad9810db13aab0058caba97866e0a681.
