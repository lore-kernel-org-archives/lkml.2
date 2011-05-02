Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab1EBOE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:04:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57795 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754579Ab1EBOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:04:56 -0400
Date: Mon, 2 May 2011 10:04:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Adi J. Sieker" <adi@core.adi.io>
cc: Oliver Neukum <oliver@neukum.org>, USB list <linux-usb@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
In-Reply-To: <4DBD9D0D.1080503@sieker.io>
Message-ID: <Pine.LNX.4.44L0.1105021001490.2106-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 May 2011, Adi J. Sieker wrote:

> On 01/05/11 09:53, Oliver Neukum wrote:
> > Am Samstag, 30. April 2011, 22:23:05 schrieb Adi J. Sieker:
> >> Hello,
> >>
> >> the lovely folks from #kernelnewbies suggested I write this mail since
> >> they are at a loss.
> >> I recently got a new USB keyboard which works fine in the BIOS and also
> >> in VBox Windows guests, but not on the host.
> >>
> >> The keyboard is a Keysonic KSK-8003 UX product details here:
> >> http://maxpoint.de/de/products/keyboards.php?pid=1_3_7&we_objectID=1220
> >>
> >> The menu key and the backspace keys do work. The num lock led is on,
> >> though I can't switch num lock off.
> >> If I attch the keyboard to a VirtualBox VM running WindowsXP as a guest,
> >> it works as expected in the VM.
> > This indicates that it is working on the USB level.
> >
> >> I'm running 2.6.32-27-generic #49-Ubuntu. I tried the Ubuntu 10.10
> >> LiveCD and that also didn't work. I haven't tried 11.04 yet though.
> > Do you get anything on the event device? What does udev say when you
> > plug in the device?

...

> one thing I found out is that this keyboard has some special anti 
> ghosting function for some keys. Where you can press multiple keys 
> simultaneously
> and they are all recognized. This is apparently great for gaming. Which 
> I'm not interested in...

Something else that might help is a usbmon trace showing what happens 
when you plug in the keyboard.  Instructions are in the kernel source 
file Documentation/usb/usbmon.txt.  In particular, while running the 
test try pressing some of the normal keys that don't work.

Also, it would help to see the output from "lsusb -v" for this device 
-- but you'll have to unbind it from the usbhid driver first.

Alan Stern

