Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0KXF0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:26:25 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0KXF0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:26:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lfwOnXwd3IffoUrPseTNVZIm38EODi/U51yshz0ysCXSjp5v78CaEkiSyPMjVT9vaJ
         dVDB/KhHLAop+po0TI4bNKKk2h7cjPzzc+yKRD/3atl4SMk6rNZZ4xX/DtRcPk2Oezjb
         F6va48KoPjSiNmgbhEJy2gmrJs2+gVpmq2tF8=
MIME-Version: 1.0
In-Reply-To: <1290575460.18917.3.camel@dcbw.foobar.com>
References: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com>
 <1290569516.3074.41.camel@dcbw.foobar.com> <AANLkTi=ioGgpAQ-rx_abCHcOmOezXwJFfbKWc7=tGAJ5@mail.gmail.com>
 <1290571986.3074.64.camel@dcbw.foobar.com> <AANLkTi=0ocvsR185Qib3VoT43ziTUa_3oRDnmU65pYjv@mail.gmail.com>
 <1290575460.18917.3.camel@dcbw.foobar.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 24 Nov 2010 16:26:02 +1100
Message-ID: <AANLkTiks65oAvVEu0Df4yeHNJm=cVnSfFeo=enxt-gpn@mail.gmail.com>
Subject: Re: Re-distributable 88w8335 Firmware?
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, David.Woodhouse@intel.com,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Markus Becker <mab@comnets.uni-bremen.de>, andreamrl@tiscali.it,
        Denis Kirjanov <kirjanov@gmail.com>, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 16:10, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2010-11-24 at 15:48 +1100, Julian Calaby wrote:
>> On Wed, Nov 24, 2010 at 15:13, Dan Williams <dcbw@redhat.com> wrote:
>> > Malo supports the PCMCIA/CF variant of the 8385; not a PCI variant
>> > AFAICT.  I know of no PCI variant for the 8385, just CF, SDIO, and GSPI.
>> > But I find it curious that malo supports 8335+8385, given that the
>> > firmware interface of the 8385 and the 8335 are so different.  Unless
>> > they have special firmware, the 8385 is a fullmac device, while the 8335
>> > is a softmac device.  Enough differences exist that I'd expect them to
>> > be driven by separate drivers, otherwise the code would be quite ugly.
>> > Which is why we didn't try to shoehorn the 8335 or TopDog stuff into
>> > libertas.
>>
>> You clearly know a hell of a lot more about the ins and outs of Marvel
>> chipsets that I do. =)
>
> Eh, *some* of the chipsets :)  Others (Lennert) know a lot more about
> later versions than I do.  But I never know everything or even enough of
> anything :)

I know exactly how you feel. =)

>> I stand corrected.
>>
>> So, to amend my previous request: We're after firmware for the softmac
>> 88w8335 chipset *only*.
>>
>> Though it may be nicer if Marvell were to bless Malo's firmware
>> package (linked above) as this contains firmware for the PCI 88w8335,
>> USB 88w8338 and a file which claims to be for the PCMCIA/CF 88w8385.
>
> Yeah, though honestly I'd rather have the duplex firmware from MSSII for
> the 8335, since it can do AP mode too.  That does leave the 8338 (USB?)

Me too - and it'd mean that we don't have to do AP-mode firmware
loading tricks like in mw8k. But if we can't get that then some
firmware is better than none.

> of course but we can probably get clarification on that too.  As with
> the 8335, I only have access to a 8335 Windows driver, but if we had a
> firmware extractor tool, I believe the Marvell Extranet firmware license
> covers embedded firmware from Windows .sys files too.

I think I may have a simple firmware extractor at home that I pulled
from *somewhere* when I was working on this last time. We can see if
it does anything with those files. I believe I have at least two
different Windows drivers at home - IIRC, one of them is *just* the
files needed for this extractor.

> And I think I might actually have a usb8338 too somewhere...

Nice!

Out of curiosity, what brand and model number is it? I might see if I
can obtain one for testing / development or whatever. (Not that I
really have time to write a driver, but I can test at the very least)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
