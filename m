Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2JGVcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:32:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35724 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2JGVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:32:04 -0400
Message-ID: <5071F4C5.6000104@gmail.com>
Date: Sun, 07 Oct 2012 23:31:49 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: =?UTF-8?B?546L5oCd5rqQ?= <wangsiyuanbuaa@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: usb 3.0 hard drive doesn't work
References: <CAKhuMP=DB2WGzNN2dXoFuJtSRCneBrToUb43KjU_OsQCrJP_UA@mail.gmail.com>
In-Reply-To: <CAKhuMP=DB2WGzNN2dXoFuJtSRCneBrToUb43KjU_OsQCrJP_UA@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb)

On 07.10.2012 10:48, 王思源 wrote:
> hi,
> i have a usb 3.0 hard drive and a laptop with usb 3.0 port.
> when the hard drive is connected to the usb 3.0 port, the drive could
> not be found.
> the dmesg output is listed below.
> additinal info:
> 1) the usb 3.0 hard drive can be found when connected to usb 2.0 port.
> 2) the usb 2.0 hard drive can be found when connected to usb 3.0 port.
> 3) mouse works when connected to the usb 3.0 port.
> 4) it is archlinux and kernel version is 3.5.5-1-ARCH
> it seems that it is not the linux driver's problem, because the mouse
> could work and the hard drive is found due to the dmesg.
> is this a bug?
> would someone help me?
> thank you!
> 
> dmesg out put when usb 3.0 hard drive is conneted to usb 3.0 port:
> [  646.077385] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
> [  646.171319] usbcore: registered new interface driver uas
> [  646.175313] Initializing USB Mass Storage driver...
> [  646.175501] scsi4 : usb-storage 2-2:1.0
> [  646.175665] usbcore: registered new interface driver usb-storage
> [  646.175667] USB Mass Storage support registered.
> [  657.149403] scsi 4:0:0:0: Direct-Access     WD       My Passport
> 0730 1016 PQ: 0 ANSI: 6
> [  657.149974] sd 4:0:0:0: [sdb] 976707584 512-byte logical blocks:
> (500 GB/465 GiB)
> [  657.150223] sd 4:0:0:0: [sdb] Write Protect is off
> [  657.150232] sd 4:0:0:0: [sdb] Mode Sense: 47 00 10 08
> [  657.150456] sd 4:0:0:0: [sdb] No Caching mode page present
> [  657.150462] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> [  657.151436] sd 4:0:0:0: [sdb] No Caching mode page present
> [  657.151440] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> [  657.159907]  sdb: sdb1
> [  657.160852] sd 4:0:0:0: [sdb] No Caching mode page present
> [  657.160858] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> [  657.160861] sd 4:0:0:0: [sdb] Attached SCSI disk
> [  657.268875] usb 2-2: Device not responding to set address.
> [  657.471456] usb 2-2: Device not responding to set address.
> [  657.674211] usb 2-2: device not accepting address 2, error -71
> [  657.780745] usb 2-2: Device not responding to set address.
> [  657.983519] usb 2-2: Device not responding to set address.
> [  658.186214] usb 2-2: device not accepting address 2, error -71
> [  658.292717] usb 2-2: Device not responding to set address.
> [  658.495537] usb 2-2: Device not responding to set address.

>From the logs, this smells like a power supply problem. Can you connect
an external supply or do you have a powered USB3 hub? It's possible that
it draws less power in USB2.0 mode, so that would explain what you describe.

But I could be wrong alltogether :)


Daniel

