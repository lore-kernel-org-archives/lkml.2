Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1KWL40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:56:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44230 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1KWL4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:56:24 -0500
Message-ID: <4ECCDF65.2050208@davidkrider.com>
Date: Wed, 23 Nov 2011 06:56:21 -0500
From: David Krider <david@davidkrider.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111110 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Please, am I in danger of losing data?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get an lot of these messages these days. They don't fill me with
confidence. I've searched the internet far and wide. I've filed bug
reports with the kernel and the Ubuntu bugzillas. I've posted to this
list. I'm not finding any solutions. At this point, can anyone just
please tell me: Am I in danger of losing data? If so, I guess I can
shelve my SSD until this stuff gets sorted.

[    7.630904] ata1: EH in SWNCQ mode,QC:qc_active 0xE sactive 0xE
[    7.630987] ata1: SWNCQ:qc_active 0x6 defer_bits 0x8 last_issue_tag 0x2
[    7.630988]   dhfis 0x6 dmafis 0x6 sdbfis 0x1
[    7.631131] ata1: ATA_REG 0x41 ERR_REG 0x84
[    7.631201] ata1: tag : dhfis dmafis sdbfis sacitve
[    7.631273] ata1: tag 0x1: 1 1 0 1 
[    7.631342] ata1: tag 0x2: 1 1 0 1 
[    7.631417] ata1.00: exception Emask 0x1 SAct 0xe SErr 0x0 action 0x6
frozen
[    7.631492] ata1.00: Ata error. fis:0x21
[    7.631563] ata1.00: failed command: READ FPDMA QUEUED
[    7.631637] ata1.00: cmd 60/08:08:b0:48:33/00:00:10:00:00/40 tag 1
ncq 4096 in
[    7.631637]          res 41/84:14:e0:64:f3/84:00:0f:00:00/40 Emask
0x10 (ATA bus error)
[    7.631811] ata1.00: status: { DRDY ERR }
[    7.631880] ata1.00: error: { ICRC ABRT }
[    7.631950] ata1.00: failed command: READ FPDMA QUEUED
[    7.632024] ata1.00: cmd 60/08:10:e0:64:f3/00:00:0f:00:00/40 tag 2
ncq 4096 in
[    7.632025]          res 41/84:14:e0:64:f3/84:00:0f:00:00/40 Emask
0x10 (ATA bus error)
[    7.632198] ata1.00: status: { DRDY ERR }
[    7.632268] ata1.00: error: { ICRC ABRT }
[    7.632338] ata1.00: failed command: READ FPDMA QUEUED
[    7.632411] ata1.00: cmd 60/08:18:f0:a6:b6/00:00:10:00:00/40 tag 3
ncq 4096 in
[    7.632412]          res 41/84:14:e0:64:f3/84:00:0f:00:00/40 Emask
0x10 (ATA bus error)
[    7.632585] ata1.00: status: { DRDY ERR }
[    7.632655] ata1.00: error: { ICRC ABRT }
[    7.632727] ata1: hard resetting link
[    7.632728] ata1: nv: skipping hardreset on occupied port
[    8.130020] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.161465] ata1.00: configured for UDMA/133
[    8.161480] ata1: EH complete

