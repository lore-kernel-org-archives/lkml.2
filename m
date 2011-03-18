Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1CRT1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:27:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58667 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756866Ab1CRT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:26:53 -0400
Date: Fri, 18 Mar 2011 15:26:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-usb@vger.kernel.org, <xfs@oss.sgi.com>,
        <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <alpine.DEB.2.02.1103181346340.21715@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1103181523500.14876-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, Justin Piszcz wrote:

> > The stick didn't "fail" in any obvious way, but for some reason it was
> > disconnected from the USB bus.  (If it initiated that disconnect by
> > itself, I guess you could consider that a failure.)  Maybe it was
> > something as simple as overheating causing a loss of electrical contact
> > between the connector and the pins in the USB port.
> 
> It is possible, but the box is kept cool:

Then something else caused the disconnection.  Maybe a bug in the USB 
stick's firmware.

> >> Mar 18 08:33:06 atom [ 2283.963059] usb 1-1: new high speed USB device using ehci_hcd and address 4
> >> Mar 18 08:33:06 atom [ 2284.080647] usb 1-1: New USB device found, idVendor=0325, idProduct=ac02
> >> Mar 18 08:33:06 atom [ 2284.080707] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >> Mar 18 08:33:06 atom [ 2284.080752] usb 1-1: Product: R2_TURBO
> >> Mar 18 08:33:06 atom [ 2284.080794] usb 1-1: Manufacturer: OCZ Technology
> >> Mar 18 08:33:06 atom [ 2284.080831] usb 1-1: SerialNumber: (removed)
> >
> > And then 22 seconds later it reconnected.
> >
> > Alan Stern
> >
> 
> Very strange, could some USB option cause this?

No.

>  I guess next step is use
> ext2 and a different stick in the same port to see if I can get it to recur.
> Then if it happens again, try a different port.

Okay, go ahead and see what happens.

Alan Stern

