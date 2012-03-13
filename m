Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab2CMRbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:31:01 -0400
Received: from atlanta.tchmachines.com ([208.76.86.11]:36548 "EHLO
	atlanta.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2CMRa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:30:59 -0400
X-Greylist: delayed 2579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 13:30:59 EDT
Date: Tue, 13 Mar 2012 12:47:59 -0400
From: Leonid Petrov <user1@lpetrov.net>
Reply-To: Leonid Petrov <user1@lpetrov.net>
To: linux-kernel@vger.kernel.org
Subject: USB 3.0 card, chipset VIA VL800 + external harddrive @ 3.3.0-rc7 
 = no luck
Message-ID: <4F5F7A3F.nail2BJ11Y4JL@lpetrov.net>
User-Agent: nail 11.6.2 (mod) 2007.09.22
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - atlanta.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pethome.astrogeo.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys,

  I have SYBA USB 3.0 4-port PCI-Express Controller Card, VIA VL800 Chipset Model 
SY-PEX20103 and Seagate external USB-3.0 drive  GoFlex Desk. 

  I have compiled from sources to the latest kernel 3.3.0-rc7
The drive works when connectd to USB-2.0, but the system does
not recognize the drive when connected to USB-3.0 port.
I see messages in /var/log/message "device descriptor read/8, error -110"

  Here is relevant information:

uname -a:
---------

Linux pethome 3.3.0-rc7 #2 SMP Tue Mar 13 09:41:48 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux


lspci -vvv
----------

Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 9
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: irq 16, io mem 0xfbaff000
Mar 13 10:40:56 localhost kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0002
Mar 13 10:40:56 localhost kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 13 10:40:56 localhost kernel: usb usb9: Product: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: usb usb9: Manufacturer: Linux 3.3.0-rc7 xhci_hcd
Mar 13 10:40:56 localhost kernel: usb usb9: SerialNumber: 0000:02:00.0
Mar 13 10:40:56 localhost kernel: hub 9-0:1.0: USB hub found
Mar 13 10:40:56 localhost kernel: hub 9-0:1.0: 1 port detected
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 10
Mar 13 10:40:56 localhost kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0003
Mar 13 10:40:56 localhost kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 13 10:40:56 localhost kernel: usb usb10: Product: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: usb usb10: Manufacturer: Linux 3.3.0-rc7 xhci_hcd
Mar 13 10:40:56 localhost kernel: usb usb10: SerialNumber: 0000:02:00.0
Mar 13 10:40:56 localhost kernel: hub 10-0:1.0: USB hub found
Mar 13 10:40:56 localhost kernel: hub 10-0:1.0: 4 ports detected

Boot messages from /var/log/messages
------------------------------------

Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 9
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: irq 16, io mem 0xfbaff000
Mar 13 10:40:56 localhost kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0002
Mar 13 10:40:56 localhost kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 13 10:40:56 localhost kernel: usb usb9: Product: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: usb usb9: Manufacturer: Linux 3.3.0-rc7 xhci_hcd
Mar 13 10:40:56 localhost kernel: usb usb9: SerialNumber: 0000:02:00.0
Mar 13 10:40:56 localhost kernel: hub 9-0:1.0: USB hub found
Mar 13 10:40:56 localhost kernel: hub 9-0:1.0: 1 port detected
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 10
Mar 13 10:40:56 localhost kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0003
Mar 13 10:40:56 localhost kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Mar 13 10:40:56 localhost kernel: usb usb10: Product: xHCI Host Controller
Mar 13 10:40:56 localhost kernel: usb usb10: Manufacturer: Linux 3.3.0-rc7 xhci_hcd
Mar 13 10:40:56 localhost kernel: usb usb10: SerialNumber: 0000:02:00.0
Mar 13 10:40:56 localhost kernel: hub 10-0:1.0: USB hub found
Mar 13 10:40:56 localhost kernel: hub 10-0:1.0: 4 ports detected


When connected to usb-3.0: 
--------------------------

Mar 13 10:37:52 localhost kernel: hub 10-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
Mar 13 10:40:58 localhost kernel: usb 10-2: new SuperSpeed USB device number 3 using xhci_hcd
Mar 13 10:41:03 localhost kernel: usb 10-2: device descriptor read/8, error -110
Mar 13 10:41:03 localhost kernel: usb 10-2: new SuperSpeed USB device number 3 using xhci_hcd
Mar 13 10:41:08 localhost kernel: usb 10-2: device descriptor read/8, error -110
Mar 13 10:41:08 localhost kernel: usb 10-2: new SuperSpeed USB device number 4 using xhci_hcd
Mar 13 10:41:13 localhost kernel: usb 10-2: device descriptor read/8, error -110
Mar 13 10:41:14 localhost kernel: usb 10-2: new SuperSpeed USB device number 4 using xhci_hcd
Mar 13 10:41:19 localhost kernel: usb 10-2: device descriptor read/8, error -110
Mar 13 10:41:19 localhost kernel: usb 10-2: new SuperSpeed USB device number 5 using xhci_hcd
Mar 13 10:41:24 localhost kernel: usb 10-2: device descriptor read/8, error -110
Mar 13 10:41:24 localhost kernel: usb 10-2: new SuperSpeed USB device number 5 using xhci_hcd
Mar 13 10:41:29 localhost kernel: usb 10-2: device descriptor read/8, error -110
Mar 13 10:41:29 localhost kernel: hub 10-0:1.0: unable to enumerate USB device on port 2


When connected to usb-2.0: 
--------------------------

Mar 13 10:42:03 localhost kernel: hub 4-0:1.0: unable to enumerate USB device on port 1
Mar 13 10:42:05 localhost kernel: usb 1-2: new full-speed USB device number 2 using uhci_hcd
Mar 13 10:42:05 localhost kernel: usb 1-2: New USB device found, idVendor=046d, idProduct=08b2
Mar 13 10:42:05 localhost kernel: usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Mar 13 10:42:05 localhost kernel: Linux video capture interface: v2.00
Mar 13 10:42:05 localhost kernel: pwc: Logitech QuickCam 4000 Pro USB webcam detected.
Mar 13 10:42:06 localhost kernel: pwc: Registered as video0.
Mar 13 10:42:06 localhost kernel: input: PWC snapshot button as /devices/pci0000:00/0000:00:1a.0/usb1/1-2/input/input3
Mar 13 10:42:06 localhost kernel: usbcore: registered new interface driver Philips webcam
Mar 13 10:42:06 localhost kernel: usbcore: registered new interface driver snd-usb-audio
Mar 13 10:44:11 localhost kernel: hub 10-0:1.0: Cannot enable port 2.  Maybe the USB cable is bad?
Mar 13 10:44:30 localhost kernel: usb 4-1: new high-speed USB device number 4 using ehci_hcd
Mar 13 10:44:30 localhost kernel: usb 4-1: New USB device found, idVendor=0bc2, idProduct=50a5
Mar 13 10:44:30 localhost kernel: usb 4-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Mar 13 10:44:30 localhost kernel: usb 4-1: Product: GoFlex Desk
Mar 13 10:44:30 localhost kernel: usb 4-1: Manufacturer: Seagate
Mar 13 10:44:30 localhost kernel: usb 4-1: SerialNumber: NA0M3P3T
Mar 13 10:44:30 localhost kernel: usbcore: registered new interface driver uas
Mar 13 10:44:30 localhost kernel: usbcore: registered new interface driver libusual
Mar 13 10:44:30 localhost kernel: Initializing USB Mass Storage driver...
Mar 13 10:44:30 localhost kernel: scsi9 : usb-storage 4-1:1.0
Mar 13 10:44:30 localhost kernel: usbcore: registered new interface driver usb-storage
Mar 13 10:44:30 localhost kernel: USB Mass Storage support registered.
Mar 13 10:44:31 localhost kernel: scsi 9:0:0:0: Direct-Access     Seagate  GoFlex Desk      0D19 PQ: 0 ANSI: 5
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: Attached scsi generic sg9 type 0
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: [sdj] 732566645 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: [sdj] Write Protect is off
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: [sdj] 732566645 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Mar 13 10:44:31 localhost kernel: sdj: sdj1
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: [sdj] 732566645 4096-byte logical blocks: (3.00 TB/2.72 TiB)
Mar 13 10:44:31 localhost kernel: sd 9:0:0:0: [sdj] Attached SCSI disk

lsusb -vvv
----------

Bus 004 Device 004: ID 0bc2:50a5 Seagate RSS LLC 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0bc2 Seagate RSS LLC
  idProduct          0x50a5 
  bcdDevice            1.00
  iManufacturer           2 
  iProduct                3 
  iSerial                 1 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0


hdparm -I /dev/sdj:
-------------------

        Model Number:       ST3000DM001-9YN166                      
        Serial Number:      S1F055ZZ
        Firmware Revision:  CC9D    
        Transport:          Serial, SATA Rev 3.0

Suggestions, ideas?

Leonid
