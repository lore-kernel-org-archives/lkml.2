Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1CQCOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:14:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55883 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1CQCOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:14:06 -0400
Date: Wed, 16 Mar 2011 22:14:01 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Greg KH <greg@kroah.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <20110311172345.GA10876@kroah.com>
Message-ID: <alpine.LFD.2.00.1103162207130.26889@xanadu.home>
References: <201103111331.13932.arnd@arndb.de> <20110311152938.GB29920@sirena.org.uk> <201103111654.04089.arnd@arndb.de> <20110311160308.GQ1760@opensource.wolfsonmicro.com> <20110311161421.GA7843@kroah.com> <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com> <20110311164850.GT1760@opensource.wolfsonmicro.com> <20110311165642.GA9996@kroah.com> <20110311170807.GV1760@opensource.wolfsonmicro.com> <20110311172345.GA10876@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Greg KH wrote:

> On Fri, Mar 11, 2011 at 05:08:07PM +0000, Mark Brown wrote:
> > On Fri, Mar 11, 2011 at 08:56:42AM -0800, Greg KH wrote:
> > > On Fri, Mar 11, 2011 at 04:48:50PM +0000, Mark Brown wrote:
> > 
> > > > USB itself is discoverable but the when the USB bus you're looking at is
> > > > one that's soldered down onto a board in a specific design all bets are
> > > > off regarding how complete the information you get will be.  On a basic
> > > > level the designers may have done things like omit the configuration
> > > > EEPROMs that would set the device IDs that the driver should be relying
> > > > on to identify the hardware configuration.  There may be other, nastier,
> > > > things going on.
> > 
> > > Then you use the existing platform data for your USB host controller
> > > driver.  Doesn't that work today just fine?
> > 
> > Wrong end of the bus.  This stuff is simple enough to deal with in a
> > system specific fashion, the standard solution would be to patch the
> > relevant drivers to hard code whatever is required.
> 
> What drivers need this?  Specifics please.

Let me quote Arnd Bergmann:

|I have just verified with my Pandaboard that the pins on the SMSC9514
|usb ethernet that are meant to be connected to a serial EEPROM are
|indeed not connected anywhere.

> I would brand these types of systems "extremely broken" :)

Indeed.  But to hardware people, modifying the software is always cheaper.

> Anyway, specifics are the best way forward if anyone has such a messed
> up system.

PandaBoards are becoming quite popular.


Nicolas
