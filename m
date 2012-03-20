Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2CTCtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 22:49:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47848 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab2CTCtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 22:49:04 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: randy.dunlap@oracle.com, mjg59@srcf.ucam.org, gregkh@suse.de,
        trenn@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Dennis.Jansen@web.de, airlied@linux.ie, airlied@redhat.com,
        eric@anholt.net, alexdeucher@gmail.com, bskeggs@redhat.com,
        chris@chris-wilson.co.uk, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH] gpu: schedule gma500 stub driver for feature removal
Date: Tue, 20 Mar 2012 10:47:04 +0800
Message-Id: <1332211624-11566-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.3, the gma500 drm driver moved from staging to drm group by
Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
brightness well and don't need gma500 stub driver anymore.

So, my plan is remove gma500 stub driver at Dec. 2012.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 Documentation/feature-removal-schedule.txt |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a0ffac0..219d6f1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -524,3 +524,14 @@ Files:	arch/arm/mach-at91/at91cap9.c
 Why:	The code is not actively maintained and platforms are now hard to find.
 Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
 	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+
+----------------------------
+
+What:	Intel GMA500 Stub Driver
+When:	December 2012
+Why:	In v3.3, the gma500 drm driver moved from staging to drm group by
+	Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
+	brightness well and don't need gma500 stub driver anymore.
+
+	So, my plan is remove gma500 stub driver at Dec. 2012.
+Who:	Lee, Chun-Yi <jlee@novell.com>
-- 
1.6.0.2

