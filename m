Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab0GDNC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 09:02:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46786 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757451Ab0GDNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 09:02:57 -0400
Date: Sun, 4 Jul 2010 09:02:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Sheer <p@2038bug.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Pete Zaitcev <zaitcev@redhat.com>, <linux-usb@lists.sourceforge.net>,
       <dbrownell@users.sourceforge.net>, <johannes@erdfelt.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>, <gregkh@suse.de>,
       <paulsheer@gmail.com>
Subject: Re: USB mass storage fails to register on kernel 2.6.32
In-Reply-To: <1278230583.6443.27.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.1007040853120.16841-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jul 2010, Paul Sheer wrote:

> Hi there,
> 
> I have a Samsung Story external USB-2.0 1.5TB drive that fails to
> detect as a device in more recent kernel versions. Full kmsg details
> are below. Note that a USB thumb drive works fine on my system.
> Older kernels work fine with the Samsung also. In terms of which
> version of the kernel this stopped working, this I don't know.

Are you certain this is related to the kernel version and isn't just a 
bad USB connection or something of that sort?  Have you tried plugging 
the Samsung drive into a different computer running a recent kernel?

> My kmsg output when plugging in the drive is as follows:
> 
> 
>     <6>[  244.624034] usb 1-10: new high speed USB device using ehci_hcd
> and address 3
>     <3>[  244.780033] usb 1-10: device descriptor read/64, error -32
>     <3>[  245.036030] usb 1-10: device descriptor read/64, error -32
>     <6>[  245.252038] usb 1-10: new high speed USB device using ehci_hcd
> and address 4
>     <3>[  245.862496] usb 1-10: unable to read config index 0
> descriptor/start: -71
>     <3>[  245.862615] usb 1-10: chopping to 0 config(s)
>     <3>[  245.979496] usb 1-10: string descriptor 0 read error: -71
>     <4>[  245.980413] usb 1-10: no configuration chosen from 0 choices

These -71 errors are what you typically get when a device stops 
responding or the USB signals aren't transmitted properly.

> I will be unsubscribing from these lists after sending this bug
> report, so please contact me directly if you need more info at
> paulsheer at gmail

You know, it's not necessary to subscribe to the mailing lists before 
posting messages on them.

Alan Stern

