Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030381Ab2AFPeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:34:07 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:56593 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030340Ab2AFPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:34:05 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        plagnioj@jcrosoft.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org
Cc: patrice.vilchez@atmel.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RFC] ARM: at91: removal of CAP9 SoC family
Date: Fri,  6 Jan 2012 16:33:52 +0100
Message-Id: <1325864033-20012-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel CAP9 family is not maintained well and products may be
difficult to find now. It will allow to save workforce and
remove LOC during current cleanup process.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3d84912..23dfea5 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -551,3 +551,17 @@ When:	3.5
 Why:	The iwlagn module has been renamed iwlwifi.  The alias will be around
 	for backward compatibility for several cycles and then dropped.
 Who:	Don Fry <donald.h.fry@intel.com>
+
+----------------------------
+
+What:	The CAP9 SoC family will be removed
+When:	3.4
+Files:	arch/arm/mach-at91/at91cap9.c
+	arch/arm/mach-at91/at91cap9_devices.c
+	arch/arm/mach-at91/include/mach/at91cap9.h
+	arch/arm/mach-at91/include/mach/at91cap9_matrix.h
+	arch/arm/mach-at91/include/mach/at91cap9_ddrsdr.h
+	arch/arm/mach-at91/board-cap9adk.c
+Why:	The code is not actively maintained and platforms are now hard to find.
+Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
+	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
-- 
1.7.5.4

