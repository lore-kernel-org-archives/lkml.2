Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1LSUZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:25:03 -0500
Received: from mail.snarked.org ([67.43.172.250]:41878 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1LSUZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:25:00 -0500
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: Possible logic bug in either EXT4 FS or SATA driver.
Date: Mon, 19 Dec 2011 12:24:54 -0800
Message-ID: <jco6iq$1dp$1@snarked.org>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1478
X-Priority: 3
X-Newsreader: Microsoft Outlook Express 6.00.2800.1478
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Syslog:
kernel: ata1: illegal qc_active transition (3fffffff->fffffffe)

When this happens, the filesystem on the offending disk is auto-remounted
as read-only.  Is this an indication of a bug in the ext4 filesystem or in
the SATA driver?

I am seeing this bug with a 3.1.5 kernel compiled from source about every
3-4 days.  Soft rebooting does not work; a hard reset is required.

System:  AMD Opteron 4184 stepping 01 (6-core) 2.8GHz (2794.027 MHz) 64-bit
MB:  Supermicro H8SCM-F / 32GB ECC Ram
HD:  ATA-8: ST32000644NS, SN11, max UDMA/133
     3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
     (1.81 TB) SATA link up 3.0 Gbps (SStatus 123 SControl 300)
     Write Protect is off / Mode Sense: 00 3a 00 00
     Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
EXT4:  Basic filesystem, no extended attributes nor using driver for
ext2/3.


