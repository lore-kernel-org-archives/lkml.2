Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1AESdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:33:52 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:51716 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649Ab1AESdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:33:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=ZRScNgAoNDIudAmCzicl2RzHtq/NqQNi64RAWT4r7WSFqkisSJ9DPWk7/lc315UP;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D24B98D.6080307@earthlink.net>
Date: Wed, 05 Jan 2011 13:33:49 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Kernel 2.6.37 erroneously limiting to UDMA/33
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79e08268ac84235dfcefc3281192bba066350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Why is the kernel limiting me to udma/33 when the device says it can do
ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66

There is no cable the compact flash is a socket on the motherboard!

Loading sd_mod.ko module
Loading libata.ko module
Loading ata_generic.ko module
Loading pata_acpi.ko module
pata_acpi 0000:00:0f.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pata_acpi 0000:00:0f.0: PCI INT B disabled
Loading pata_via.ko module
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
ata2.01: 7962192 sectors, multi 0: LBA
ata2.01: limited to UDMA/33 due to 40-wire cable
ata2.01: configured for UDMA/33
scsi 1:0:1:0: Direct-Access     ATA      TRANSCEND        2007 PQ: 0 ANSI: 5
sd 1:0:1:0: [sda] 7962192 512-byte logical blocks: (4.07 GB/3.79 GiB)
sd 1:0:1:0: [sda] Write Protect is off
sd 1:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DA
  sda: sda1 sda2 sda3
sd 1:0:1:0: [sda] Attached SCSI disk
Loading ata_piix.ko module

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



