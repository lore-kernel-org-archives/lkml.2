Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0IMN42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:56:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39805 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754833Ab0IMN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:56:26 -0400
Date: Mon, 13 Sep 2010 09:56:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
cc: Greg KH <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: Regarding USB-to-Serial device driver
In-Reply-To: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in>
Message-ID: <Pine.LNX.4.44L0.1009130953350.1584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Raju Rameshwar Uprade wrote:

>  Ya I tried with debug=1 on the modprobe line.
> 
> > > f6e80c00 4108452201 C Bo:7:003:2 0 1 >
> > > f6e80900 4108453203 C Ii:7:003:1 0:1 10 = a1200000 00000200 0000
> 
>  same status bytes I am also getting.
>  One thing I would like to ask why it is coming on Ii (Isochronous endpoint)?

"Ii" is Interrupt-IN, not Isochronous-IN.  usbmon uses 'Z' for 
isochronous.

> output of usbmon tell that data going out properly, but it's going in chunks,Ideally It
> should go out in one chunk.I think I have to take care of RTS line. UART drivers works
> in that way,RTS is enabled for complete data out ,then it is disabled so that we can get
> device response.

Maybe your program writing the data in chunks.

Alan Stern

