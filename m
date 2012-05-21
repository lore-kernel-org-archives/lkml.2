Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2EUP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:27:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2EUP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:27:20 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        randy.dunlap@oracle.com, mjg59@srcf.ucam.org, gregkh@suse.de,
        trenn@suse.de, Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de,
        airlied@redhat.com, eric@anholt.net, alexdeucher@gmail.com,
        bskeggs@redhat.com, chris@chris-wilson.co.uk
Subject: [PATCH] gpu: schedule gma500 stub driver for feature removal
Date: Mon, 21 May 2012 23:23:36 +0800
Message-Id: <1337613816-12953-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In v3.3, the gma500 drm driver moved from staging to drm group by
Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
brightness well and don't need gma500 stub driver anymore.

So, my plan is remove gma500 stub driver at Dec. 2012.

Cc: randy.dunlap@oracle.com
Cc: mjg59@srcf.ucam.org
Cc: gregkh@suse.de
Cc: trenn@suse.de
Cc: Valdis.Kletnieks@vt.edu
Cc: Dennis.Jansen@web.de
Cc: airlied@redhat.com
Cc: eric@anholt.net
Cc: alexdeucher@gmail.com
Cc: bskeggs@redhat.com
Cc: chris@chris-wilson.co.uk
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

