Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0KXFLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:11:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0KXFLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:11:53 -0500
Subject: Re: Re-distributable 88w8335 Firmware?
From: Dan Williams <dcbw@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, David.Woodhouse@intel.com,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Markus Becker <mab@comnets.uni-bremen.de>, andreamrl@tiscali.it,
        Denis Kirjanov <kirjanov@gmail.com>, dwmw2@infradead.org
Date: Tue, 23 Nov 2010 23:10:56 -0600
In-Reply-To: <AANLkTi=0ocvsR185Qib3VoT43ziTUa_3oRDnmU65pYjv@mail.gmail.com>
References: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com>
	 <1290569516.3074.41.camel@dcbw.foobar.com>
	 <AANLkTi=ioGgpAQ-rx_abCHcOmOezXwJFfbKWc7=tGAJ5@mail.gmail.com>
	 <1290571986.3074.64.camel@dcbw.foobar.com>
	 <AANLkTi=0ocvsR185Qib3VoT43ziTUa_3oRDnmU65pYjv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1290575460.18917.3.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 15:48 +1100, Julian Calaby wrote:
> On Wed, Nov 24, 2010 at 15:13, Dan Williams <dcbw@redhat.com> wrote:
> > On Wed, 2010-11-24 at 14:55 +1100, Julian Calaby wrote:
> >> On Wed, Nov 24, 2010 at 14:31, Dan Williams <dcbw@redhat.com> wrote:
> >> > On Sat, 2010-11-20 at 11:29 +1100, Julian Calaby wrote:
> >> >> If we cannot obtain proper firmware files, the very least Marvel could
> >> >> do would be to bless the *BSD Malo driver's firmware files (obtainable
> >> >> here: http://www.nazgul.ch/malo/malo-firmware-1.4.tgz - see
> >> >> http://www.unix.com/man-page/freebsd/4/MALO/ for more info) with a
> >> >> proper re-distributable license.
> >> >>
> >> >> In terms of the actual chipsets in question, I'm referring to the
> >> >> 88w8335, 88w8338, and 88w8385 chipsets. I believe Marvel refers to
> >> >
> >> > Note that the 8385 shouldn't be included in this list, since it's a
> >> > FullMAC chip, is handled already by the 'libertas' kernel driver, and
> >> > we've already got firmware for its CF & SDIO variants in linux-firmware
> >> > along with the 8388, 8682, 8686, and 8688.
> >>
> >> That'll teach me to not do all the research on this =)
> >>
> >> I pulled that number from the Malo firmware archive linked above.
> >> (Malo claims to only work with 8335s, but yeah) I'm guessing that if
> >> that firmware file is used, it'd be for a PCI variant of the 8385
> >> chipset (given that such a thing exists) and that isn't supported by
> >> the "libertas" driver.
> >
> > Malo supports the PCMCIA/CF variant of the 8385; not a PCI variant
> > AFAICT.  I know of no PCI variant for the 8385, just CF, SDIO, and GSPI.
> > But I find it curious that malo supports 8335+8385, given that the
> > firmware interface of the 8385 and the 8335 are so different.  Unless
> > they have special firmware, the 8385 is a fullmac device, while the 8335
> > is a softmac device.  Enough differences exist that I'd expect them to
> > be driven by separate drivers, otherwise the code would be quite ugly.
> > Which is why we didn't try to shoehorn the 8335 or TopDog stuff into
> > libertas.
> 
> You clearly know a hell of a lot more about the ins and outs of Marvel
> chipsets that I do. =)

Eh, *some* of the chipsets :)  Others (Lennert) know a lot more about
later versions than I do.  But I never know everything or even enough of
anything :)

> I stand corrected.
> 
> So, to amend my previous request: We're after firmware for the softmac
> 88w8335 chipset *only*.
> 
> Though it may be nicer if Marvell were to bless Malo's firmware
> package (linked above) as this contains firmware for the PCI 88w8335,
> USB 88w8338 and a file which claims to be for the PCMCIA/CF 88w8385.

Yeah, though honestly I'd rather have the duplex firmware from MSSII for
the 8335, since it can do AP mode too.  That does leave the 8338 (USB?)
of course but we can probably get clarification on that too.  As with
the 8335, I only have access to a 8335 Windows driver, but if we had a
firmware extractor tool, I believe the Marvell Extranet firmware license
covers embedded firmware from Windows .sys files too.

And I think I might actually have a usb8338 too somewhere...

Dan


