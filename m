Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2H3PkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:40:04 -0400
Received: from yak.ibink.com ([173.255.217.96]:35138 "EHLO yak.ibink.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2H3PkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:40:01 -0400
X-Greylist: delayed 1486 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2012 11:40:00 EDT
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Subject: Re: Which disk is ata4?
From: Tim Nufire <linux_ide_tim@ibink.com>
In-Reply-To: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
Date: Thu, 30 Aug 2012 08:15:13 -0700
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <9058FA5F-3F4F-495D-AC5F-4C6C05EC0FC5@ibink.com>
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
X-Mailer: Apple Mail (2.1486)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not sure if there is a better way, but on Debian 5 "Squeeze" I look at the contents of the directory /dev/disk/by-path/

ls -l /dev/disk/by-path/
total 0
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:00:1f.2-scsi-0:0:0:0 -> ../../sdae
lrwxrwxrwx 1 root root 11 2012-08-08 14:42 pci-0000:00:1f.2-scsi-0:0:0:0-part1 -> ../../sdae1
lrwxrwxrwx 1 root root 11 2012-08-08 14:42 pci-0000:00:1f.2-scsi-0:0:0:0-part2 -> ../../sdae2
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:0:0:0 -> ../../sda
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:1:0:0 -> ../../sdb
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:2:0:0 -> ../../sdc
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:3:0:0 -> ../../sdd
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-0:4:0:0 -> ../../sde
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:0:0:0 -> ../../sdf
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:1:0:0 -> ../../sdg
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:2:0:0 -> ../../sdh
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:3:0:0 -> ../../sdi
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-3:4:0:0 -> ../../sdj
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:0:0:0 -> ../../sdk
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:1:0:0 -> ../../sdl
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:2:0:0 -> ../../sdm
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:3:0:0 -> ../../sdn
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:02:04.0-scsi-4:4:0:0 -> ../../sdo
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:0:0:0 -> ../../sdp
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:1:0:0 -> ../../sdq
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:2:0:0 -> ../../sdr
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:3:0:0 -> ../../sds
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-0:4:0:0 -> ../../sdt
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:0:0:0 -> ../../sdu
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:1:0:0 -> ../../sdv
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:2:0:0 -> ../../sdw
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:3:0:0 -> ../../sdx
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-2:4:0:0 -> ../../sdy
lrwxrwxrwx 1 root root  9 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:0:0:0 -> ../../sdz
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:1:0:0 -> ../../sdaa
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:2:0:0 -> ../../sdab
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:3:0:0 -> ../../sdac
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:04:04.0-scsi-3:4:0:0 -> ../../sdad
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:0:0:0 -> ../../sdaf
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:1:0:0 -> ../../sdag
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:2:0:0 -> ../../sdah
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:3:0:0 -> ../../sdai
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-0:4:0:0 -> ../../sdaj
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:0:0:0 -> ../../sdak
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:1:0:0 -> ../../sdal
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:2:0:0 -> ../../sdam
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:3:0:0 -> ../../sdan
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-2:4:0:0 -> ../../sdao
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:0:0:0 -> ../../sdap
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:1:0:0 -> ../../sdaq
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:2:0:0 -> ../../sdar
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:3:0:0 -> ../../sdas
lrwxrwxrwx 1 root root 10 2012-08-08 14:42 pci-0000:06:04.0-scsi-3:4:0:0 -> ../../sdat

The SCSI ids are one less than ATA ids because they start at 0 rather than 1. So, ata4.00 is the same as scsi-3:0:0:0. On my system this means that ata4.00 is sdap.

Tim

On Aug 29, 2012, at 9:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:

> One of my disks went out to lunch for a while.  Logs below.
> 
> Which one is it?  The only useful thing in /sys/class/ata_port/ata4 is
> the device symlink, which points at
> /sys/devices/pci0000:00/0000:00:1f.2/ata4.  That, in turn, has an
> ata_port directory (contains nothing I don't already know) and a link4
> directory.  The ata_link directory is unhelpful, as is
> /sys/devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0.
> 
> Taking a leap of faith, /sys/devices/pci0000:00/0000:00:1f.2 contains
> ata1-6 and host0-5.  So maybe ata4 is host3.  Following lots of
> symlinks through host3 leads me to the block device sdd.  Maybe that's
> correct?  I'm really not sure.  Am I missing something obvious?
> 
> I even tried looking for symlinks the other way, like this:
> 
> /sys$ find -type l -exec echo -n {} ' ' \; -exec readlink {} \; |grep ata4
> ./devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4/subsystem
> ../../../../../../class/ata_port
> ./devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4/device  ../../../ata4
> ./devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4/subsystem
> ../../../../../../../class/ata_link
> ./devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4/device
> ../../../link4
> ./devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0/subsystem
> ../../../../../../../../class/ata_device
> ./devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0/device
> ../../../dev4.0
> ./class/ata_link/link4
> ../../devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4
> ./class/ata_port/ata4  ../../devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4
> ./class/ata_device/dev4.0
> ../../devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0
> 
> No luck.
> 
> [784786.047673] ata4.00: exception Emask 0x10 SAct 0x7800 SErr 0x0
> action 0x6 frozen
> [784786.047707] ata4.00: irq_stat 0x08000000, interface fatal error
> [784786.047730] ata4.00: failed command: READ FPDMA QUEUED
> [784786.047752] ata4.00: cmd 60/40:58:80:a9:48/00:00:86:00:00/40 tag
> 11 ncq 32768 in
> [784786.047753]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
> 0x12 (ATA bus error)
> [784786.047805] ata4.00: status: { Busy }
> [784786.047819] ata4.00: failed command: READ FPDMA QUEUED
> [784786.047840] ata4.00: cmd 60/40:60:80:aa:48/00:00:86:00:00/40 tag
> 12 ncq 32768 in
> [784786.047841]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
> 0x12 (ATA bus error)
> [784786.047893] ata4.00: status: { Busy }
> [784786.047907] ata4.00: failed command: READ FPDMA QUEUED
> [784786.047928] ata4.00: cmd 60/40:68:c0:aa:48/00:00:86:00:00/40 tag
> 13 ncq 32768 in
> [784786.047929]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
> 0x12 (ATA bus error)
> [784786.047981] ata4.00: status: { Busy }
> [784786.047996] ata4.00: failed command: READ FPDMA QUEUED
> [784786.048016] ata4.00: cmd 60/40:70:00:ab:48/00:00:86:00:00/40 tag
> 14 ncq 32768 in
> [784786.048017]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
> 0x12 (ATA bus error)
> [784786.048067] ata4.00: status: { Busy }
> [784786.048085] ata4: hard resetting link
> [784786.365119] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [784786.380854] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> [784786.380860] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY
> FREEZE LOCK) filtered out
> [784786.380864] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [784786.382279] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> [784786.382283] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY
> FREEZE LOCK) filtered out
> [784786.382287] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [784786.382747] ata4.00: configured for UDMA/133
> [784786.382761] ata4: EH complete
> 
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

