Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0DESgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:36:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755643Ab0DESgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:36:14 -0400
Date: Mon, 5 Apr 2010 14:36:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: 2.6.33.2: USB Quickcam Pro 9000 (usb resets)?
In-Reply-To: <alpine.DEB.2.00.1004050851560.3511@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1004051434070.1458-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Apr 2010, Justin Piszcz wrote:

> Hi,
> 
> When no webcam is used, I do not see disconnect/reconnects.
> When I use a webcam, I see the following, is this normal?
> Note: I run motion on this host.

No, it is not normal.  It indicates that the webcam is somehow 
interfering with the signals from the keyboard hub.

> [142013.089524] usb 1-1.5.1: USB disconnect, address 14
> [142013.120627] usb 1-1.5.2: USB disconnect, address 15
> [142013.209523] usb 1-1.5: reset full speed USB device using ehci_hcd and address 4
> [142013.560513] usb 1-1.5.1: new full speed USB device using ehci_hcd and address 16
> [142013.635940] usb 1-1.5.1: New USB device found, idVendor=413c, idProduct=2002
> [142013.635946] usb 1-1.5.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [142013.635950] usb 1-1.5.1: Product: Dell USB Keyboard Hub
> [142013.635952] usb 1-1.5.1: Manufacturer: Dell
> [142013.637682] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/input/input19
> [142013.637725] generic-usb 0003:413C:2002.0011: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on usb-0000:00:1a.0-1.5.1/input0
> [142013.639739] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.1/input/input20
> [142013.639825] generic-usb 0003:413C:2002.0012: input,hidraw2: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on usb-0000:00:1a.0-1.5.1/input1
> [142013.702462] usb 1-1.5.2: new low speed USB device using ehci_hcd and address 17
> [142013.781450] usb 1-1.5.2: New USB device found, idVendor=0461, idProduct=4d15
> [142013.781456] usb 1-1.5.2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
> [142013.781459] usb 1-1.5.2: Product: USB Optical Mouse
> [142013.783834] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.2/1-1.5.2:1.0/input/input21
> [142013.783878] generic-usb 0003:0461:4D15.0013: input,hidraw3: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1a.0-1.5.2/input0

Alan Stern

