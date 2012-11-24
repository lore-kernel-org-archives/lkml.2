Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2KXTkD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 14:40:03 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37536 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2KXTkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 14:40:02 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <support@Supermicro.com>, <linux-kernel@vger.kernel.org>
Subject: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Sat, 24 Nov 2012 14:40:00 -0500
Message-ID: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac3Ke2TzLd2ZWvJxSwKOvsyzrTSI6g==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is the following normal on an X9SRL-F board (bios 1.0a)?

In the manual it states:

Data Direct I/O
Select Enabled to enable Intel I/OAT (I/O Acceleration Technology), which
significantly reduces CPU overhead by leveraging CPU architectural
improvements and freeing the system resource for other tasks. The options
are Disabled and Enabled.

Default is Enabled.

When enabled in the kernel, I see the following:

[    0.696357] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.696487] ioatdma 0000:00:04.0: channel error register unreachable
[    0.696546] ioatdma 0000:00:04.0: channel enumeration error
[    0.696604] ioatdma 0000:00:04.0: Intel(R) I/OAT DMA Engine init failed
[    0.696721] ioatdma 0000:00:04.1: channel error register unreachable
[    0.696779] ioatdma 0000:00:04.1: channel enumeration error
[    0.697522] ioatdma 0000:00:04.1: Intel(R) I/OAT DMA Engine init failed
[    0.697617] ioatdma 0000:00:04.2: channel error register unreachable
[    0.697681] ioatdma 0000:00:04.2: channel enumeration error
[    0.697739] ioatdma 0000:00:04.2: Intel(R) I/OAT DMA Engine init failed
[    0.697831] ioatdma 0000:00:04.3: channel error register unreachable
[    0.697890] ioatdma 0000:00:04.3: channel enumeration error
[    0.697948] ioatdma 0000:00:04.3: Intel(R) I/OAT DMA Engine init failed
[    0.698037] ioatdma 0000:00:04.4: channel error register unreachable
[    0.698095] ioatdma 0000:00:04.4: channel enumeration error
[    0.698153] ioatdma 0000:00:04.4: Intel(R) I/OAT DMA Engine init failed
[    0.698245] ioatdma 0000:00:04.5: channel error register unreachable
[    0.698303] ioatdma 0000:00:04.5: channel enumeration error
[    0.698360] ioatdma 0000:00:04.5: Intel(R) I/OAT DMA Engine init failed
[    0.698449] ioatdma 0000:00:04.6: channel error register unreachable
[    0.698508] ioatdma 0000:00:04.6: channel enumeration error
[    0.698565] ioatdma 0000:00:04.6: Intel(R) I/OAT DMA Engine init failed
[    0.698676] ioatdma 0000:00:04.7: channel error register unreachable
[    0.698735] ioatdma 0000:00:04.7: channel enumeration error
[    0.698792] ioatdma 0000:00:04.7: Intel(R) I/OAT DMA Engine init failed

--

Also, I tried using ASPM (enabled in BIOS), but since ACPI Linux query is
ignored, it fails to work:
[    0.562229] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored

I assume this is something Supermicro has to fix?

Justin.

