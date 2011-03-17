Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1CQChE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:37:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41169 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753092Ab1CQCg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:36:56 -0400
Date: Wed, 16 Mar 2011 22:36:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [b43] usb device disconnects automatically after 1s
In-Reply-To: <201103170106.58746.mihai.dontu@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103162235400.2388-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Mihai Donțu wrote:

> On Thursday 17 March 2011 00:35:02 Rafał Miłecki wrote:
> > 2011/3/16 Mihai Donțu <mihai.dontu@gmail.com>:
> > > Added linux-usb and linux-wireless to CC.
> > > 
> > > On Thursday 17 March 2011 00:18:31 Mihai Donțu wrote:
> > >> Hi,
> > >> 
> > >> I have just upgraded to 2.6.38 and discovered that I can't use my
> > >> wireless device (BCM4312 802.11a/b/g). I press Fn + F2, the bluetooth
> > >> led lights and after a second it turns off by itself. In dmesg I'm
> > >> seeing the following:
> > >> 
> > >> [   88.167212] usb 1-2.2: new full speed USB device using ehci_hcd and
> > >> address 5
> > >> [   88.782330] usb 1-2.2: USB disconnect, address 5
> > >> 
> > >> I switched to 2.6.37 until I'll have some time to bisect this. In the
> > >> mean time I have attached the output of lspci, interrupts and dmesg.
> > 
> > I suspect it's WMI related. What is your machine?
> 
> It's a Dell Latitude D520 but I can't find a link with full specs (in 
> English).
> 
> > Please check:
> > https://bugzilla.kernel.org/show_bug.cgi?id=31002
> > http://comments.gmane.org/gmane.linux.acpi.devel/49577
> > 
> > I can't help you more, I just noticed such a issue reported on ACPI
> > ML, you have to dig into this yourself (or someone else may help you).
> 
> Thanks for the links. I'll see if I can get anywhere from there.

Another thing you can try is to get usbmon traces under both 2.6.37 and 
2.6.38.  Instructions are in the kernel source file 
Documentation/usb/usbmon.txt.

Alan Stern

