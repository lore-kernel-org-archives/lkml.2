Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2GKA0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:26:43 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:45120 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab2GKA0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:26:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1341966400!13971793!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 83/83] staging: comedi: rtd520: cleanup the boardinfo
Date: Tue, 10 Jul 2012 17:26:37 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101726.37315.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a couple unnecessary comments. For aesthetic reasons, add
some whitespace to the boardinfo to improve readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 38 +++++++++++++++------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 102e635..5a2953e 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -265,11 +265,8 @@ static const struct comedi_lrange rtd_ao_range = {
 	}
 };
 
-/*
-  Board descriptions
- */
 struct rtdBoard {
-	const char *name;	/* must be first */
+	const char *name;
 	int device_id;
 	int aiChans;
 	int aiBits;
@@ -280,23 +277,22 @@ struct rtdBoard {
 
 static const struct rtdBoard rtd520Boards[] = {
 	{
-	 .name = "DM7520",
-	 .device_id = 0x7520,
-	 .aiChans = 16,
-	 .aiBits = 12,
-	 .aiMaxGain = 32,
-	 .range10Start = 6,
-	 .rangeUniStart = 12,
-	 },
-	{
-	 .name = "PCI4520",
-	 .device_id = 0x4520,
-	 .aiChans = 16,
-	 .aiBits = 12,
-	 .aiMaxGain = 128,
-	 .range10Start = 8,
-	 .rangeUniStart = 16,
-	 },
+		.name		= "DM7520",
+		.device_id	= 0x7520,
+		.aiChans	= 16,
+		.aiBits		= 12,
+		.aiMaxGain	= 32,
+		.range10Start	= 6,
+		.rangeUniStart	= 12,
+	}, {
+		.name		= "PCI4520",
+		.device_id	= 0x4520,
+		.aiChans	= 16,
+		.aiBits		= 12,
+		.aiMaxGain	= 128,
+		.range10Start	= 8,
+		.rangeUniStart	= 16,
+	},
 };
 
 /*
-- 
1.7.11

