Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab1CQVdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:33:10 -0400
Received: from kroah.org ([198.145.64.141]:51909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab1CQVdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:33:03 -0400
Date: Thu, 17 Mar 2011 14:32:45 -0700
From: Greg KH <greg@kroah.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317213245.GB16065@kroah.com>
References: <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
 <20110311172345.GA10876@kroah.com>
 <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
 <20110317201320.GB4035@kroah.com>
 <alpine.LFD.2.00.1103171647560.26889@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103171647560.26889@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:03:17PM -0400, Nicolas Pitre wrote:
> On Thu, 17 Mar 2011, Greg KH wrote:
> 
> > On Wed, Mar 16, 2011 at 10:14:01PM -0400, Nicolas Pitre wrote:
> > > > What drivers need this?  Specifics please.
> > > 
> > > Let me quote Arnd Bergmann:
> > > 
> > > |I have just verified with my Pandaboard that the pins on the SMSC9514
> > > |usb ethernet that are meant to be connected to a serial EEPROM are
> > > |indeed not connected anywhere.
> > > 
> > > > Anyway, specifics are the best way forward if anyone has such a messed
> > > > up system.
> > > 
> > > PandaBoards are becoming quite popular.
> > 
> > I have one right here.
> > 
> > But can't this device be detected by the usb device id and the quirk
> > added that way?  Like all other "odd" USB devices are currently handled?
> 
> It is not the device which is odd, but rather the environment in which 
> it is being used for this specific case.  I'd expect to see the same 
> SMSC9514 chip also used in off-the-shelf USB-to-Ethernet dongles with no 
> quirks needed.
> 
> However, a different part of the kernel knows already perfectly well 
> when it is actually running on that specific board.  Hence the desire to 
> come up with a mechanism allowing to tell the driver about a quirk for 
> the particular device instance on this board without having to do the 
> heavy round trip through user space.

It's not "heavy" at all, as it happens today, for every device found in
the system.

Again, we have this infrastructure to do this, in place, for this very
reason, why else would we have created it, to ignore it?

Anyway, as stated before, if someone has a specific patch for the
pandaboard, send it on, and I'll consider it.  Extra bonus points for
curse words describing the hardware people who are causing this to be
required.

thanks,

greg k-h
