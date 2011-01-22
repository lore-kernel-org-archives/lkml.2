Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1AVPZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:25:06 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44763 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753331Ab1AVPZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:25:04 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18M8bQN0DIMkWLhaqM7zttoa1UeTiCKch9qyNwVas
	//G1NZGPFdCTUa
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: libata EH running when switching VTs
Date: Sat, 22 Jan 2011 16:25:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Message-Id: <201101221625.00775.toralf.foerster@gmx.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Henrique de Moraes Holschuh wrote at 14:11:12
> 
> I don't even know whom to refer you to.  Maybe ask in LKML directly?  Use
> the subject "libata EH running when switching VTs".  If one of those VTs
> are in X.org control, say that as well.

I'm wondering why I get this in /var/log/messages w/ kernel 2.6.37 when I
switch from VT7 (running xorg ) to VT12 (or 1 or 2 or another number) and 
back:


2011-01-22T16:20:53.854+01:00 n22 kernel: ata1: hard resetting link
2011-01-22T16:20:54.163+01:00 n22 kernel: ata1: SATA link up 1.5 Gbps (SStatus 
113 SControl 300)
2011-01-22T16:20:54.164+01:00 n22 kernel: ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
2011-01-22T16:20:54.164+01:00 n22 kernel: ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
2011-01-22T16:20:54.165+01:00 n22 kernel: ata1.00: ACPI cmd 
ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
2011-01-22T16:20:54.165+01:00 n22 kernel: ata1.00: ACPI cmd 
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd 
ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd 
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd 
ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
2011-01-22T16:20:54.169+01:00 n22 kernel: ata1.00: ACPI cmd 
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
2011-01-22T16:20:54.170+01:00 n22 kernel: ata1.00: configured for UDMA/100
2011-01-22T16:20:54.171+01:00 n22 kernel: ata1: EH complete


I'm running an almost stable Gentoo on a ThinkPad T400 with current kernel
(2.6.37, earlier shows this behaviour too)

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

