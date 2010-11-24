Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0KXEOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:14:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab0KXEOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:14:00 -0500
Subject: Re: Re-distributable 88w8335 Firmware?
From: Dan Williams <dcbw@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, David.Woodhouse@intel.com,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Markus Becker <mab@comnets.uni-bremen.de>, andreamrl@tiscali.it,
        Denis Kirjanov <kirjanov@gmail.com>, dwmw2@infradead.org
Date: Tue, 23 Nov 2010 22:13:04 -0600
In-Reply-To: <AANLkTi=ioGgpAQ-rx_abCHcOmOezXwJFfbKWc7=tGAJ5@mail.gmail.com>
References: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com>
	 <1290569516.3074.41.camel@dcbw.foobar.com>
	 <AANLkTi=ioGgpAQ-rx_abCHcOmOezXwJFfbKWc7=tGAJ5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1290571986.3074.64.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 14:55 +1100, Julian Calaby wrote:
> On Wed, Nov 24, 2010 at 14:31, Dan Williams <dcbw@redhat.com> wrote:
> > On Sat, 2010-11-20 at 11:29 +1100, Julian Calaby wrote:
> >> If we cannot obtain proper firmware files, the very least Marvel could
> >> do would be to bless the *BSD Malo driver's firmware files (obtainable
> >> here: http://www.nazgul.ch/malo/malo-firmware-1.4.tgz - see
> >> http://www.unix.com/man-page/freebsd/4/MALO/ for more info) with a
> >> proper re-distributable license.
> >>
> >> In terms of the actual chipsets in question, I'm referring to the
> >> 88w8335, 88w8338, and 88w8385 chipsets. I believe Marvel refers to
> >
> > Note that the 8385 shouldn't be included in this list, since it's a
> > FullMAC chip, is handled already by the 'libertas' kernel driver, and
> > we've already got firmware for its CF & SDIO variants in linux-firmware
> > along with the 8388, 8682, 8686, and 8688.
> 
> That'll teach me to not do all the research on this =)
> 
> I pulled that number from the Malo firmware archive linked above.
> (Malo claims to only work with 8335s, but yeah) I'm guessing that if
> that firmware file is used, it'd be for a PCI variant of the 8385
> chipset (given that such a thing exists) and that isn't supported by
> the "libertas" driver.

Malo supports the PCMCIA/CF variant of the 8385; not a PCI variant
AFAICT.  I know of no PCI variant for the 8385, just CF, SDIO, and GSPI.
But I find it curious that malo supports 8335+8385, given that the
firmware interface of the 8385 and the 8335 are so different.  Unless
they have special firmware, the 8385 is a fullmac device, while the 8335
is a softmac device.  Enough differences exist that I'd expect them to
be driven by separate drivers, otherwise the code would be quite ugly.
Which is why we didn't try to shoehorn the 8335 or TopDog stuff into
libertas.

Dan

> Either way, having the firmware for the 833x chipsets would be more
> than enough =)
> 
> And thanks for reaching out to your contact. Hopefully we'll get
> something useful out of this.
> 
> Thanks,
> 


