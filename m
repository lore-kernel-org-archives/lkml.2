Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab2D0P0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:26:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34959 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760487Ab2D0P0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:26:13 -0400
Date: Fri, 27 Apr 2012 11:26:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jslaby@suse.cz>
cc: =?ISO-8859-1?Q?Steffen_M=FCller?= <steffen.mueller@radio-frei.de>,
        <opensuse-factory@opensuse.org>, <stable@kernel.org>,
        Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: usb midi keyboard broken [3.3.3 regression]
In-Reply-To: <4F9A4EED.20800@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1204271122550.1690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Jiri Slaby wrote:

> On 04/27/2012 09:37 AM, Steffen Müller wrote:
> >> [  224.418062] usb 1-1.3: USB disconnect, device number 6 [
> >> 227.662396] usb 1-1.3: new full-speed USB device number 7 using
> >> ehci_hcd [  227.749541] usb 1-1.3: New USB device found,
> >> idVendor=0763, idProduct=0192 [  227.749550] usb 1-1.3: New USB
> >> device strings: Mfr=1, Product=2, SerialNumber=0 [  227.749556]
> >> usb 1-1.3: Product: USB Keystation 88es [  227.749560] usb 1-1.3:
> >> Manufacturer: M-Audio [  229.750236] ALSA midi.c:214 urb status
> >> -32 [  229.750700] ALSA midi.c:214 urb status -32 [  229.750911]
> >> ALSA midi.c:214 urb status -32 [  229.751175] ALSA midi.c:214 urb
> >> status -32 [  229.751413] ALSA midi.c:214 urb status -32 [
> >> 229.751659] ALSA midi.c:214 urb status -32 [  229.751910] ALSA
> >> midi.c:214 urb status -32 [  229.752210] ALSA midi.c:214 urb
> >> status -32 [  229.752459] ALSA midi.c:214 urb status -32 [
> >> 229.752662] ALSA midi.c:214 urb status -32
> 
> Hmm... I suspect some USB patches added in 3.3.3... Alan, Greg, any ideas?
> 
> 3.3.2 is reported to work.

No ideas.  It would be good to see a usbmon trace, with as many other 
USB devices unplugged as possible.  Even better would be to see also a 
second usbmon trace from a working kernel.

Alan Stern

