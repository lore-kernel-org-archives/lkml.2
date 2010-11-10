Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0KJAaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:30:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47729 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0KJAai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:30:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lIowDHT2iue90zZI0SXqzCtK/q1G26GpyauRBnNGe/kd1wnJTysATBdjOozWkyZ8ZC
         kEKSEtRuQB0v4trCtZddkGNLrXwm0pY1N+YJVHFizG9syntrIR74dTVzDQDUg52lIazd
         6T4957MECBKWpVs7RjYgpaVxJ0njKP62kyK7s=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=bkzZd0c+kM4ZsQ-y0xmMedfB5AhTS+4ohen_P@mail.gmail.com>
References: <AANLkTimm0d2fQMkdw9gA+rOqEcBHtJpAB9JRpYDKOxw=@mail.gmail.com>
	<AANLkTi=bkzZd0c+kM4ZsQ-y0xmMedfB5AhTS+4ohen_P@mail.gmail.com>
Date: Wed, 10 Nov 2010 08:30:35 +0800
Message-ID: <AANLkTi=vTg1HPNvScvCTaK09pbTYunK-Spc-gKAhUrhu@mail.gmail.com>
Subject: Re: error in dmesg
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Sasa Ostrouska <casaxa@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 7:30 AM, Sasa Ostrouska <casaxa@gmail.com> wrote:
> Sorry, I forgot to mntion that thi is on a 2.6.33.4 slackware 64bit linux.
>
>
> On Wed, Nov 10, 2010 at 12:26 AM, Sasa Ostrouska <casaxa@gmail.com> wrote:
>> Hi I get this eror during boot on my machine:
>>
>> TCP cubic registered
>> Initializing XFRM netlink socket
>> NET: Registered protocol family 17
>> ata1: softreset failed (device not ready)
>> ata3: softreset failed (device not ready)
>> ata3: applying SB600 PMP SRST workaround and retrying
>> ata1: applying SB600 PMP SRST workaround and retrying
>> usb 1-1: New USB device found, idVendor=0424, idProduct=2502
>> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> hub 1-1:1.0: USB hub found
>> hub 1-1:1.0: 2 ports detected
>> irq 16: nobody cared (try booting with the "irqpoll" option)
>> Pid: 0, comm: swapper Not tainted 2.6.33.4 #3
>> Call Trace:
>>  <IRQ>  [<ffffffff81098d3b>] __report_bad_irq+0x2b/0xa0
>>  [<ffffffff81098f3c>] note_interrupt+0x18c/0x1d0
>>  [<ffffffff8106c54b>] ? sched_clock_tick+0x5b/0x90
>>  [<ffffffff8109961d>] handle_fasteoi_irq+0xbd/0xf0
>>  [<ffffffff81005ab2>] handle_irq+0x22/0x30
>>  [<ffffffff81a0347c>] do_IRQ+0x6c/0xf0
>>  [<ffffffff81a02f93>] ret_from_intr+0x0/0xa
>>  <EOI>  [<ffffffff8100c058>] ? default_idle+0x38/0x80
>>  [<ffffffff8100c123>] c1e_idle+0x83/0x100
>>  [<ffffffff8106b3da>] ? atomic_notifier_call_chain+0x1a/0x20
>>  [<ffffffff8100155d>] cpu_idle+0xad/0x100
>>  [<ffffffff819fb727>] start_secondary+0x17b/0x17f
>> handlers:
>> [<ffffffff81865420>] (usb_hcd_irq+0x0/0x70)
>> Disabling IRQ #16
>> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata3.00: ATA-8: WDC WD3200AAKS-00B3A0, 01.03A01, max UDMA/133
>> ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
>> ata3.00: configured for UDMA/133
>> ata1.00: ATA-8: WDC WD3200AAKS-00YGA0, 12.01C02, max UDMA/133
>> ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
>> ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
>> ata1.00: configured for UDMA/133
>> scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 12.0 PQ: 0 ANSI: 5
>> sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
>> sd 0:0:0:0: [sda] Write Protect is off
>> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
>> support DPO or FUA
>>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
>> sd 0:0:0:0: [sda] Attached SCSI disk
>> usb 5-2: new low speed USB device using ohci_hcd and address 2
>> ata2: softreset failed (device not ready)
>> ata2: applying SB600 PMP SRST workaround and retrying
>> usb 5-2: New USB device found, idVendor=413c, idProduct=3016
>> usb 5-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
>> usb 5-2: Product: Dell Premium USB Optical Mouse
>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata2.00: ATAPI: Optiarc DVD RW AD-7191S, 1.01, max UDMA/100
>> ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
>> ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
>> ata2.00: configured for UDMA/100
>> scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7191S  1.01 PQ: 0 ANSI: 5
>> sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
>> Uniform CD-ROM driver Revision: 3.20
>> sr 1:0:0:0: Attached scsi CD-ROM sr0
>> scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 01.0 PQ: 0 ANSI: 5
>> sd 2:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
>> sd 2:0:0:0: [sdb] Write Protect is off
>> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
>> support DPO or FUA
>>  sdb: sdb1
>> sd 2:0:0:0: [sdb] Attached SCSI disk
>> irq 17: nobody cared (try booting with the "irqpoll" option)
>> Pid: 0, comm: swapper Not tainted 2.6.33.4 #3
>> Call Trace:
>>  <IRQ>  [<ffffffff81098d3b>] __report_bad_irq+0x2b/0xa0
>>  [<ffffffff81098f3c>] note_interrupt+0x18c/0x1d0
>>  [<ffffffff8106c54b>] ? sched_clock_tick+0x5b/0x90
>>  [<ffffffff8109961d>] handle_fasteoi_irq+0xbd/0xf0
>>  [<ffffffff81005ab2>] handle_irq+0x22/0x30
>>  [<ffffffff81a0347c>] do_IRQ+0x6c/0xf0
>>  [<ffffffff81a02f93>] ret_from_intr+0x0/0xa
>>  <EOI>  [<ffffffff8100c058>] ? default_idle+0x38/0x80
>>  [<ffffffff8100c123>] c1e_idle+0x83/0x100
>>  [<ffffffff8106b3da>] ? atomic_notifier_call_chain+0x1a/0x20
>>  [<ffffffff8100155d>] cpu_idle+0xad/0x100
>>  [<ffffffff819fb727>] start_secondary+0x17b/0x17f
>> handlers:
>> [<ffffffff81865420>] (usb_hcd_irq+0x0/0x70)
>> [<ffffffff81865420>] (usb_hcd_irq+0x0/0x70)
>> Disabling IRQ #17
Did you return IRQ_HANDLED or IRQ_NONE for #16 & #17 in your irq handler?

>> registered taskstats version 1
>> md: Waiting for all devices to be available before autodetect
>> md: If you don't use raid, use raid=noautodetect
>> md: Autodetecting RAID arrays.
>> md: Scanned 0 and added 0 devices.
>> md: autorun ...
>> md: ... autorun DONE.
>>
>>
>> Whats going wrong ?
>>
>> Rgds
>> Saxa
>>
>> PS: CC me since I'm not on the list.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
