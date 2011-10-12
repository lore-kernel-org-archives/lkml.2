Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1JLSbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:31:24 -0400
Received: from mailout.selfhost.de ([82.98.82.25]:48743 "EHLO
	mailout.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1JLSbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:31:23 -0400
Message-ID: <4E95DCF7.5070003@afaics.de>
Date: Wed, 12 Oct 2011 20:31:19 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sdcard autodetection enabled by running digikam somehow
X-Enigmail-Version: 1.3.2
X-Enigmail-Draft-Status: 513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

Maybe its a stupid question, but why do I have to run
digikam to make autodetection of sd cards work?

Before running digikam nothing happens if I insert a sd
card. After running digikam inserting and removing sd cards
is handled as expected, even if I logout and use root to
kill all jobs and agents that might be related to my
previous session (dbus, gconfd-2, gvfsd, etc).

This seems weird.

Of course I also checked lsmod: no additional modules have
been loaded by running digikam.


Kernel is 3.0.6. I am not running KDE or Gnome or any other
fancy desktop gui, only X and fvwm2. No hal, either. lsusb
of the card reader can be found below.


Any helpful comment would be highly appreciated.

Harri
- --------------------------------------------------------------
Bus 003 Device 006: ID 0424:2228 Standard Microsystems Corp. 9-in-2 Card Reader
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0424 Standard Microsystems Corp.
  idProduct          0x2228 9-in-2 Card Reader
  bcdDevice            4.44
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
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
        DEVICE CLASS:  07 21 07 e8 03 fe ff
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6V3PEACgkQUTlbRTxpHjcwPgCgkvxiCL03+yppWQ3fXvi8L+Fe
fPUAoIaeXRnSJNBm67nr2hp0xQA7WAqK
=qR2g
-----END PGP SIGNATURE-----
