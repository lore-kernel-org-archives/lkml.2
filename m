Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2GaNsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:48:40 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:34731 "EHLO
	homiemail-a91.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753395Ab2GaNsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:content-type:
	content-transfer-encoding; q=dns; s=shealevy.com; b=amq+Fs1sWlZs
	JmsagVWkYpcE6KZ9wmItIJVVSxwMwwXeNg5BT/KO3UPM+GMSbWvStOYVLZfRnEXA
	z0iGZsov9zFDj/banKs8ZLRcwEpOL0RXu/kc/7PKRJ1SNIOKs/vwOWp48/JUsZPX
	CxOSOrBiVZ4msGQoViQRrywKV++54pc=
Message-ID: <5017E234.2000207@shealevy.com>
Date: Tue, 31 Jul 2012 09:48:36 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120703 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-bluetooth@vger.kernel.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Unable to Detect Bluetooth Device on Macbook Pro 9,2 (Mid-2012 13")
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please CC me on response, I am not subscribed to the list.

hcitool is unable to detect my laptop's bluetooth device:

$ lsusb
Bus 004 Device 009: ID 05ac:821d Apple, Inc.
Bus 004 Device 008: ID 05ac:820b Apple, Inc.
Bus 004 Device 007: ID 05ac:820a Apple, Inc.
Bus 004 Device 006: ID 05ac:0252 Apple, Inc.
Bus 004 Device 005: ID 05ac:8242 Apple, Inc. IR Receiver [built-in]
Bus 004 Device 004: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub 
(part of BCM2046 Bluetooth)
Bus 004 Device 003: ID 0424:2513 Standard Microsystems Corp.
Bus 004 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 003: ID 05ac:8509 Apple, Inc.
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub

$ dmesg
<snip>
[    4.744248] usb 4-1.8.1.3: new full-speed USB device number 9 using 
ehci_hcd
[    4.822041] usb 4-1.8.1.3: New USB device found, idVendor=05ac, 
idProduct=821d
[    4.822830] usb 4-1.8.1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    4.823582] usb 4-1.8.1.3: Product: Bluetooth USB Host Controller
[    4.824329] usb 4-1.8.1.3: Manufacturer: Apple Inc.
<snip>

$ hciconfig -a

$ hcitool dev
Devices:

$ lsmod | grep bluetooth
bluetooth             187731  0
rfkill                 15546  2 bluetooth,cfg80211
crc16                   1311  2 bluetooth,ext4

Any ideas?

Cheers,
Shea Levy
