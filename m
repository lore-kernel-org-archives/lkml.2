Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535Ab0KQGlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:41:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48220 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab0KQGlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:41:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=u4veBLoc69fAqccMQzjl4/7/iqOemV0yUjUSe0/oaSyf10LWG6UPGqTt6GDumNaNrs
         kOvBbmIy+sThbcrHkQNahNt3AZlCFnLzMKgRoikWOTE/wiu3NJChLrPGIO6UfPfR1ccm
         ARU6GNDFG+t+K6InvM754vYqbNQzhM74BqTZQ=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 17 Nov 2010 15:44:35 +0900
Message-Id: <20101117064435.18139.41134.sendpatchset@t400s>
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
References: <20101117064405.18139.57035.sendpatchset@t400s>
Subject: [PATCH 03/05] ARM: mach-shmobile: Extend AP4EVB MIPI-DSI resources
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the AP4EVB board code to go from a single I/O
resource to two I/O resources for the MIPI-DSI driver.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/board-ap4evb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- 0001/arch/arm/mach-shmobile/board-ap4evb.c
+++ work/arch/arm/mach-shmobile/board-ap4evb.c	2010-11-16 17:19:30.000000000 +0900
@@ -501,7 +501,12 @@ static struct platform_device keysc_devi
 static struct resource mipidsi0_resources[] = {
 	[0] = {
 		.start  = 0xffc60000,
-		.end    = 0xffc68fff,
+		.end    = 0xffc63073,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = 0xffc68000,
+		.end    = 0xffc680ef,
 		.flags  = IORESOURCE_MEM,
 	},
 };
