Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1EDNIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:08:16 -0400
Received: from gold.linx.net ([195.66.232.40]:51755 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1EDNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:08:14 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 May 2011 09:08:14 EDT
Message-ID: <4DC14DD9.9060407@linx.net>
Date: Wed, 04 May 2011 14:00:09 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110503 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: ums-realtek: Unneeded SubClass & Protocol entries (Fujitsu S760 laptop)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Good afternoon,

The following message was emitted by my kernel:
usb 1-1.6: new high speed USB device number 5 using ehci_hcd
ums-realtek 1-1.6:1.0: This device (0bda,0138,3882 S 06 P 50) has
unneeded SubClass and Protocol entries in unusual_devs.h (kernel
2.6.39-rc5-00274-g609cfda)
   Please send a copy of this message to <linux-usb@vger.kernel.org> and
<usb-storage@lists.one-eyed-alien.net>
scsi6 : usb-storage 1-1.6:1.0

This is the built-in card reader on a Fujitsu S760 laptop. Full lsusb
for the device in question:
Bus 001 Device 005: ID 0bda:0138 Realtek Semiconductor Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x0138
  bcdDevice           38.82
  iManufacturer           1 Generic
  iProduct                2 USB2.0-CRW
  iSerial                 3 20090516388200000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 CARD READER
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              5 Bulk-In, Bulk-Out, Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Could you CC me on any postings as I am not subscribed to the USB lists.
If there is further information you require, I am happy to provide it.

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3BTdkACgkQp5vW4rUFj5rGPACgkOfjbenHWGPLpgOAPrzbHqjH
vJEAoKjva6ZsDs/rcdgh6TngHm63/beO
=qwHu
-----END PGP SIGNATURE-----
