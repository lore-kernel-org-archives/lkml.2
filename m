Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0G3Faf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:30:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56549 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0G3Fae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:30:34 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 30 Jul 2010 11:00:13 +0530
Subject: RE: patch "Staging: ti-st: update ABI and TODO" added to
	staging-next tree
Thread-Topic: patch "Staging: ti-st: update ABI and TODO" added to
	staging-next tree
Thread-Index: AcsvLmCimCD4WIk4S8SB49DsHsfLvwAeQTfw
Message-ID: <19F8576C6E063C45BE387C64729E7394044EE521B9@dbde02.ent.ti.com>
References: <12803306292159@site>
 <19F8576C6E063C45BE387C64729E7394044EE51EF4@dbde02.ent.ti.com>
 <20100729145302.GB20709@suse.de>
In-Reply-To: <20100729145302.GB20709@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, July 29, 2010 9:53 AM
> To: Savoy, Pavan
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: patch "Staging: ti-st: update ABI and TODO" added to staging-next tree
> 
> On Thu, Jul 29, 2010 at 12:49:59PM +0530, Savoy, Pavan wrote:
> > Greg,
> >
> >
> > > -----Original Message-----
> > > From: gregkh@suse.de [mailto:gregkh@suse.de]
> > > Sent: Wednesday, July 28, 2010 10:24 AM
> > > To: Savoy, Pavan; gregkh@suse.de
> > > Subject: patch "Staging: ti-st: update ABI and TODO" added to staging-next tree
> >
> > Is it good enough to be moved out of staging?
> 
> I don't know, I haven't reviewed it.  Do you want me to do so?  It looks
> like you still have a number of things on your TODO list, why not
> resolve those first?

The major thing on the TODO list was this multiple device support.
The rest is taken care, I will send out a patch to update the TODO itself!!
So, Please review and provide comment as to what should be done to move it out of staging into may be drivers/misc? or mfd/ suggest a suitable place holder too.

> > I mean the multi-device thingy would be more or less a nice to have
> > feature than being a bug, isn't it?
> 
> I don't think Alan thinks so.

As Alan mentioned this is currently un-testable since we don't have such platforms with multiple of these connectivity chipsets.

> > The ease for me would be once out of staging, I can cleanup the
> > platform device mess too, since our L-O tree needs to be have some
> > patches in the arch/arm/board-XX.c sort of files...
> 
> Promises to clean up code after it leaves staging is generally not a
> good idea :)

Not a clean up as such but pending patches such as addition of the platform device into the arch/arm/mach-omap2/board-4430sdp.c file or board-zoom2.c file.
Or the V4L2 FM drivers for the FM core on chip, which makes use of this ldisc..
This is to make sure that any Linux release built for such boards have this driver up and running for the device.

I have cleaned-up all I can, I suppose :)

> thanks,
> 
> greg k-h
