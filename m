Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1CQVDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:03:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62760 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1CQVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:03:20 -0400
Date: Thu, 17 Mar 2011 17:03:17 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Greg KH <greg@kroah.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <20110317201320.GB4035@kroah.com>
Message-ID: <alpine.LFD.2.00.1103171647560.26889@xanadu.home>
References: <201103111654.04089.arnd@arndb.de> <20110311160308.GQ1760@opensource.wolfsonmicro.com> <20110311161421.GA7843@kroah.com> <20110311162759.GS1760@opensource.wolfsonmicro.com> <20110311163522.GA9291@kroah.com> <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com> <20110311170807.GV1760@opensource.wolfsonmicro.com> <20110311172345.GA10876@kroah.com> <alpine.LFD.2.00.1103162207130.26889@xanadu.home> <20110317201320.GB4035@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Greg KH wrote:

> On Wed, Mar 16, 2011 at 10:14:01PM -0400, Nicolas Pitre wrote:
> > > What drivers need this?  Specifics please.
> > 
> > Let me quote Arnd Bergmann:
> > 
> > |I have just verified with my Pandaboard that the pins on the SMSC9514
> > |usb ethernet that are meant to be connected to a serial EEPROM are
> > |indeed not connected anywhere.
> > 
> > > Anyway, specifics are the best way forward if anyone has such a messed
> > > up system.
> > 
> > PandaBoards are becoming quite popular.
> 
> I have one right here.
> 
> But can't this device be detected by the usb device id and the quirk
> added that way?  Like all other "odd" USB devices are currently handled?

It is not the device which is odd, but rather the environment in which 
it is being used for this specific case.  I'd expect to see the same 
SMSC9514 chip also used in off-the-shelf USB-to-Ethernet dongles with no 
quirks needed.

However, a different part of the kernel knows already perfectly well 
when it is actually running on that specific board.  Hence the desire to 
come up with a mechanism allowing to tell the driver about a quirk for 
the particular device instance on this board without having to do the 
heavy round trip through user space.


Nicolas
