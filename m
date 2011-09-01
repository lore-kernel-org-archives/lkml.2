Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab1IAOrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:47:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55684 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757513Ab1IAOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:47:41 -0400
Date: Thu, 1 Sep 2011 10:47:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Harald Dunkel <harri@afaics.de>, <linux-usb@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.3 + Bluetooth USB Dongle: no success without noapic
In-Reply-To: <201109010801.22009.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1109011047020.1896-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Oliver Neukum wrote:

> Am Donnerstag, 1. September 2011, 07:36:10 schrieb Harald Dunkel:
> > On 08/28/11 12:07, Oliver Neukum wrote:
> > > Am Sonntag, 28. August 2011, 11:49:57 schrieb Harald Dunkel:
> 
> Hi,
> 
> > >> [   91.589073] usb 2-5: new full speed USB device number 8 using ohci_hcd [   91.709067] usb 2-5: device descriptor read/64, error -62 [   91.930059] usb 2-5: device descriptor read/64, error -62 [   92.144054] usb 2-5: new full speed USB device number 9 using ohci_hcd [   92.264073] usb 2-5:
> > >> device descriptor read/64, error -62 [   92.485064] usb 2-5: device descriptor read/64, error -62 [   92.699091] usb 2-5: new full speed USB device number 10 using ohci_hcd [   93.103040] usb 2-5: device not accepting address 10, error -62 [   93.216102] usb 2-5: new full speed USB device
> > >> number 11 using ohci_hcd [   93.620038] usb 2-5: device not accepting address 11, error -62 [   93.620072] hub 2-0:1.0: unable to enumerate USB device on port 5
> > >>
> > >> Booting with noapic fixes this problem.
> > >
> > > Do any other USB devices work on that OHCI?
> > >
> > 
> > Sorry for the delay.
> > 
> > It seems that this problem comes up by chance (with or without
> > noapic). If I move the dongle to another USB slot then the problem
> > is gone. By now the Bluetooth dongle is the only device showing this
> > problem.
> > 
> > Here is the output of lsusb with all devices plugged in and
> > working:
> > 
> > Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> > Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 002 Device 002: ID 04fc:0c15 Sunplus Technology Co., Ltd SPIF215A SATA bridge
> > Bus 001 Device 007: ID 046d:c525 Logitech, Inc. MX Revolution Cordless Mouse
> > Bus 001 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> > Bus 001 Device 009: ID 04f2:0402 Chicony Electronics Co., Ltd Genius LuxeMate i200 Keyboard
> > 
> > Removing the usb drive or the keyboard doesn't make the bluetooth
> > dongle more stable.
> 
> Voodoo. Does anybody have any ideas?

It sounds like the dongle is making a bad electrical connection, or 
there's a bad voltage, or something like that.

Alan Stern

