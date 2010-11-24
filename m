Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0KXDdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:33:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab0KXDdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:33:01 -0500
Subject: Re: Re-distributable 88w8335 Firmware?
From: Dan Williams <dcbw@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, David.Woodhouse@intel.com,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Markus Becker <mab@comnets.uni-bremen.de>, andreamrl@tiscali.it,
        Denis Kirjanov <kirjanov@gmail.com>, dwmw2@infradead.org
Date: Tue, 23 Nov 2010 21:31:53 -0600
In-Reply-To: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com>
References: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1290569516.3074.41.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-20 at 11:29 +1100, Julian Calaby wrote:
> Hi all,
> 
> Once again, someone is trying to build a working driver for the Marvel
> 88w8335 chipset, and is once again hampered by a lack of
> re-distributable or official firmware. (See:
> http://marc.info/?l=linux-wireless&m=128923265210125&w=2 )
> 
> As such, on Denis's behalf, I'm asking if anyone knows of anyone at
> Marvel that they can poke in an attempt to get a re-distributable
> firmware for this chipset released for eventual inclusion into
> linux-firmware.
> 
> I believe that this chipset is pretty much obsolete (being only an
> 802.11g part) so I cannot see any reasonable reason not to release the
> firmware, especially given that newer chipsets ("TopDog" - see the
> mwl8k driver) have had re-distributable firmware released along with
> open source Linux drivers for some time now.
> 
> If we cannot obtain proper firmware files, the very least Marvel could
> do would be to bless the *BSD Malo driver's firmware files (obtainable
> here: http://www.nazgul.ch/malo/malo-firmware-1.4.tgz - see
> http://www.unix.com/man-page/freebsd/4/MALO/ for more info) with a
> proper re-distributable license.
> 
> In terms of the actual chipsets in question, I'm referring to the
> 88w8335, 88w8338, and 88w8385 chipsets. I believe Marvel refers to

Note that the 8385 shouldn't be included in this list, since it's a
FullMAC chip, is handled already by the 'libertas' kernel driver, and
we've already got firmware for its CF & SDIO variants in linux-firmware
along with the 8388, 8682, 8686, and 8688.

Dan

> them as being part of the "Libertas" family of chipsets - however they
> don't have the fancy mesh stuff that the chips the libertas driver
> talks to have - and are also PCI.
> 
> A previous effort in 2008 is viewable here:
> http://lwn.net/Articles/275719/ and searching for "mrv8k" reveals the
> remnants of that effort which mostly happened before my involvement in
> this.
> 
> A proper "official" set of firmware files would smooth one of the
> bumps in getting proper support for this driver into the Linux Kernel.
> (as well as helping the BSD folks with the Malo driver) Marvel has
> shown that they are willing to provide some support for the open
> source community with the TopDog driver, as well as the driver for the
> SAS chipset. Hopefully they can continue their support with what would
> be a small gesture in support of our efforts to write a driver for
> this old chipset.
> 
> Thanks,
> 


