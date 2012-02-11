Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2BKUBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 15:01:50 -0500
Received: from pecan2.exetel.com.au ([220.233.0.70]:54273 "EHLO
	pecan2.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2BKUBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 15:01:48 -0500
Message-ID: <4F36C92A.9060303@exemail.com.au>
Date: Sun, 12 Feb 2012 07:01:46 +1100
From: Padfoot <padfoot@exemail.com.au>
Reply-To: padfoot@exemail.com.au
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120205 Thunderbird/10.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [DEVICE SUPPORT] Atheros 0cf3:e019
References: <E1Rw0SU-0005n1-Io@smtp.po.exetel.com.au>
In-Reply-To: <E1Rw0SU-0005n1-Io@smtp.po.exetel.com.au>
X-Forwarded-Message-Id: <E1Rw0SU-0005n1-Io@smtp.po.exetel.com.au>
Content-Type: multipart/mixed;
 boundary="------------010306070507070601070501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010306070507070601070501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Apologies for posting twice. Please see the below email sent to
linux-bluetooth list on 2 Feb. Yet to receive a response. Most likely
the bluetooth team are flat out with other issues ATM.

Hopefully someone here may be able to assist.

Thanks.
Lachlan.

-------- Original Message --------
Subject: 	[DEVICE SUPPORT] Atheros 0cf3:e019
Date: 	Thu, 02 Feb 2012 19:34:20 +1100
From: 	Padfoot <padfoot@exemail.com.au>
Reply-To: 	padfoot@exemail.com.au
To: 	linux-bluetooth@vger.kernel.org



Hi,

I am trying to find out the state of support in the linux bluetooth
stack for devices reporting as Atheros VID 0cf3 PID e019.

I am using Arch Linux binary kernel 3.2.2 64 bit.

The device is recognised and appropriate modules loaded without error,
yet trying to access bluetooth I am told no adapter is present.

Output of lsmod | grep ath
$ lsmod | grep ath
ath9k                  87343  0
ath9k_common            2096  1 ath9k
ath9k_hw              347282  2 ath9k_common,ath9k
ath                    14802  3 ath9k_hw,ath9k_common,ath9k
mac80211              228367  1 ath9k
cfg80211              172260  3 mac80211,ath,ath9k

Output of lsmod | grep bt
]$ lsmod | grep bt
btusb                  11385  1
bluetooth             151999  13 btusb,bnep,rfcomm
usbcore               146241  9
ehci_hcd,ohci_hcd,usbhid,usb_storage,ums_realtek,uvcvideo,uas,btusb

Output of lsusb -v
Bus 005 Device 003: ID 0cf3:e019 Atheros Communications, Inc.
Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               1.10
    bDeviceClass          224 Wireless
    bDeviceSubClass         1 Radio Frequency
    bDeviceProtocol         1 Bluetooth
    bMaxPacketSize0        64
    idVendor           0x0cf3 Atheros Communications, Inc.
    idProduct          0xe019
    bcdDevice            0.01
    iManufacturer           0
    iProduct                0
    iSerial                 0
    bNumConfigurations      1

Thanks.
Lachlan.


--------------010306070507070601070501
Content-Type: text/plain;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------010306070507070601070501--
