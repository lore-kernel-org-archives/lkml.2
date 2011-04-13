Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1DMNne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:43:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42580 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1DMNnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D4rvU3gB9NJHWDIvhYSuGEAInT/f8dSBqfc4PMrqaeNfrLPoE4L14hnZPOo4hhihJT
         iBJF9qXSWwGzCEHNBeOEjsM1mPuWgK9GDH4OxnVv5dLY9NJf6MasIxTV+BSJCdhWB7bQ
         9mD0zmQEfOyWJPWMpoL/1LPP7ajm7i4enz/Y0=
MIME-Version: 1.0
In-Reply-To: <20110413132821.GA1874@ucw.cz>
References: <20110315192111.GA2983@ucw.cz>
	<AANLkTikJD3+HSoHbq2BxAyYbtGik8QizuRv=rkPEtJXN@mail.gmail.com>
	<20110412193943.GA30089@elf.ucw.cz>
	<BANLkTimTmhXYHYOQwh_Q1uohFJdaKecJkA@mail.gmail.com>
	<20110413132821.GA1874@ucw.cz>
Date: Wed, 13 Apr 2011 17:43:32 +0400
Message-ID: <BANLkTineXxkP3PnSswxR8hVPxfni549Jaw@mail.gmail.com>
Subject: Re: [Zaurus-devel] 8250 vs pxa_serial (was Re: pxa27x/spitz: serials
 in recent kernels)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>,
        Andrea Adami <andrea.adami@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 5:28 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > I cculd not get serial port to work in recent kernels (2.6.35 was
>> >> > oldest I tried). I know they are little used but still very useful for
>> >> > debugging.
>> >> >
>> >> > Is there some special config that needs to be done?
>> >> >                                                        Pavel
>> >>
>> >> I have output on ttyS0 using the Sharp cable, never had issues.
>> >> Remember that bootloader is 9600n8 while kernels are usually 115200n8.
>> >
>> > Ok, I know what is going on. I need both PXA_SERIAL and 8250... and
>> > these two don't go well together.
> ...
>> > ...but no luck. As soon as I enable 8250, pxa serials stop working
>> > :-(.
>>
>> Please try attached patch (then PXA consoles become ttySA0-3)
>
> Thanks, this works for me. Can we get it into the tree?

This depends on Eric and Russell. IIRC such patches were declined
before.

-- 
With best wishes
Dmitry
