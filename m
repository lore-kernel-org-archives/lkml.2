Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0LVKnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:43:12 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:24970 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751290Ab0LVKnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:43:09 -0500
Date: Wed, 22 Dec 2010 11:43:06 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101222104306.GB30941@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home> <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unquoted text below is from either me or from my friend. 


Someone suggested we try an older kernel as if kernel 2.6.32 would not
have this problem. We do NOT think it suddenly started with a certain
kernel version. I was just hoping to have you kernel-guys help with
prodding the kernel into revealing which component was screwing things
up....


On Mon, Dec 20, 2010 at 01:32:44PM -0500, Greg Freemyer wrote:
> On Mon, Dec 20, 2010 at 1:06 PM, Bruno Prémont
> <bonbons@linux-vserver.org> wrote:
> > Hi,
> >
> > [ccing linux-ide]
> >
> > Please provide the part of kernel log showing initialization of your
> > disk controller(s) as well as detection of all the discs.


sata_sil 0000:03:01.0: version 2.4
sata_sil 0000:03:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
sata_sil 0000:03:01.0: Applying R_ERR on DMA activate FIS errata fix
scsi2 : sata_sil
scsi3 : sata_sil
scsi4 : sata_sil
scsi5 : sata_sil
ata3: SATA max UDMA/100 mmio m1024@0xed200000 tf 0xed200080 irq 24
ata4: SATA max UDMA/100 mmio m1024@0xed200000 tf 0xed2000c0 irq 24
ata5: SATA max UDMA/100 mmio m1024@0xed200000 tf 0xed200280 irq 24
ata6: SATA max UDMA/100 mmio m1024@0xed200000 tf 0xed2002c0 irq 24
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
usb 2-2: new low speed USB device using uhci_hcd and address 2
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/100
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/100
scsi 4:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata6.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/100
scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 5:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 3:0:0:0: [sdb] Attached SCSI disk
 sda: sda1 sda2 sda3 sda4
sd 2:0:0:0: [sda] Attached SCSI disk
 sdc: sdc1 sdc2 sdc3 sdc4
sd 4:0:0:0: [sdc] Attached SCSI disk
 sdd: sdd1 sdd2 sdd3 sdd4
sd 5:0:0:0: [sdd] Attached SCSI disk



> > Verbose lspci output for the disc controller and $(smartctl -i -A $disk)
> > output might be useful as well.


03:01.0 Mass storage controller: Silicon Image, Inc. SiI 3114
[SATALink/SATARaid] Serial ATA Controller (rev 02)
        Subsystem: Silicon Image, Inc. SiI 3114 SATALink Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 24
        Region 0: I/O ports at 4020 [size=8]
        Region 1: I/O ports at 4014 [size=4]
        Region 2: I/O ports at 4018 [size=8]
        Region 3: I/O ports at 4010 [size=4]
        Region 4: I/O ports at 4000 [size=16]
        Region 5: Memory at ed200000 (32-bit, non-prefetchable) [size=1K]
        [virtual] Expansion ROM at e8000000 [disabled] [size=512K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
                PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: sata_sil
        Kernel modules: sata_sil


But also tried onboard card:

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Super Micro Computer Inc Device 7980
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 30a0 [size=16]
        Kernel driver in use: ata_piix
        Kernel modules: ata_generic, pata_acpi, ata_piix, ide-pci-generic,
        piix

smartctl output:
        Kernel modules: ata_generic, pata_acpi, ata_piix, ide-pci-generic,
        piix

smartctl output:

smartctl 5.40 2010-10-16 r3189 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD10EARS-00Y5B1
Serial Number:    WD-WCAV55759454
Firmware Version: 80.00A80
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Dec 21 20:06:00 2010 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   132   119   021    Pre-fail
Always       -       6391
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       56
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   091   091   000    Old_age
Always       -       7189
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       54
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
      -       39
193 Load_Cycle_Count        0x0032   164   164   000    Old_age   Always
      -       109955
194 Temperature_Celsius     0x0022   109   107   000    Old_age   Always
      -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0
      -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

smartctl 5.40 2010-10-16 r3189 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD10EARS-00Y5B1
Serial Number:    WD-WCAV55759454
Firmware Version: 80.00A80
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Dec 21 20:06:00 2010 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   132   119   021    Pre-fail
Always       -       6391
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       56
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   091   091   000    Old_age
Always       -       7189
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       54
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
      -       39
193 Load_Cycle_Count        0x0032   164   164   000    Old_age   Always
      -       109955
194 Temperature_Celsius     0x0022   109   107   000    Old_age   Always
      -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always
      -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always
      -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

smartctl 5.40 2010-10-16 r3189 [x86_64-unknown-linux-gnu] (local build)
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0


The others are very similar.... 


> >
> > Did you try the individual discs on a completely different system (e.g.
> > plain desktop system) and what revision of SATA are both components
> > supporting?

Yes I did. The disks were installed in a MSI/Core2DUO based desktop
system. No problems at all. Transfer rates up to 200MB/s.


The SIL 3114 chip is 1.5Gbps SATA. . 


Searching for information on the WD drives I stumbled across: 

http://community.wdc.com/t5/Other-Internal-Drives/1-TB-WD10EARS-desynch-issues-in-RAID/m-p/11559

Where it seems that WD simply says not to use these drives in a RAID.
I have experience with "Raid Edition" drives: They go bad at a MUCH
too high rate. If we can't use the non-raid for a RAID application, then
there is just ONE possible option: STAY AWAY FROM WESTERN DIGITAL:

Western digital claims it has the right to mess things up if you put a
non-raid drive in a raid configuration. Well fine. Then they can also
mess things up in normal situations because when Linux does software
raid there isn't any difference from RAID accesses.

(if you click through and read their entry in the knowledge base,
you'd notice that it should be more or less the other way
around. Linux will drop the RAID-enabled drive from the RAID within
seven seconds and reporting error on a sector, whereas the desktop
drive would remain operational until Linux times out (30 seconds?))



More hardware info:

System: Supermicro PDSMi, 4xDDR2 1GB, disks and controllers as above.
Current kernel version: 2.6.36.2
Problem was also present in kernel 2.6.33 (sorry cannot downgrade again.
This is a production system...)

uname -a:
Linux jcz.nl 2.6.36-ARCH #1 SMP PREEMPT Fri Dec 10 20:32:37 CET 2010
x86_64 Intel(R) Pentium(R) D CPU 3.20GHz GenuineIntel GNU/Linux

Disklayout:

major minor  #blocks  name

   8        0  976762584 sda
   8        1     240943 sda1
   8        2   19535040 sda2
   8        3    1951897 sda3
   8        4  955032120 sda4
   8       16  976762584 sdb
   8       17     240943 sdb1
   8       18   19535040 sdb2
   8       19    1951897 sdb3
   8       20  955032120 sdb4
   8       32  976762584 sdc
   8       33     240943 sdc1
   8       34   19535040 sdc2
   8       35    1951897 sdc3
   8       36  955032120 sdc4
   8       48  976762584 sdd
   8       49     240943 sdd1
   8       50   19535040 sdd2
   8       51    1951897 sdd3
   8       52  955032120 sdd4
   9      127     240832 md127
   9        1   39067648 md1
   9      126 1910063104 md126
   9      125    3903488 md125

MDstat:

Personalities : [raid1] [raid6] [raid5] [raid4]
md125 : active raid5 sdd3[5](S) sdb3[4] sda3[0] sdc3[3]
      3903488 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

md126 : active raid5 sda4[0] sdd4[3] sdc4[5](S) sdb4[4]
      1910063104 blocks super 1.1 level 5, 512k chunk, algorithm 2
[3/3] [UUU]

md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
      39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
[3/3] [UUU]

md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
      39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
[UUU]

md127 : active raid1 sdd1[3](S) sda1[0] sdb1[1] sdc1[2]
      240832 blocks [3/3] [UUU]

unused devices: <none>
rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sys /sys sysfs rw,relatime 0 0
udev /dev devtmpfs
rw,nosuid,relatime,size=10240k,nr_inodes=506317,mode=755 0 0
/dev/disk/by-label/rootfs / ext4
rw,relatime,barrier=1,stripe=256,data=ordered 0 0
devpts /dev/pts devpts rw,relatime,mode=600,ptmxmode=000 0 0
shm /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
/dev/md127 /boot ext3
rw,relatime,errors=continue,barrier=0,data=writeback 0 0
/dev/md126 /data ext4 rw,relatime,barrier=1,data=ordered 0 0


Because of the severity of the problems (which remain after trying
another sata card), I have already bought a new Supermicro server. Let's
hope that helps.




-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
