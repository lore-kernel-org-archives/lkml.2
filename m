Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0JEMx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:53:26 -0400
Received: from kroah.org ([198.145.64.141]:52164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0JEMxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:53:25 -0400
Date: Tue, 5 Oct 2010 05:46:37 -0700
From: Greg KH <greg@kroah.com>
To: Micki Balanga <micki@n-trig.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "gregkh@suse.de" <gregkh@suse.de>,
        "jim.collar@eqware.net" <jim.collar@eqware.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
Message-ID: <20101005124637.GB2943@kroah.com>
References: <6EF693376E00E2458E26FEC229232B128A8D39@Exchange2010-IL.n-trig.com>
 <20101004011949.GA23855@kroah.com>
 <alpine.LRH.2.00.1010041458010.12867@twin.jikos.cz>
 <6EF693376E00E2458E26FEC229232B128AAE23@Exchange2010-IL.n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6EF693376E00E2458E26FEC229232B128AAE23@Exchange2010-IL.n-trig.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 06:59:43AM +0000, Micki Balanga wrote:
> 
> 
> > -----Original Message-----
> > From: Jiri Kosina [mailto:jkosina@suse.cz]
> > Sent: Monday, October 04, 2010 2:58 PM
> > To: Greg KH
> > Cc: Micki Balanga; gregkh@suse.de; jim.collar@eqware.net; linux-
> > usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
> > 
> > On Sun, 3 Oct 2010, Greg KH wrote:
> > 
> > > >
> > >
> > > Can you please attach this in a non-base64 format so it can be
> > properly
> > > reviewed, and then, applied if applicable?
> > >
> > > Note, please run the patch through the scripts/checkpatch.pl tool
> > first
> > > before sending it out, so we don't just say the same things it finds
> > :)
> > 
> > As we already have HID driver for n-trig, could this whole thing
> > perhaps
> > be made part of it?
> > 
> > --
> > Jiri Kosina
> > SUSE Labs, Novell Inc.
> 
> The driver communicates with the bulk in/out endpoint. 

Why does it have to be a driver at all?  Why can't you just use libusb
or usbfs to implement this?

> It was written as a standalone module, because it does not use any HID
> subsystem services, and to ensure that the HID driver would not be too
> complex. 
> 
> The driver has been tested over several weeks at our company.
> The  patch was prepared and checked using the Checkpatch utility.

You might want to check that last step, it didn't seem to work properly
as the patch you sent could not be applied, due to it being base64
encoded :)

thanks,

greg k-h
