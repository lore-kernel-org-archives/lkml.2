Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0KXD4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:56:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49378 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0KXD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:56:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=j9SZhVDhK4/AbEaohpZj21GiASYmd7+4ExFUWzAgiweBEGclVAGWQlG/m1rJYCPlgS
         KQ7si2EjHFpYY0kmgW2TU5u1NEQtmTe+Te/oPB63VujJmeo4VeVkilx0NvEkQP2h6ryR
         AF1x4OwPRS2TaZbqMpjNfvtcwjfFT7zn4wynY=
MIME-Version: 1.0
In-Reply-To: <1290569516.3074.41.camel@dcbw.foobar.com>
References: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com> <1290569516.3074.41.camel@dcbw.foobar.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 24 Nov 2010 14:55:50 +1100
Message-ID: <AANLkTi=ioGgpAQ-rx_abCHcOmOezXwJFfbKWc7=tGAJ5@mail.gmail.com>
Subject: Re: Re-distributable 88w8335 Firmware?
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, David.Woodhouse@intel.com,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Markus Becker <mab@comnets.uni-bremen.de>, andreamrl@tiscali.it,
        Denis Kirjanov <kirjanov@gmail.com>, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 14:31, Dan Williams <dcbw@redhat.com> wrote:
> On Sat, 2010-11-20 at 11:29 +1100, Julian Calaby wrote:
>> If we cannot obtain proper firmware files, the very least Marvel could
>> do would be to bless the *BSD Malo driver's firmware files (obtainable
>> here: http://www.nazgul.ch/malo/malo-firmware-1.4.tgz - see
>> http://www.unix.com/man-page/freebsd/4/MALO/ for more info) with a
>> proper re-distributable license.
>>
>> In terms of the actual chipsets in question, I'm referring to the
>> 88w8335, 88w8338, and 88w8385 chipsets. I believe Marvel refers to
>
> Note that the 8385 shouldn't be included in this list, since it's a
> FullMAC chip, is handled already by the 'libertas' kernel driver, and
> we've already got firmware for its CF & SDIO variants in linux-firmware
> along with the 8388, 8682, 8686, and 8688.

That'll teach me to not do all the research on this =)

I pulled that number from the Malo firmware archive linked above.
(Malo claims to only work with 8335s, but yeah) I'm guessing that if
that firmware file is used, it'd be for a PCI variant of the 8385
chipset (given that such a thing exists) and that isn't supported by
the "libertas" driver.

Either way, having the firmware for the 833x chipsets would be more
than enough =)

And thanks for reaching out to your contact. Hopefully we'll get
something useful out of this.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
