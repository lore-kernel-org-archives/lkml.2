Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab2BBFNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:13:00 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41382 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2BBFM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:12:59 -0500
Date: Thu, 2 Feb 2012 14:12:58 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET
	failed
Message-ID: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

since going from 3.2 to 3.3-rc1 I see a kind of regression wrt booting
time, namely the detection of the CD drive hangs for 10sec (both
dmesg were taken on the same hardware on the same day):

with 3.3-rc1 and rc2:
[    3.694012] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.004013] ata2: link is slow to respond, please be patient (ready=0)
[   13.652013] ata2: COMRESET failed (errno=-16)
[   13.972022] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   13.975721] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[   13.977166] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
[   13.981294] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[   13.982734] ata2.00: configured for UDMA/33
[   13.987964] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
[   13.991482] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   13.992971] cdrom: Uniform CD-ROM driver Revision: 3.20
[   13.994574] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   13.994672] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   14.316021] ata5: SATA link down (SStatus 0 SControl 300)
[   14.636019] ata6: SATA link down (SStatus 0 SControl 300)

with 3.2:
[    3.218156] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.484023] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.487708] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.489156] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
[    3.494321] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    3.495761] ata2.00: configured for UDMA/33
[    3.501057] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
[    3.504515] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.505995] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.507611] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.507715] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.828025] ata5: SATA link down (SStatus 0 SControl 300)
[    4.148020] ata6: SATA link down (SStatus 0 SControl 300)


Is there anything I can do here?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
LLANELLI (adj.)
Descriptive of the waggling movement of a person's hands when shaking
water from them or warming up for a piece of workshop theatre.
			--- Douglas Adams, The Meaning of Liff
