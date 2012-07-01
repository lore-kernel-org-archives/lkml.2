Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2GACMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 22:12:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57732 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754168Ab2GACMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 22:12:08 -0400
Date: Sat, 30 Jun 2012 22:12:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frederik Himpe <fhimpe@telenet.be>
cc: linux-kernel@vger.kernel.org, <linux-uvc-devel@lists.sourceforge.net>,
        <linux-usb@vger.kernel.org>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
In-Reply-To: <1341084110.4862.15.camel@piranha.localdomain>
Message-ID: <Pine.LNX.4.44L0.1206302209270.6344-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012, Frederik Himpe wrote:

> Hello,
> 
> I've got a Logitech HD Webcam C525 using the uvcvideo module and I use
> Linux 3.5 RC4. When this camera is connected to a USB2 port, it does not
> work most of the time. However it does work fine when connected to a USB
> 3 port. In Windows it works on both ports.

...

> Complete dmesg and lsusb -v output about a failed attempt (on USB 2
> port) and a succeeded attempt (on USB 3) can be found on
> http://artipc10.vub.ac.be/~frederik/webcam/

A usbmon trace would be more helpful.  Or perhaps a pair of traces, one 
for the USB-2 port and one for the USB-3 port.  See the instructions in 
Documentation/usb/usbmon.txt.

Those disconnections in your dmesg logs are not normal.  They could be 
caused by a hardware incompatibility or by a software problem -- 
although if it were software then I would expect the same thing to 
happen with the USB-3 port.

Alan Stern

