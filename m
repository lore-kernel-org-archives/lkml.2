Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2KQEqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 23:46:11 -0500
Received: from nm14-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.162]:44519
	"EHLO nm14-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab2KQEqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 23:46:10 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2012 23:46:10 EST
X-Yahoo-Newman-Id: 847106.3710.bm@smtp105.rog.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: f863n5UVM1mVN81rAIGN10do_P.4Io3DfLXoAV1IMFMih89
 sAldO45n65lj3TndICHFOBjI57PSnWZ0Z7Alu9O_f21QY_oSiImdAX2KWvE1
 YSD4APBCqaqbgJ8WHHVnaasgGCy55fkjLs3fOALqYFXrZfc90ij.L4qUM0pd
 dfyRjclqLPH1TedOV6l1aRL4ZjOkc10RKMZtI9LSMd8NVrbbUotD88.Q9Q0C
 K9BCQd2NaxoD9c4lfDqYKFcHzxyPNQcF2iGWbFBdEs8WIc.TGZ1khTda1sfc
 sxr_Bh8vhXKhLXzsQAGm6bgulo_E6tDBPUB9YQUxMB6bJp4zCyzO1Vg0AEYL
 PT2lbFmPCdUWa44jJSHqrXwg3F1eAVVIIcXwdvT9mKu2l61gGKFDgRCrP8ZP
 qt.IA2ejoMgUnl9pRBnlJFP4pzbXNjEnQgFmrK9b.oLgkru3Y4JkViirbyUJ
 H1hJTNUxUyDIgvOvIY_KJrh3Wq0L474QO0Ieq1Wu1Ur8nNEqojg--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [usb_storage][mmc] - Genesys Logic / SilverStone 6-in-1 Card Reader/Writer - Can't mount storage
Date: Fri, 16 Nov 2012 23:39:51 -0500
Message-ID: <3676752.1eMro0Y1EF@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.9.3 (Linux/3.6.6-3.fc18.x86_64; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel folks,

I have an old 2.0 USB card reader, Linux detects the device but is not able to mount the storage device.

I tried it in both a KVM Windows VM and in Linux to mount the storage but device hangs, if I take out card, it detects all 6 device storage capabilities, then it detects the mmc card if i re-insert the card but is unable to mount it.

I am using a MMC adapter that can attach a micro-SD card inside it. This USB card reader/writer device comes with a 3.5" bay slot w/ a USB connector to motherboard and can detached for portable reading.

Anyone seen this problem before? Does it need any quirks used?

Thanks,
Shawn.

--- SNIP ---

Kernel conversation:

[523520.622075] usb 1-1: new high-speed USB device number 8 using ehci_hcd
[523520.749731] usb 1-1: New USB device found, idVendor=05e3, idProduct=0760
[523520.749735] usb 1-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523520.749738] usb 1-1: Product: Flash Reader
[523520.749739] usb 1-1: SerialNumber: 000037
[523520.751674] scsi31 : usb-storage 1-1:1.0
[523521.753494] scsi 31:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523521.884032] usb 1-1: reset high-speed USB device number 8 using ehci_hcd
[523522.020128] scsi 31:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523522.157055] usb 1-1: reset high-speed USB device number 8 using ehci_hcd
[523522.292672] scsi 31:0:0:2: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523522.426047] usb 1-1: reset high-speed USB device number 8 using ehci_hcd
[523522.561250] scsi 31:0:0:3: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523522.561828] sd 31:0:0:0: Attached scsi generic sg2 type 0
[523522.562020] sd 31:0:0:1: Attached scsi generic sg3 type 0
[523522.562158] sd 31:0:0:2: Attached scsi generic sg4 type 0
[523522.562294] sd 31:0:0:3: Attached scsi generic sg5 type 0
[523526.062174] usb 1-1: USB disconnect, device number 8
[523526.066148] sd 31:0:0:1: [sdc] READ CAPACITY failed
[523526.066151] sd 31:0:0:1: [sdc]  
[523526.066153] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523526.066154] sd 31:0:0:1: [sdc] Sense not available.
[523526.066162] sd 31:0:0:3: [sde] READ CAPACITY failed
[523526.066164] sd 31:0:0:3: [sde]  
[523526.066165] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523526.066166] sd 31:0:0:3: [sde] Sense not available.
[523526.066180] sd 31:0:0:3: [sde] Write Protect is off
[523526.066181] sd 31:0:0:2: [sdd] READ CAPACITY failed
[523526.066183] sd 31:0:0:2: [sdd]  
[523526.066184] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523526.066185] sd 31:0:0:2: [sdd] Sense not available.
[523526.066187] sd 31:0:0:3: [sde] Mode Sense: 00 00 00 00
[523526.066193] sd 31:0:0:1: [sdc] Write Protect is off
[523526.066195] sd 31:0:0:1: [sdc] Mode Sense: 00 00 00 00
[523526.066201] sd 31:0:0:2: [sdd] Write Protect is on
[523526.066203] sd 31:0:0:2: [sdd] Mode Sense: 90 67 cf b2
[523526.066205] sd 31:0:0:1: [sdc] Asking for cache data failed
[523526.066208] sd 31:0:0:1: [sdc] Assuming drive cache: write through
[523526.066213] sd 31:0:0:2: [sdd] Asking for cache data failed
[523526.066215] sd 31:0:0:2: [sdd] Assuming drive cache: write through
[523526.066261] sd 31:0:0:3: [sde] Asking for cache data failed
[523526.066264] sd 31:0:0:3: [sde] Assuming drive cache: write through
[523526.066411] sd 31:0:0:2: [sdd] READ CAPACITY failed
[523526.066414] sd 31:0:0:2: [sdd]  
[523526.066415] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523526.066416] sd 31:0:0:2: [sdd] Sense not available.
[523526.066450] sd 31:0:0:3: [sde] Attached SCSI removable disk
[523526.066452] sd 31:0:0:2: [sdd] Asking for cache data failed
[523526.066454] sd 31:0:0:2: [sdd] Assuming drive cache: write through
[523526.066456] sd 31:0:0:2: [sdd] Attached SCSI removable disk
[523526.066457] sd 31:0:0:1: [sdc] Attached SCSI removable disk
[523526.072084] sd 31:0:0:0: [sdb] READ CAPACITY failed
[523526.072088] sd 31:0:0:0: [sdb]  
[523526.072089] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523526.072091] sd 31:0:0:0: [sdb] Sense not available.
[523526.072102] sd 31:0:0:0: [sdb] Write Protect is off
[523526.072104] sd 31:0:0:0: [sdb] Mode Sense: 00 00 00 00
[523526.072114] sd 31:0:0:0: [sdb] Asking for cache data failed
[523526.072116] sd 31:0:0:0: [sdb] Assuming drive cache: write through
[523526.072274] sd 31:0:0:0: [sdb] Attached SCSI removable disk
[523526.410077] hub 1-0:1.0: unable to enumerate USB device on port 1
[523527.324054] usb 1-1: new high-speed USB device number 10 using ehci_hcd
[523527.450935] usb 1-1: New USB device found, idVendor=05e3, idProduct=0760
[523527.450941] usb 1-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523527.450944] usb 1-1: Product: Flash Reader
[523527.450947] usb 1-1: SerialNumber: 000037
[523527.453972] scsi32 : usb-storage 1-1:1.0
[523528.458085] scsi 32:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523528.598053] usb 1-1: reset high-speed USB device number 10 using ehci_hcd
[523528.735315] scsi 32:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523528.876069] usb 1-1: reset high-speed USB device number 10 using ehci_hcd
[523529.011740] scsi 32:0:0:2: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523529.157046] usb 1-1: reset high-speed USB device number 10 using ehci_hcd
[523529.292285] scsi 32:0:0:3: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523529.293808] sd 32:0:0:0: Attached scsi generic sg2 type 0
[523529.294720] sd 32:0:0:1: Attached scsi generic sg3 type 0
[523529.294926] sd 32:0:0:2: Attached scsi generic sg4 type 0
[523529.295140] sd 32:0:0:3: Attached scsi generic sg5 type 0
[523540.261776] sd 32:0:0:3: [sde] Attached SCSI removable disk
[523540.263276] sd 32:0:0:0: [sdb] Attached SCSI removable disk
[523540.266281] sd 32:0:0:2: [sdd] Attached SCSI removable disk
[523540.269157] sd 32:0:0:1: [sdc] Attached SCSI removable disk
[523548.570730] usb 1-1: USB disconnect, device number 10
[523549.071060] usb 3-1: new full-speed USB device number 2 using uhci_hcd
[523549.203068] usb 3-1: not running at top speed; connect to a high speed hub
[523549.232134] usb 3-1: New USB device found, idVendor=05e3, idProduct=0760
[523549.232139] usb 3-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523549.232141] usb 3-1: Product: Flash Reader
[523549.232143] usb 3-1: SerialNumber: 000037
[523549.235365] scsi33 : usb-storage 3-1:1.0
[523550.241083] scsi 33:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523550.558414] sd 33:0:0:0: Attached scsi generic sg2 type 0
[523550.615077] usb 3-1: USB disconnect, device number 2
[523550.618155] sd 33:0:0:0: [sdb] READ CAPACITY failed
[523550.618163] sd 33:0:0:0: [sdb]  
[523550.618167] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523550.618172] sd 33:0:0:0: [sdb] Sense not available.
[523550.618205] sd 33:0:0:0: [sdb] Write Protect is off
[523550.618213] sd 33:0:0:0: [sdb] Mode Sense: 2e 2e 2f 2e
[523550.618242] sd 33:0:0:0: [sdb] No Caching mode page present
[523550.618250] sd 33:0:0:0: [sdb] Assuming drive cache: write through
[523550.618844] sd 33:0:0:0: [sdb] Attached SCSI removable disk
[523550.922034] usb 1-1: new high-speed USB device number 12 using ehci_hcd
[523551.047189] usb 1-1: New USB device found, idVendor=05e3, idProduct=0760
[523551.047199] usb 1-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523551.047206] usb 1-1: Product: Flash Reader
[523551.047212] usb 1-1: SerialNumber: 000037
[523551.051861] scsi34 : usb-storage 1-1:1.0
[523552.055977] scsi 34:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523569.565618] usb 1-1: USB disconnect, device number 12
[523569.575466] sd 34:0:0:0: [sdb] READ CAPACITY failed
[523569.575469] sd 34:0:0:0: [sdb]  
[523569.575480] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[523569.575481] sd 34:0:0:0: Attached scsi generic sg2 type 0
[523569.575483] sd 34:0:0:0: [sdb] Sense not available.
[523569.575495] sd 34:0:0:0: [sdb] Write Protect is off
[523569.575498] sd 34:0:0:0: [sdb] Mode Sense: 00 00 00 00
[523569.575507] sd 34:0:0:0: [sdb] Asking for cache data failed
[523569.575510] sd 34:0:0:0: [sdb] Assuming drive cache: write through
[523569.575680] sd 34:0:0:0: [sdb] Attached SCSI removable disk
[523569.861038] usb 1-1: new high-speed USB device number 13 using ehci_hcd
[523569.986838] usb 1-1: New USB device found, idVendor=05e3, idProduct=0760
[523569.986842] usb 1-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523569.986844] usb 1-1: Product: Flash Reader
[523569.986846] usb 1-1: SerialNumber: 000037
[523569.988342] scsi35 : usb-storage 1-1:1.0
[523570.077614] usb 1-1: USB disconnect, device number 13
[523595.299062] usb 1-1: new high-speed USB device number 14 using ehci_hcd
[523595.424348] usb 1-1: New USB device found, idVendor=05e3, idProduct=0760
[523595.424352] usb 1-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523595.424355] usb 1-1: Product: Flash Reader
[523595.424356] usb 1-1: SerialNumber: 000037
[523595.426729] scsi36 : usb-storage 1-1:1.0
[523596.429736] scsi 36:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523617.863063] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523621.740968] scsi 36:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523621.741932] scsi 36:0:0:2: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523621.742940] scsi 36:0:0:3: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523621.744300] sd 36:0:0:0: Attached scsi generic sg2 type 0
[523621.744446] sd 36:0:0:1: Attached scsi generic sg3 type 0
[523621.744583] sd 36:0:0:2: Attached scsi generic sg4 type 0
[523621.744734] sd 36:0:0:3: Attached scsi generic sg5 type 0
[523621.757034] sd 36:0:0:0: [sdb] Attached SCSI removable disk
[523621.758395] sd 36:0:0:1: [sdc] Attached SCSI removable disk
[523621.761447] sd 36:0:0:3: [sde] Attached SCSI removable disk
[523621.762767] sd 36:0:0:2: [sdd] Attached SCSI removable disk
[523656.838441] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523667.062048] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523683.298058] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523683.521031] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523693.745044] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523693.865954] sd 36:0:0:2: Device offlined - not ready after error recovery
[523724.838041] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523735.061056] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523751.298075] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523751.521348] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523761.743090] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523761.864031] sd 36:0:0:0: Device offlined - not ready after error recovery
[523792.838062] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523803.060051] usb 1-1: reset high-speed USB device number 14 using ehci_hcd
[523806.704141] usb 6-1: USB disconnect, device number 2
[523813.490615] usb 1-1: USB disconnect, device number 14
[523813.494834] sd 36:0:0:1: Device offlined - not ready after error recovery
[523816.661064] usb 1-1: new high-speed USB device number 15 using ehci_hcd
[523816.786331] usb 1-1: New USB device found, idVendor=05e3, idProduct=0760
[523816.786335] usb 1-1: New USB device strings: Mfr=0, Product=3, SerialNumber=4
[523816.786337] usb 1-1: Product: Flash Reader
[523816.786339] usb 1-1: SerialNumber: 000037
[523816.787784] scsi37 : usb-storage 1-1:1.0
[523817.789368] scsi 37:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523832.079578] scsi 37:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523832.080532] scsi 37:0:0:2: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523832.081579] scsi 37:0:0:3: Direct-Access     Generic  STORAGE DEVICE   0113 PQ: 0 ANSI: 0
[523832.086705] sd 37:0:0:0: Attached scsi generic sg2 type 0
[523832.087311] sd 37:0:0:1: Attached scsi generic sg3 type 0
[523832.087749] sd 37:0:0:2: Attached scsi generic sg4 type 0
[523832.088222] sd 37:0:0:3: Attached scsi generic sg5 type 0
[523832.099628] sd 37:0:0:0: [sdb] Attached SCSI removable disk
[523832.101000] sd 37:0:0:1: [sdc] Attached SCSI removable disk
[523832.102371] sd 37:0:0:2: [sdd] Attached SCSI removable disk
[523832.103751] sd 37:0:0:3: [sde] Attached SCSI removable disk

lsusb:

Bus 001 Device 014: ID 05e3:0760 Genesys Logic, Inc. USB 2.0 Card Reader/Writer
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x05e3 Genesys Logic, Inc.
  idProduct          0x0760 USB 2.0 Card Reader/Writer
  bcdDevice            1.13
  iManufacturer           0 
  iProduct                3 
  iSerial                 4 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
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
Device Status:     0x0001
  Self Powered

