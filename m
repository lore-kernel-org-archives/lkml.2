Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0JEHAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:00:54 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:60407 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab0JEHAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:00:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
From: Micki Balanga <micki@n-trig.com>
To: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "jim.collar@eqware.net" <jim.collar@eqware.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] USB: misc: Add N-trig firmware driver
Thread-topic: [PATCH] USB: misc: Add N-trig firmware driver
Thread-index: Acti0OWpN7rr5r0+RhetTRfWBmmSEQAgJO2AABhmRYAAKf84kA==
Date: Tue, 05 Oct 2010 06:59:43 +0000
Message-id: <6EF693376E00E2458E26FEC229232B128AAE23@Exchange2010-IL.n-trig.com>
References: <6EF693376E00E2458E26FEC229232B128A8D39@Exchange2010-IL.n-trig.com>
 <20101004011949.GA23855@kroah.com>
 <alpine.LRH.2.00.1010041458010.12867@twin.jikos.cz>
In-reply-to: <alpine.LRH.2.00.1010041458010.12867@twin.jikos.cz>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [172.16.1.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Monday, October 04, 2010 2:58 PM
> To: Greg KH
> Cc: Micki Balanga; gregkh@suse.de; jim.collar@eqware.net; linux-
> usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] USB: misc: Add N-trig firmware driver
> 
> On Sun, 3 Oct 2010, Greg KH wrote:
> 
> > >
> >
> > Can you please attach this in a non-base64 format so it can be
> properly
> > reviewed, and then, applied if applicable?
> >
> > Note, please run the patch through the scripts/checkpatch.pl tool
> first
> > before sending it out, so we don't just say the same things it finds
> :)
> 
> As we already have HID driver for n-trig, could this whole thing
> perhaps
> be made part of it?
> 
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.

The driver communicates with the bulk in/out endpoint. 

It was written as a standalone module, because it does not use any HID subsystem services, 
and to ensure that the HID driver would not be too complex. 

The driver has been tested over several weeks at our company.
The  patch was prepared and checked using the Checkpatch utility.

I await your input as to how you wish to proceed.
Micki

