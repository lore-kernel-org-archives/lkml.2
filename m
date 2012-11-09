Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2KIDsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:48:39 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37549 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2KIDs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:48:27 -0500
Message-ID: <509C7D08.8030801@gmail.com>
Date: Thu, 08 Nov 2012 21:48:24 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Azat Khuzhin <dohardgopro@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: macbook pro 9.2 stat/ata bus error
References: <CAAW1UO_X9eaBoiHMdj-ntCjGgBKpA6A_EDA2zifDf7f7dbs4Xw@mail.gmail.com> <CAAW1UO_9ZRZEX8rU83niZuZxihcoHaj-dau-o+ym5ATJXyNvpg@mail.gmail.com>
In-Reply-To: <CAAW1UO_9ZRZEX8rU83niZuZxihcoHaj-dau-o+ym5ATJXyNvpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 09:41 PM, Azat Khuzhin wrote:
>   Anybody?
>
> On Mon, Nov 5, 2012 at 7:28 PM, Azat Khuzhin <dohardgopro@gmail.com> wrote:
>> After installing linux on macbook 9.2 (mid 2012), I have next errors
>> in dmesg log:
>>
>> [  389.623828] EXT4-fs (sda4): re-mounted. Opts:
>> errors=remount-ro,data=ordered,commit=600
>> [  410.038465] NMI watchdog: enabled on all CPUs, permanently consumes
>> one hw-PMU counter.
>> [  410.075042] ehci_hcd 0000:00:1a.0: setting latency timer to 64
>> [  410.483526] EXT4-fs (sda4): re-mounted. Opts:
>> errors=remount-ro,data=ordered,commit=0
>> [ 1401.834509] EXT4-fs (sda4): re-mounted. Opts:
>> errors=remount-ro,data=ordered,commit=1800
>> [ 1406.467268] NMI watchdog: enabled on all CPUs, permanently consumes
>> one hw-PMU counter.
>> [ 1406.506769] ehci_hcd 0000:00:1a.0: setting latency timer to 64
>> [ 1406.590122] EXT4-fs (sda4): re-mounted. Opts:
>> errors=remount-ro,data=ordered,commit=0
>> [ 1407.492260] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x50000
>> action 0xe frozen
>> [ 1407.494441] ata2.00: irq_stat 0x00400000, PHY RDY changed
>> [ 1407.495238] ata2: SError: { PHYRdyChg CommWake }
>> [ 1407.496035] sr 1:0:0:0: CDB:
>> [ 1407.497333] Get event status notification: 4a 01 00 00 10 00 00 00 08 00
>> [ 1407.498285] ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
>> pio 16392 in
>> [ 1407.498285]          res 50/00:03:00:00:00/00:00:00:00:00/a0 Emask
>> 0x10 (ATA bus error)
>> [ 1407.501987] ata2.00: status: { DRDY }
>> [ 1407.502882] ata2: hard resetting link
>> [ 1408.230302] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [ 1408.233279] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>> filtered out
>> [ 1408.237467] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>> filtered out
>> [ 1408.239084] ata2.00: configured for UDMA/100
>> [ 1408.262238] ata2: EH complete

Is this after a resume? It could be that for some reason the SATA link 
is a little bit unstable right after the machine powers up again. There 
may not be much the kernel can do about this..

>> [ 3565.785609] EXT4-fs (sda4): re-mounted. Opts:
>> errors=remount-ro,data=ordered,commit=1800
>> [ 3576.921499] NMI watchdog: enabled on all CPUs, permanently consumes
>> one hw-PMU counter.
>> [ 3576.958624] ehci_hcd 0000:00:1a.0: setting latency timer to 64
>> [ 3577.114612] EXT4-fs (sda4): re-mounted. Opts:
>> errors=remount-ro,data=ordered,commit=0
>> [ 3577.923688] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x50000
>> action 0xe frozen
>> [ 3577.925852] ata2.00: irq_stat 0x00400000, PHY RDY changed
>> [ 3577.926746] ata2: SError: { PHYRdyChg CommWake }
>> [ 3577.927544] sr 1:0:0:0: CDB:
>> [ 3577.928345] Get event status notification: 4a 01 00 00 10 00 00 00 08 00
>> [ 3577.929642] ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0
>> pio 16392 in
>> [ 3577.929642]          res 50/00:03:00:00:00/00:00:00:00:00/a0 Emask
>> 0x10 (ATA bus error)
>> [ 3577.932954] ata2.00: status: { DRDY }
>> [ 3577.934264] ata2: hard resetting link
>> [ 3578.662228] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [ 3578.665211] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>> filtered out
>> [ 3578.669355] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>> filtered out
>> [ 3578.670969] ata2.00: configured for UDMA/100
>> [ 3578.694145] ata2: EH complete
>>
>> Is it linux driver, or maybe
>>
>> $ lspci # sata information only
>> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
>> 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
>>          Subsystem: Intel Corporation Device 7270
>>          Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 20
>>          I/O ports at 2098 [size=8]
>>          I/O ports at 20bc [size=4]
>>          I/O ports at 2090 [size=8]
>>          I/O ports at 20b8 [size=4]
>>          I/O ports at 2060 [size=32]
>>          Memory at a0816000 (32-bit, non-prefetchable) [size=2K]
>>          Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>>          Capabilities: [70] Power Management version 3
>>          Capabilities: [a8] SATA HBA v1.0
>>          Capabilities: [b0] PCI Advanced Features
>>          Kernel driver in use: ahci
>>
>> $ uname -a
>> Linux macbook-pro 3.6.5macbook-pro-custom-v0.1 #4 SMP Sun Nov 4
>> 12:39:03 UTC 2012 x86_64 GNU/Linux
>> $ cat /etc/debian_version
>> wheezy/sid
>>
>> In OSX there is no errors with hard drive.
>>
>> What else can I do investigate this situation next?
>>
>> --
>> Azat Khuzhin
>
>
>

