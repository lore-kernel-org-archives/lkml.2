Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2JGIs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 04:48:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55396 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JGIsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 04:48:25 -0400
MIME-Version: 1.0
From: =?UTF-8?B?546L5oCd5rqQ?= <wangsiyuanbuaa@gmail.com>
Date: Sun, 7 Oct 2012 16:48:04 +0800
Message-ID: <CAKhuMP=DB2WGzNN2dXoFuJtSRCneBrToUb43KjU_OsQCrJP_UA@mail.gmail.com>
Subject: usb 3.0 hard drive doesn't work
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
i have a usb 3.0 hard drive and a laptop with usb 3.0 port.
when the hard drive is connected to the usb 3.0 port, the drive could
not be found.
the dmesg output is listed below.
additinal info:
1) the usb 3.0 hard drive can be found when connected to usb 2.0 port.
2) the usb 2.0 hard drive can be found when connected to usb 3.0 port.
3) mouse works when connected to the usb 3.0 port.
4) it is archlinux and kernel version is 3.5.5-1-ARCH
it seems that it is not the linux driver's problem, because the mouse
could work and the hard drive is found due to the dmesg.
is this a bug?
would someone help me?
thank you!

dmesg out put when usb 3.0 hard drive is conneted to usb 3.0 port:
[  646.077385] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[  646.171319] usbcore: registered new interface driver uas
[  646.175313] Initializing USB Mass Storage driver...
[  646.175501] scsi4 : usb-storage 2-2:1.0
[  646.175665] usbcore: registered new interface driver usb-storage
[  646.175667] USB Mass Storage support registered.
[  657.149403] scsi 4:0:0:0: Direct-Access     WD       My Passport
0730 1016 PQ: 0 ANSI: 6
[  657.149974] sd 4:0:0:0: [sdb] 976707584 512-byte logical blocks:
(500 GB/465 GiB)
[  657.150223] sd 4:0:0:0: [sdb] Write Protect is off
[  657.150232] sd 4:0:0:0: [sdb] Mode Sense: 47 00 10 08
[  657.150456] sd 4:0:0:0: [sdb] No Caching mode page present
[  657.150462] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  657.151436] sd 4:0:0:0: [sdb] No Caching mode page present
[  657.151440] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  657.159907]  sdb: sdb1
[  657.160852] sd 4:0:0:0: [sdb] No Caching mode page present
[  657.160858] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[  657.160861] sd 4:0:0:0: [sdb] Attached SCSI disk
[  657.268875] usb 2-2: Device not responding to set address.
[  657.471456] usb 2-2: Device not responding to set address.
[  657.674211] usb 2-2: device not accepting address 2, error -71
[  657.780745] usb 2-2: Device not responding to set address.
[  657.983519] usb 2-2: Device not responding to set address.
[  658.186214] usb 2-2: device not accepting address 2, error -71
[  658.292717] usb 2-2: Device not responding to set address.
[  658.495537] usb 2-2: Device not responding to set address.
[  658.698277] usb 2-2: device not accepting address 2, error -71
[  658.804774] usb 2-2: Device not responding to set address.
[  659.007557] usb 2-2: Device not responding to set address.
[  659.210298] usb 2-2: device not accepting address 2, error -71
[  659.210366] usb 2-2: USB disconnect, device number 2
[  659.213797] sd 4:0:0:0: [sdb] Unhandled error code
[  659.213804] sd 4:0:0:0: [sdb]
[  659.213808] Result: hostbyte=0x01 driverbyte=0x00
[  659.213812] sd 4:0:0:0: [sdb] CDB:
[  659.213814] cdb[0]=0x28: 28 00 00 00 00 00 00 00 08 00
[  659.213826] end_request: I/O error, dev sdb, sector 0
[  659.213830] Buffer I/O error on device sdb, logical block 0
[  659.214647] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff8800b375fe40
[  659.214656] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff8800b375fe00
[  659.320085] usb 2-2: Device not responding to set address.
[  659.522884] usb 2-2: Device not responding to set address.
[  659.725646] usb 2-2: device not accepting address 3, error -71
[  659.832077] usb 2-2: Device not responding to set address.
[  660.034905] usb 2-2: Device not responding to set address.
[  660.237663] usb 2-2: device not accepting address 4, error -71
[  660.344135] usb 2-2: Device not responding to set address.
[  660.546938] usb 2-2: Device not responding to set address.
[  660.749642] usb 2-2: device not accepting address 5, error -71
[  660.856129] usb 2-2: Device not responding to set address.
[  661.058946] usb 2-2: Device not responding to set address.
[  661.261701] usb 2-2: device not accepting address 6, error -71
[  661.261722] hub 2-0:1.0: unable to enumerate USB device on port 2

-- 
王思源
