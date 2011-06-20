Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1FTRMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:12:14 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:48298 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755285Ab1FTRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:12:12 -0400
To: "Juergen E. Fischer" <fischer@norbit.de>
Subject: [PATCH] [resend] aha152x: add missing ISA PNP IDs
Cc: linux-scsi@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Mon, 20 Jun 2011 19:12:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201912.03876.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ISA PNP IDs of the following cards to aha152x driver:
AVA-1502
AVA-1505
AHA-1510
AVA-1515
AHA-1520
AHA-1522
AHA-1530
AHA-1532
AIC-6360
(list from SCSI.INF file)

This makes my AHA-1530P card (has ADP3015 ID) work automatically.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-orig/drivers/scsi/aha152x.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/scsi/aha152x.c	2011-06-09 21:11:47.000000000 +0200
@@ -422,10 +422,19 @@ MODULE_PARM_DESC(aha152x1, "parameters f
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id id_table[] __devinitdata = {
-	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-		ISAPNP_VENDOR('A','D','P'), ISAPNP_FUNCTION(0x1505), 0 },
-	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-		ISAPNP_VENDOR('A','D','P'), ISAPNP_FUNCTION(0x1530), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1502), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1505), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1510), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1515), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1520), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x2015), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1522), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x2215), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1530), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x3015), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1532), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x3215), 0 },
+	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x6360), 0 },
 	{ ISAPNP_DEVICE_SINGLE_END, }
 };
 MODULE_DEVICE_TABLE(isapnp, id_table);


-- 
Ondrej Zary
