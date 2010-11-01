Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0KAGJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 02:09:33 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60069 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0KAGJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 02:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eQHiCPJ7cJVM9Yz4hdOOlv9l5+4r0JS9XyIH2ANLzbeK8pba84ww7lWIoF7vnaR/M4
         yw64YOrz8mJmvL5j+M/OQq7j0VgZbxNn+fGealdHQ2WvJXToidYMCGAOBtSnp2TbKkMJ
         emwbcVPh+iYuYe4dMnmblr02T6NslfQ9MbLqU=
MIME-Version: 1.0
Date: Mon, 1 Nov 2010 14:09:28 +0800
Message-ID: <AANLkTimo1LjwUFntSJzBLYr5=VTEaiXzU5CR0KwG95Qe@mail.gmail.com>
Subject: [HELP] kernel hanging when boot after nash-hotplug in vmware
From: jovi zhang <bookjovi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I'm upgading fc12 to lastest kernel(2.6.36 mainline) in my vmware
invironment, but kernel hanging after screen display nash-hotplug,
like below:

Write protecting the kernel text: 3744k
Write protecting the kernel read-only data: 1808k
nash-hotplug (46): /proc/46/oom_adj is deprecated, please use
/proc/46/oom_score_adj instead.

then hanging there.
I compiled lastest kernel using i386 defconfig.

I compared this boot message with normal boot message. normal boot
message is like this:

Write protecting the kernel text: 3744k
Write protecting the kernel read-only data: 1808k
nash-hotplug (46): /proc/46/oom_adj is deprecated, please use
/proc/46/oom_score_adj instead.
pci 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi2: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi2:   Firmware Version: 5.07B, I/O Address: 0x10C0, IRQ Channel: 17/Level
scsi2:   PCI Bus: 0, Device: 16, Address: 0xD8800000, Host Adapter SCSI ID: 7
scsi2:   Parity Checking: Enabled, Extended Translation: Enabled
scsi2:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi2:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi2:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi2:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi2:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi2: *** BusLogic BT-958 Initialized Successfully ***
scsi2 : BusLogic BT-958
scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
sd 2:0:0:0: [sda] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 5d 00 00 00
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sda: sda1 sda2
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] Attached SCSI disk

I know this problem maybe caused by kernel configuation, maybe I miss
some item in my config.txt in this case.
so who can help me to solve this problem? Thanks very much

.jovi
