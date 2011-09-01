Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1IAF6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:58:04 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34213 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1IAF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:58:01 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Harald Dunkel <harri@afaics.de>, linux-usb@vger.kernel.org
Subject: Re: 3.0.3 + Bluetooth USB Dongle: no success without noapic
Date: Thu, 1 Sep 2011 08:01:21 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.2-desktop; KDE/4.4.4; x86_64; ; )
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4E5A0F45.9090302@afaics.de> <201108281207.10071.oliver@neukum.org> <4E5F19CA.7080909@afaics.de>
In-Reply-To: <4E5F19CA.7080909@afaics.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109010801.22009.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. September 2011, 07:36:10 schrieb Harald Dunkel:
> On 08/28/11 12:07, Oliver Neukum wrote:
> > Am Sonntag, 28. August 2011, 11:49:57 schrieb Harald Dunkel:

Hi,

> >> [   91.589073] usb 2-5: new full speed USB device number 8 using ohci_hcd [   91.709067] usb 2-5: device descriptor read/64, error -62 [   91.930059] usb 2-5: device descriptor read/64, error -62 [   92.144054] usb 2-5: new full speed USB device number 9 using ohci_hcd [   92.264073] usb 2-5:
> >> device descriptor read/64, error -62 [   92.485064] usb 2-5: device descriptor read/64, error -62 [   92.699091] usb 2-5: new full speed USB device number 10 using ohci_hcd [   93.103040] usb 2-5: device not accepting address 10, error -62 [   93.216102] usb 2-5: new full speed USB device
> >> number 11 using ohci_hcd [   93.620038] usb 2-5: device not accepting address 11, error -62 [   93.620072] hub 2-0:1.0: unable to enumerate USB device on port 5
> >>
> >> Booting with noapic fixes this problem.
> >
> > Do any other USB devices work on that OHCI?
> >
> 
> Sorry for the delay.
> 
> It seems that this problem comes up by chance (with or without
> noapic). If I move the dongle to another USB slot then the problem
> is gone. By now the Bluetooth dongle is the only device showing this
> problem.
> 
> Here is the output of lsusb with all devices plugged in and
> working:
> 
> Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 002: ID 04fc:0c15 Sunplus Technology Co., Ltd SPIF215A SATA bridge
> Bus 001 Device 007: ID 046d:c525 Logitech, Inc. MX Revolution Cordless Mouse
> Bus 001 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> Bus 001 Device 009: ID 04f2:0402 Chicony Electronics Co., Ltd Genius LuxeMate i200 Keyboard
> 
> Removing the usb drive or the keyboard doesn't make the bluetooth
> dongle more stable.

Voodoo. Does anybody have any ideas?

	Regards
		Oliver
