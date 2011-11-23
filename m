Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1KWMqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:46:36 -0500
Received: from mail.wdtv.com ([66.118.69.84]:47779 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1KWMqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:46:35 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Please, am I in danger of losing data?
Date: Wed, 23 Nov 2011 07:46:30 -0500
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos2.pae.bfs; KDE/4.6.5; i686; ; )
References: <4ECCDF65.2050208@davidkrider.com>
In-Reply-To: <4ECCDF65.2050208@davidkrider.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201111230746.31030.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 23, 2011, David Krider wrote:
>I get an lot of these messages these days. They don't fill me with
>confidence. I've searched the internet far and wide. I've filed bug
>reports with the kernel and the Ubuntu bugzillas. I've posted to this
>list. I'm not finding any solutions. At this point, can anyone just
>please tell me: Am I in danger of losing data? If so, I guess I can
>shelve my SSD until this stuff gets sorted.
>
>[    7.630904] ata1: EH in SWNCQ mode,QC:qc_active 0xE sactive 0xE
>[    7.630987] ata1: SWNCQ:qc_active 0x6 defer_bits 0x8 last_issue_tag
>0x2 [    7.630988]   dhfis 0x6 dmafis 0x6 sdbfis 0x1
>[    7.631131] ata1: ATA_REG 0x41 ERR_REG 0x84
>[    7.631201] ata1: tag : dhfis dmafis sdbfis sacitve
>[    7.631273] ata1: tag 0x1: 1 1 0 1
>[    7.631342] ata1: tag 0x2: 1 1 0 1
>[    7.631417] ata1.00: exception Emask 0x1 SAct 0xe SErr 0x0 action 0x6
>frozen
>[    7.631492] ata1.00: Ata error. fis:0x21
>[    7.631563] ata1.00: failed command: READ FPDMA QUEUED
>[    7.631637] ata1.00: cmd 60/08:08:b0:48:33/00:00:10:00:00/40 tag 1
>ncq 4096 in
>[    7.631637]          res 41/84:14:e0:64:f3/84:00:0f:00:00/40 Emask
>0x10 (ATA bus error)
>[    7.631811] ata1.00: status: { DRDY ERR }
>[    7.631880] ata1.00: error: { ICRC ABRT }
>[    7.631950] ata1.00: failed command: READ FPDMA QUEUED
>[    7.632024] ata1.00: cmd 60/08:10:e0:64:f3/00:00:0f:00:00/40 tag 2
>ncq 4096 in
>[    7.632025]          res 41/84:14:e0:64:f3/84:00:0f:00:00/40 Emask
>0x10 (ATA bus error)
>[    7.632198] ata1.00: status: { DRDY ERR }
>[    7.632268] ata1.00: error: { ICRC ABRT }
>[    7.632338] ata1.00: failed command: READ FPDMA QUEUED
>[    7.632411] ata1.00: cmd 60/08:18:f0:a6:b6/00:00:10:00:00/40 tag 3
>ncq 4096 in
>[    7.632412]          res 41/84:14:e0:64:f3/84:00:0f:00:00/40 Emask
>0x10 (ATA bus error)
>[    7.632585] ata1.00: status: { DRDY ERR }
>[    7.632655] ata1.00: error: { ICRC ABRT }
>[    7.632727] ata1: hard resetting link
>[    7.632728] ata1: nv: skipping hardreset on occupied port
>[    8.130020] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>[    8.161465] ata1.00: configured for UDMA/133
>[    8.161480] ata1: EH complete
>
The SSD may be about worn out, or it could be a flaky sata cable.  I'm 
using rotating media, and I have so far collected 4 bad sata cables hanging 
on a cabinet knob, all made of the exact shade of the infamous copper 
eating red plastic I've had trouble with for 40+ years.  If your cables are 
red with a hint of magenta, give some other color of cable a try.  The red 
ones?  At 3 years old you can get any resistance you want on an ohmmeter, 
just flex them.

>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene>
Anyone can do any amount of work provided it isn't the work he is supposed 
to be doing at the moment.
		-- Robert Benchley
