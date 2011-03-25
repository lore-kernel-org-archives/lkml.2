Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1CYPiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:38:05 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:44040 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1CYPiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:38:03 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201103251538.p2PFc11i001674@clem.clem-digital.net>
Subject: 2.6.38-git15+  IDE hangs boot
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Fri, 25 Mar 2011 11:38:01 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi:
2.6.38-git15+ bootup hangs with IDE. Following copied from screen:

Uniform Multi-Platform E-IDE driver
piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
piix 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x10a0-0x10a7
    ide1: BM-DMA at 0x10a8-0x10af
hda: Maxtor 90913D4, ATA DISK drive
hdb: ST51080A, ATA DISK drive
hda: UDMA/33 mode selected
hdb: MWDMA2 mode selected
Switching to clock source tsc
hdc: CRD-8400B, ATAPI CD/DVD-ROM drive
hdc: Disabling (U)DMA for CRD-8400B (blacklisted)
ide0 at 0x1f0-0x1f7,0x3f6 0n irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB


-- 
Pete Clements 
