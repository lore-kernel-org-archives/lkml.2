Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0CQNk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 09:40:28 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:43886 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab0CQNkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=qUwyZlhA4BZPR0KEYlhOACM6Fij7Dwnh9p8KyLcnhgEA0CG2qh4RYh6kBKIgmGz6h2
         5vYV3q71LhCUcfJxant3VXAQZfPV3xdhIjjB2h61Zxhy/nZ3GDydtRAjxJ0/MiF6Om6n
         +w3IAu86Za8HJDqduI9C4qTNf8wifCwS994As=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, abbotti@mev.co.uk,
       mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/17] Staging: comedi: fix indent coding style issue in adl_pci9118.c
Date: Wed, 17 Mar 2010 13:40:11 +0000
Message-Id: <1268833211-2816-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to the adl_pci9118.c that fixes, ERROR: code indent should use tabs where possible, found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 791ea83..9f30dee 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -44,20 +44,20 @@ c) If isn't used DMA then you can use only mode where
 Configuration options:
   [0] - PCI bus of device (optional)
   [1] - PCI slot of device (optional)
-          If bus/slot is not specified, then first available PCI
-          card will be used.
+	If bus/slot is not specified, then first available PCI
+	card will be used.
   [2] - 0= standard 8 DIFF/16 SE channels configuration
-        n= external multiplexer connected, 1<=n<=256
+	n = external multiplexer connected, 1 <= n <= 256
   [3] - 0=autoselect DMA or EOC interrupts operation
-        1=disable DMA mode
-        3=disable DMA and INT, only insn interface will work
+	1 = disable DMA mode
+	3 = disable DMA and INT, only insn interface will work
   [4] - sample&hold signal - card can generate signal for external S&H board
-        0=use SSHO (pin 45) signal is generated in onboard hardware S&H logic
-        0!=use ADCHN7 (pin 23) signal is generated from driver, number
-           say how long delay is requested in ns and sign polarity of the hold
-           (in this case external multiplexor can serve only 128 channels)
+	0 = use SSHO(pin 45) signal is generated in onboard hardware S&H logic
+	0 != use ADCHN7(pin 23) signal is generated from driver, number say how
+		long delay is requested in ns and sign polarity of the hold
+		(in this case external multiplexor can serve only 128 channels)
   [5] - 0=stop measure on all hardware errors
-        2|=ignore ADOR - A/D Overrun status
+	2 | = ignore ADOR - A/D Overrun status
 	8|=ignore Bover - A/D Burst Mode Overrun status
 	256|=ignore nFull - A/D FIFO Full status
 
-- 
1.6.3.3

