Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0JFEsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:48:32 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:63043 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0JFEsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:48:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
From: Micki Balanga <micki@n-trig.com>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "gregkh@suse.de" <gregkh@suse.de>,
        "jim.collar@eqware.net" <jim.collar@eqware.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] USB: misc: Add N-trig firmware driver
Thread-topic: [PATCH] USB: misc: Add N-trig firmware driver
Thread-index: Acti0OWpN7rr5r0+RhetTRfWBmmSEQAgJO2AABhmRYAAKf84kAAH4ZaAACW0TlA=
Date: Wed, 06 Oct 2010 04:47:24 +0000
Message-id: <6EF693376E00E2458E26FEC229232B128AB242@Exchange2010-IL.n-trig.com>
References: <6EF693376E00E2458E26FEC229232B128A8D39@Exchange2010-IL.n-trig.com>
 <20101004011949.GA23855@kroah.com>
 <alpine.LRH.2.00.1010041458010.12867@twin.jikos.cz>
 <6EF693376E00E2458E26FEC229232B128AAE23@Exchange2010-IL.n-trig.com>
 <20101005124637.GB2943@kroah.com>
In-reply-to: <20101005124637.GB2943@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [172.16.1.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, October 05, 2010 2:47 PM
> To: Micki Balanga
> Cc: Jiri Kosina; gregkh@suse.de; jim.collar@eqware.net; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
> 
> On Tue, Oct 05, 2010 at 06:59:43AM +0000, Micki Balanga wrote:
> >
> >
> > > -----Original Message-----
> > > From: Jiri Kosina [mailto:jkosina@suse.cz]
> > > Sent: Monday, October 04, 2010 2:58 PM
> > > To: Greg KH
> > > Cc: Micki Balanga; gregkh@suse.de; jim.collar@eqware.net; linux-
> > > usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
> > >
> > > On Sun, 3 Oct 2010, Greg KH wrote:
> > >
> > > > >
> > > >
> > > > Can you please attach this in a non-base64 format so it can be
> > > properly
> > > > reviewed, and then, applied if applicable?
> > > >
> > > > Note, please run the patch through the scripts/checkpatch.pl tool
> > > first
> > > > before sending it out, so we don't just say the same things it
> finds
> > > :)
> > >
> > > As we already have HID driver for n-trig, could this whole thing
> > > perhaps
> > > be made part of it?
> > >
> > > --
> > > Jiri Kosina
> > > SUSE Labs, Novell Inc.
> >
> > The driver communicates with the bulk in/out endpoint.
> 
> Why does it have to be a driver at all?  Why can't you just use libusb
> or usbfs to implement this?

The driver is used for several debug applications we use and libusb or usbfs caused us several problem.
we also run on several platform. The user space application which communicate with the driver
is common for several OS. 
> 
> > It was written as a standalone module, because it does not use any
> HID
> > subsystem services, and to ensure that the HID driver would not be
> too
> > complex.
> >
> > The driver has been tested over several weeks at our company.
> > The  patch was prepared and checked using the Checkpatch utility.
> 
> You might want to check that last step, it didn't seem to work properly
> as the patch you sent could not be applied, due to it being base64
> encoded :)
> 
> thanks,
> 
> greg k-h
