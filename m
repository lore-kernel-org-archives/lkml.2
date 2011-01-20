Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1ATSzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:55:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45117 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1ATSzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ojLjiDbT8N3cEJy5UkqEy1VJunRhFNp5i926kOmS1yauoIF/Pc2F99VbJQrilO//uz
         VVI0n0yQZXpFcNZPqfd/p1209O7iyD50IYtww6v4SMBRWNizGQETr/ECdsb7Jy7MmOeP
         GIG8NLMSMKjRJOyiBSPyHigBiy8/UwnClr188=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2Tx7M4=wF7GkQZLFe5=JLGv2G7roavKroWZ78@mail.gmail.com>
References: <1295338561.2003.3.camel@sven> <1295338738-4129-1-git-send-email-s.neumann@raumfeld.com>
 <4D357DC0.2030006@metafoo.de> <AANLkTi=gGDZHukdSuupg22Gb9te+Vk_rsu6-vREeQRVE@mail.gmail.com>
 <1295387347.20633.3.camel@bender> <AANLkTi=2Tx7M4=wF7GkQZLFe5=JLGv2G7roavKroWZ78@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 20 Jan 2011 13:55:25 -0500
Message-ID: <AANLkTinOgeshyM6RFJQSFXYQecsvucoMCrr_SduS+QCA@mail.gmail.com>
Subject: Re: [PATCH] pxa3xx: fix PXA GPIO IRQ handling
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Lennert Buijtenhek <buytenh@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 1:48 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Tue, Jan 18, 2011 at 4:49 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
>> On Tue, 2011-01-18 at 08:15 -0800, Eric Miao wrote:
>>> On Tue, Jan 18, 2011 at 3:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> > On 01/18/2011 09:18 AM, Sven Neumann wrote:
>>> >> From: Lars-Peter Clausen <lars@metafoo.de>
>>> >>
>>> >> Set the "set_wake" field of the irq_chip struct before calling
>>> >> set_irq_chip() for all of the IRQs, so that the compat handler
>>> >> actually gets installed.
>>>
>>> Not really sure if this is necessary. Lennert has done the transition to
>>> irq_data to those _set_wake() functions as well, so it should be OK
>>> that compat handler doesn't get installed.
>>>
>>> Now I'm not against moving this above, just wondering if there were
>>> any consequences/errors coming out?
>>
>> Well, our PXA300 device doesn't power up again when it should resume
>> from suspend. Fine with me if this has been fixed upstream,
>
> Yeah, that's true. Mind re-post with your SOB?

And Cc linux-stable.

>
>> but I would
>> still like to get this patch into 2.6.37. I'll try to test upstream as
>> soon as Linus releases 2.6.38-rc1...

That's will be great help.

>>
>>
>> Sven
>>
>>
>>
>
