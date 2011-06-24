Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab1FXPIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:08:10 -0400
Received: from nm18-vm1.bullet.mail.ird.yahoo.com ([77.238.189.217]:33487 "HELO
	nm18-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757103Ab1FXPIG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:08:06 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 396982.4228.bm@omp1029.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hkQFHmu7qUAO3sZKluzzZALdYaXCQls35GLiZKoqSOaBF5ZSaAR5z5c9fxuSgN6EfCnorF7S6+uQq1hEQ7ovZ+b7ZTLlBd5lUNxJMM651Bm4UdFKABry/C5NoSW9rK7xb9q1FhPSlEcVnovzFH42ni+ZxFgk8fu/V7cLyBn6Acw=;
Message-ID: <216158.20018.qm@web29012.mail.ird.yahoo.com>
X-YMail-OSG: 5eSFY5EVM1mYJx_4YwmJbCQOp8eiR9H2aYRAYkclLi1vXTc
 LL6tayiqKBRAKzTT.1Brlq4pEUdSHvUvesWojL6lS3zUbgxE9TgGZ0V0ot_U
 6F9SKk46kW23WvkZtfFmi16_tC38GQkfK5vw3458sCXq6OLqFQeuJKt9ZSpD
 QUc.z4WOnYQ8v51hXVNSudP8.kSuVXvtqXXAnQdUSgldtO9109deSwViVZJu
 z.jTucSej4pyojN0G3fsBY04KkPG7dLd8w61m7cGcKN.8zY6IY.rBI35HWxY
 uLnm1X3iXQpJ..3rd_WuoL.NhSXC4Q7dvRIVrSrafr4eKyKX9AyIWf1IdplI
 qnocJNW8ctLD6WD2HmfHWD5o2L_Q-
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.111.304355
Date: Fri, 24 Jun 2011 16:08:03 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: w1/ds1wm regression after 2.6.39: "bus error, retrying"
To: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru, dagenaisj@sonatest.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux-3.0-rc4 DS1WM 1-wire driver is logging "bus error, retrying" error messages on an HP iPAQ hx4700 PDA (XScale-PXA270):

<snip>
Driver for 1-wire Dallas network protocol.
DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
ds1wm ds1wm: pass: 1 bus error, retrying
ds1wm ds1wm: pass: 2 bus error, retrying
ds1wm ds1wm: pass: 3 bus error, retrying
ds1wm ds1wm: pass: 4 bus error, retrying
ds1wm ds1wm: pass: 5 bus error, retrying
ds1wm ds1wm: pass: 6 bus error, retrying
ds1wm ds1wm: pass: 7 bus error, retrying
ds1wm ds1wm: pass: 8 bus error, retrying
ds1wm ds1wm: pass: 9 bus error, retrying
ds1wm ds1wm: pass: 10 bus error, retrying
ds1wm ds1wm: pass: 11 bus error, retrying
ds1wm ds1wm: pass: 12 bus error, retrying
ds1wm ds1wm: pass: 13 bus error, retrying
ds1wm ds1wm: pass: 14 bus error, retrying
ds1wm ds1wm: pass: 15 bus error, retrying
ds1wm ds1wm: pass: 16 bus error, retrying
ds1wm ds1wm: pass: 17 bus error, retrying
ds1wm ds1wm: pass: 18 bus error, retrying
ds1wm ds1wm: pass: 19 bus error, retrying
ds1wm ds1wm: pass: 20 bus error, retrying
ds1wm ds1wm: pass: 21 bus error, retrying
ds1wm ds1wm: pass: 22 bus error, retrying
ds1wm ds1wm: pass: 23 bus error, retrying
ds1wm ds1wm: pass: 24 bus error, retrying
ds1wm ds1wm: pass: 25 bus error, retrying
ds1wm ds1wm: pass: 26 bus error, retrying
ds1wm ds1wm: pass: 27 bus error, retrying
ds1wm ds1wm: pass: 28 bus error, retrying
ds1wm ds1wm: pass: 29 bus error, retrying
ds1wm ds1wm: pass: 30 bus error, retrying
ds1wm ds1wm: pass: 31 bus error, retrying
ds1wm ds1wm: pass: 32 bus error, retrying
ds1wm ds1wm: pass: 33 bus error, retrying
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 124)
scsi0 : pata_pcmcia
ata1: PATA max PIO0 cmd 0xc4820000 ctl 0xc482000e irq 124
ds1wm ds1wm: pass: 34 bus error, retrying
ds1wm ds1wm: pass: 35 bus error, retrying
ds1wm ds1wm: pass: 36 bus error, retrying
ds1wm ds1wm: pass: 37 bus error, retrying
ds1wm ds1wm: pass: 38 bus error, retrying
ds1wm ds1wm: pass: 39 bus error, retrying
ds1wm ds1wm: pass: 40 bus error, retrying
ds1wm ds1wm: pass: 41 bus error, retrying
ds1wm ds1wm: pass: 42 bus error, retrying
ds1wm ds1wm: pass: 43 bus error, retrying
ds1wm ds1wm: pass: 44 bus error, retrying
ata1.00: CFA: CF Card, Ver1.27, max PIO4
ata1.00: 2014992 sectors, multi 0: LBA 
ds1wm ds1wm: pass: 45 bus error, retrying
ds1wm ds1wm: pass: 46 bus error, retrying
ata1.00: configured for PIO0
scsi 0:0:0:0: Direct-Access     ATA      CF Card          Ver1 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 2014992 512-byte logical blocks: (1.03 GB/983 MiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI removable disk
ds1wm ds1wm: pass: 47 bus error, retrying
APM Battery Driver
mmc0 at 0xc48d2800 irq 130
Registered led device: hx4700:amber
Registered led device: hx4700:green
Registered led device: hx4700:blue
TCP cubic registered
NET: Registered protocol family 17
XScale iWMMXt coprocessor detected.
pxa-rtc pxa-rtc: setting system clock to 2000-01-01 00:00:07 UTC (946684807)
Warning: unable to open an initial console.
VFS: Mounted root (jffs2 filesystem) readonly on device 31:2.
Freeing init memory: 104K
mmc0: new SD card at address 1234
mmcblk0: mmc0:1234 SD01G 972 MiB 
 mmcblk0: p1
udevd (337): /proc/337/oom_adj is deprecated, please use /proc/337/oom_score_adj instead.
g_serial gadget: Gadget Serial v2.4
g_serial gadget: g_serial ready
pxa27x-udc pxa27x-udc: USB reset
pxa27x-udc pxa27x-udc: USB reset
pxa27x-udc pxa27x-udc: USB reset
g_serial gadget: full speed config #1: Generic Serial config
ds1wm ds1wm: pass: 1 bus error, retrying
ds1wm ds1wm: pass: 2 bus error, retrying
ds1wm ds1wm: pass: 3 bus error, retrying
<snip>
ds1wm ds1wm: pass: 91 bus error, retrying
ds1wm ds1wm: pass: 92 bus error, retrying
ds1wm ds1wm: pass: 93 bus error, retrying
ds1wm ds1wm: pass: 1 bus error, retrying
ds1wm ds1wm: pass: 2 bus error, retrying
ds1wm ds1wm: pass: 3 bus error, retrying
<snip>
ds1wm ds1wm: pass: 29 bus error, retrying
ds1wm ds1wm: pass: 30 bus error, retrying
ds1wm ds1wm: pass: 31 bus error, retrying
ds1wm ds1wm: pass: 1 bus error, retrying
ds1wm ds1wm: pass: 2 bus error, retrying
ds1wm ds1wm: pass: 3 bus error, retrying
<snip>
ds1wm ds1wm: pass: 98 bus error, retrying
ds1wm ds1wm: pass: 99 bus error, retrying
ds1wm ds1wm: pass: 100 bus error, retrying
ds1wm ds1wm: pass: 1 bus error, retrying
ds1wm ds1wm: pass: 2 bus error, retrying
ds1wm ds1wm: pass: 3 bus error, retrying
<snip>
ds1wm ds1wm: pass: 92 bus error, retrying
ds1wm ds1wm: pass: 93 bus error, retrying
ds1wm ds1wm: pass: 94 bus error, retrying
ds1wm ds1wm: pass: 1 bus error, retrying
ds1wm ds1wm: pass: 2 bus error, retrying
ds1wm ds1wm: pass: 3 bus error, retrying
<snip>
ds1wm ds1wm: pass: 98 bus error, retrying
ds1wm ds1wm: pass: 99 bus error, retrying
ds1wm ds1wm: pass: 100 bus error, retrying
<snip>

The visible result is that the battery charging LED is erratic; sometimes it works, mostly it doesn't.

The linux-2.6.39 DS1WM 1-wire driver worked OK. I haven't tried 3.0-rc1, 3.0-rc2, or 3.0-rc3.

Regards.
