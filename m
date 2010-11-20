Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0KTA3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:29:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34497 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0KTA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=LT/7SsmhQFO6Q/vVM/NErdIsLPK7lVUpVSHfSqq37ap6MqQX3sZXPygrbUvBtcN5r4
         A8HtFw+cfyXzv+UONPpsNHWpVp+KNup0USCLuelu6Whmw1VfUzDPGxd69QLG+MibyPVW
         ocniwWOinoH5EncohXMjmBxUJ6dz9cBeKpFQY=
MIME-Version: 1.0
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 20 Nov 2010 11:29:12 +1100
Message-ID: <AANLkTim0=ds3EhQOEfHdrKt2dSnEqUgf5CLOPHNyW=jE@mail.gmail.com>
Subject: Re-distributable 88w8335 Firmware?
To: Dan Williams <dcbw@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David.Woodhouse@intel.com, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Markus Becker <mab@comnets.uni-bremen.de>, andreamrl@tiscali.it,
        Denis Kirjanov <kirjanov@gmail.com>, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Once again, someone is trying to build a working driver for the Marvel
88w8335 chipset, and is once again hampered by a lack of
re-distributable or official firmware. (See:
http://marc.info/?l=linux-wireless&m=128923265210125&w=2 )

As such, on Denis's behalf, I'm asking if anyone knows of anyone at
Marvel that they can poke in an attempt to get a re-distributable
firmware for this chipset released for eventual inclusion into
linux-firmware.

I believe that this chipset is pretty much obsolete (being only an
802.11g part) so I cannot see any reasonable reason not to release the
firmware, especially given that newer chipsets ("TopDog" - see the
mwl8k driver) have had re-distributable firmware released along with
open source Linux drivers for some time now.

If we cannot obtain proper firmware files, the very least Marvel could
do would be to bless the *BSD Malo driver's firmware files (obtainable
here: http://www.nazgul.ch/malo/malo-firmware-1.4.tgz - see
http://www.unix.com/man-page/freebsd/4/MALO/ for more info) with a
proper re-distributable license.

In terms of the actual chipsets in question, I'm referring to the
88w8335, 88w8338, and 88w8385 chipsets. I believe Marvel refers to
them as being part of the "Libertas" family of chipsets - however they
don't have the fancy mesh stuff that the chips the libertas driver
talks to have - and are also PCI.

A previous effort in 2008 is viewable here:
http://lwn.net/Articles/275719/ and searching for "mrv8k" reveals the
remnants of that effort which mostly happened before my involvement in
this.

A proper "official" set of firmware files would smooth one of the
bumps in getting proper support for this driver into the Linux Kernel.
(as well as helping the BSD folks with the Malo driver) Marvel has
shown that they are willing to provide some support for the open
source community with the TopDog driver, as well as the driver for the
SAS chipset. Hopefully they can continue their support with what would
be a small gesture in support of our efforts to write a driver for
this old chipset.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
