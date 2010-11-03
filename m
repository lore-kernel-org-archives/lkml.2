Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0KCJYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:24:34 -0400
Received: from mail.sysgo.com ([195.145.229.155]:49213 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0KCJYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:24:31 -0400
Date: Wed, 3 Nov 2010 10:24:31 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org
Subject: working usb wifi card, that is still possible to buy
Message-ID: <20101103092431.GA21138@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is there an USB wifi card that can still be bought in reasonable
ammount (like 1000 pieces) and is well supported by Linux?

So far I tried carl9170 (as seen by previous mails) and
rt2x00usb. carl9170 is not really usable; rt2x00usb works a bit
better, but also fails after some time:

phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed
for offset.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed
for offset.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed
for offset.
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset.
...
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset.
usb 1-1: USB disconnect, address 2
usb 1-1: new full speed USB device using ppc-of-ohci and address 3
usb 1-1: device descriptor read/64, error -62
usb 1-1: device descriptor read/64, error -62
usb 1-1: new full speed USB device using ppc-of-ohci and address 4
usb 1-1: device descriptor read/64, error -62
usb 1-1: device descriptor read/64, error -62
usb 1-1: new full speed USB device using ppc-of-ohci and address 5
usb 1-1: device not accepting address 5, error -62
usb 1-1: new full speed USB device using ppc-of-ohci and address 6
usb 1-1: device not accepting address 6, error -62
hub 1-0:1.0: unable to enumerate USB device on port 1
usb 1-1: new full speed USB device using ppc-of-ohci and address 7
usb 1-1: device descriptor read/64, error -62
usb 1-1: device descriptor read/64, error -62
usb 1-1: new full speed USB device using ppc-of-ohci and address 8
usb 1-1: device descriptor read/64, error -62
usb 1-1: device descriptor read/64, error -62
usb 1-1: new full speed USB device using ppc-of-ohci and address 9
usb 1-1: device not accepting address 9, error -62
usb 1-1: new full speed USB device using ppc-of-ohci and address 10
usb 1-1: device not accepting address 10, error -62
hub 1-0:1.0: unable to enumerate USB device on port 1

(is that failing firmware?) 

Note that this is powerpc with OHCI/USB1.1 controller.
								Pavel
