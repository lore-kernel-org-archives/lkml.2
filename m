Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2GaPyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:54:11 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43831 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2GaPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:54:10 -0400
Message-ID: <1343749923.1803.68.camel@aeonflux>
Subject: Re: Unable to Detect Bluetooth Device on Macbook Pro 9,2 (Mid-2012
 13")
From: Marcel Holtmann <marcel@holtmann.org>
To: Shea Levy <shea@shealevy.com>
Cc: linux-bluetooth@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jul 2012 08:52:03 -0700
In-Reply-To: <5017E234.2000207@shealevy.com>
References: <5017E234.2000207@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shea,

> Please CC me on response, I am not subscribed to the list.
> 
> hcitool is unable to detect my laptop's bluetooth device:
> 
> $ lsusb
> Bus 004 Device 009: ID 05ac:821d Apple, Inc.
> Bus 004 Device 008: ID 05ac:820b Apple, Inc.
> Bus 004 Device 007: ID 05ac:820a Apple, Inc.
> Bus 004 Device 006: ID 05ac:0252 Apple, Inc.
> Bus 004 Device 005: ID 05ac:8242 Apple, Inc. IR Receiver [built-in]
> Bus 004 Device 004: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub 
> (part of BCM2046 Bluetooth)
> Bus 004 Device 003: ID 0424:2513 Standard Microsystems Corp.
> Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 003: ID 05ac:8509 Apple, Inc.
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> 
> $ dmesg
> <snip>
> [    4.744248] usb 4-1.8.1.3: new full-speed USB device number 9 using 
> ehci_hcd
> [    4.822041] usb 4-1.8.1.3: New USB device found, idVendor=05ac, 
> idProduct=821d
> [    4.822830] usb 4-1.8.1.3: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=0
> [    4.823582] usb 4-1.8.1.3: Product: Bluetooth USB Host Controller
> [    4.824329] usb 4-1.8.1.3: Manufacturer: Apple Inc.
> <snip>
> 
> $ hciconfig -a
> 
> $ hcitool dev
> Devices:
> 
> $ lsmod | grep bluetooth
> bluetooth             187731  0
> rfkill                 15546  2 bluetooth,cfg80211
> crc16                   1311  2 bluetooth,ext4
> 
> Any ideas?

include /sys/kernel/debug/usb/devices details for this device.

Regards

Marcel


