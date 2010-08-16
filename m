Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0HPHmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:42:54 -0400
Received: from relay-2.mailobj.net ([195.234.90.137]:54565 "EHLO
	relay-2.mailobj.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0HPHmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:42:53 -0400
From: ydlydlydl@netcourrier.com
To: linux-kernel@vger.kernel.org
Date: Mon, 16 Aug 2010 09:39:25 +0200 (CEST)
X-Priority: 3
MIME-Version: 1.0
X-Mailer: COMS/EA2.3.4
Message-ID: <ea-mime-4c68eb2d-74be-4609b9ec@w-3.netcourrier.com>
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Perhaps, Alan Stern could answer this question.

I just got some glasses with camera and here is my problem.
When I plug this device with Windows all is fine: I can see the videos (the device acts as a storage device).
When I plug it with Linux, I get a "USB disconnect, address n".

I have already read Alan's answer "http://www.spinics.net/lists/linux-usb/msg29298.html" but without any success ("options usb-storage delay_use=different values").

Any suggestion?

Thanks in advance.

YDL


"dmesg" output:
usb 1-6: new high speed USB device using ehci_hcd and address 7
usb 1-6: New USB device found, idVendor=0851, idProduct=1542
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6: Product: iMagic Product
usb 1-6: Manufacturer: MagicPixel
usb 1-6: SerialNumber: FW_Omega2
scsi8 : usb-storage 1-6:1.0
usb 1-6: USB disconnect, address 7


"usbview" output for this device:
iMagic Product
Manufacturer: MagicPixel
Serial Number: FW_Omega2
Speed: 12Mb/s (full)
USB Version:  2.00
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 64
Number of Configurations: 1
Vendor Id: 0851
Product Id: 1542
Revision Number:  2.00

Config Number: 1
    Number of Interfaces: 1
    Attributes: c0
    MaxPower Needed:  32mA

    Interface Number: 0
        Name: usb-storage
        Alternate Number: 0
        Class: 08(stor.)
        Sub Class: 06
        Protocol: 50
        Number of Endpoints: 2

            Endpoint Address: 01
            Direction: out
            Attribute: 2
            Type: Bulk
            Max Packet Size: 64
            Interval: 0ms

            Endpoint Address: 82
            Direction: in
            Attribute: 2
            Type: Bulk
            Max Packet Size: 64
            Interval: 0ms


"uname -a" output:
Linux localhost 2.6.33.5-server-2mnb #1 SMP Thu Jun 17 23:12:08 UTC 2010 i686 i686 i386 GNU/Linux


"lsb_release -a":
LSB Version:    lsb-4.0-ia32:lsb-4.0-noarch:*
Distributor ID: MandrivaLinux
Description:    Mandriva Linux 2010.1
Release:        2010.1
Codename:       Henry_Farman



