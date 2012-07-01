Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2GAMe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 08:34:57 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:48409 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2GAMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:34:55 -0400
Message-ID: <1341146090.4121.3.camel@piranha.localdomain>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
From: Frederik Himpe <fhimpe@telenet.be>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Sun, 01 Jul 2012 14:34:50 +0200
In-Reply-To: <Pine.LNX.4.44L0.1206302209270.6344-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1206302209270.6344-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 22:12 -0400, Alan Stern wrote:
> On Sat, 30 Jun 2012, Frederik Himpe wrote:
> 
> > Hello,
> > 
> > I've got a Logitech HD Webcam C525 using the uvcvideo module and I use
> > Linux 3.5 RC4. When this camera is connected to a USB2 port, it does not
> > work most of the time. However it does work fine when connected to a USB
> > 3 port. In Windows it works on both ports.
> 
> ...
> 
> > Complete dmesg and lsusb -v output about a failed attempt (on USB 2
> > port) and a succeeded attempt (on USB 3) can be found on
> > http://artipc10.vub.ac.be/~frederik/webcam/
> 
> A usbmon trace would be more helpful.  Or perhaps a pair of traces, one 
> for the USB-2 port and one for the USB-3 port.  See the instructions in 
> Documentation/usb/usbmon.txt.

OK, I created a usbmon trace both from the USB-2 port as the USB-3 port.
During the trace, I connected the USB webcam to the USB port and started
mplayer, which failed on USB-2 but worked fine on USB-3.

The two traces can be found here:
http://artipc10.vub.ac.be/~frederik/webcam/

Thanks!
-- 
Frederik Himpe <fhimpe@telenet.be>

