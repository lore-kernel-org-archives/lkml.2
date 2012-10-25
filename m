Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab2JYTh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:37:56 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54995 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210Ab2JYThz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:37:55 -0400
Date: Thu, 25 Oct 2012 12:37:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nitin DHINGRA <nitin.dhingra@stericsson.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Anurag GUPTA-1 <anurag.gupta@stericsson.com>,
        Ingvar PALSSON <ingvar.palsson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar HJALMDAHL <par-gunnar.hjalmdahl@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mridul JAIN <mridul.jain@stericsson.com>
Subject: Re: [PATCH] staging: Add ST-Ericsson CG2900 driver
Message-ID: <20121025193751.GA27132@kroah.com>
References: <1348733648-13769-1-git-send-email-nitin.dhingra@stericsson.com>
 <20121017212051.GA30879@kroah.com>
 <3ED83A9DB3B6D94CA68BF7C03F2981D35D01B6F1FD@EXDCVYMBSTM006.EQ1STM.local>
 <20121022183727.GA31565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022183727.GA31565@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:37:27AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Oct 18, 2012 at 01:56:00PM +0200, Nitin DHINGRA wrote:
> > 
> > 
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > > Sent: Thursday, October 18, 2012 2:51 AM
> > > To: Nitin DHINGRA
> > > Cc: devel@driverdev.osuosl.org; Anurag GUPTA-1; Ingvar PALSSON; Linus
> > > WALLEIJ; Par-Gunnar HJALMDAHL; linux-kernel@vger.kernel.org; Mridul
> > > JAIN
> > > Subject: Re: [PATCH] staging: Add ST-Ericsson CG2900 driver
> > > 
> > > On Thu, Sep 27, 2012 at 01:14:08AM -0700, Nitin Dhingra wrote:
> > > > This patch adds support for the ST-Ericsson CG2900
> > > > Connectivity Combo controller (Bluetooth, FM, GPS, ANT, NFC)
> > > >
> > > > Signed-off-by: Nitin Dhingra <nitin.dhingra@stericsson.com>
> > > > Signed-off-by: Mridul Jain <mridul.jain@stericsson.com>
> > > > Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> > > > ---
> > > >  arch/arm/configs/u8500_defconfig                 |    8 +
> > > >  drivers/staging/Kconfig                          |    2 +
> > > >  drivers/staging/Makefile                         |    1 +
> > > >  drivers/staging/cg2900/Kconfig                   |   73 +
> > > >  drivers/staging/cg2900/Makefile                  |   10 +
> > > >  drivers/staging/cg2900/bluetooth/Makefile        |    9 +
> > > >  drivers/staging/cg2900/bluetooth/btcg2900.c      |  865 +++++
> > > >  drivers/staging/cg2900/bluetooth/cg2900_uart.c   | 2434 +++++++++++++
> > > >  drivers/staging/cg2900/bluetooth/hci_ldisc.c     |  645 ++++
> > > >  drivers/staging/cg2900/bluetooth/hci_uart.h      |  106 +
> > > >  drivers/staging/cg2900/include/cg2900.h          |  338 ++
> > > >  drivers/staging/cg2900/include/cg2900_audio.h    |  473 +++
> > > >  drivers/staging/cg2900/include/cg2900_hci.h      |   19 +
> > > >  drivers/staging/cg2900/mfd/Makefile              |   18 +
> > > >  drivers/staging/cg2900/mfd/cg2900_audio.c        | 3533
> > > +++++++++++++++++++
> > > >  drivers/staging/cg2900/mfd/cg2900_char_devices.c |  802 +++++
> > > >  drivers/staging/cg2900/mfd/cg2900_chip.c         | 3986
> > > ++++++++++++++++++++++
> > > >  drivers/staging/cg2900/mfd/cg2900_chip.h         |  608 ++++
> > > >  drivers/staging/cg2900/mfd/cg2900_core.c         |  730 ++++
> > > >  drivers/staging/cg2900/mfd/cg2900_core.h         |   52 +
> > > >  drivers/staging/cg2900/mfd/cg2900_lib.c          |  287 ++
> > > >  drivers/staging/cg2900/mfd/cg2900_lib.h          |   65 +
> > > >  drivers/staging/cg2900/mfd/cg2900_test.c         |  402 +++
> > > >  drivers/staging/cg2900/mfd/stlc2690_chip.c       | 1710 ++++++++++
> > > >  drivers/staging/cg2900/mfd/stlc2690_chip.h       |   47 +
> > > >  25 files changed, 17223 insertions(+), 0 deletions(-)
> > > 
> > > Please refresh my memory, why is this going into drivers/staging/ and
> > > not into the "real" part of the kernel?
> > Putting the code in staging would be convenient so that if there are
> > any design/code suggestions it would be easier to incorporate. 
> 
> I don't understand.  Have you not tried to submit this code to the
> correct location already?  If not, why not?  If so, what was the result
> of the submission?
> 
> > > Hint, a TODO file listing what is needed to do to get the code merged
> > > properly is needed here, care to make a follow-on patch adding this
> > > which will explain what to do.
> > Will do that.
> 
> I will wait for that before accepting this patch.

Ok, due to the delay, I'm dropping this patch from my queue, please
resend the whole thing when you have a TODO file for it.

thanks,

greg k-h
