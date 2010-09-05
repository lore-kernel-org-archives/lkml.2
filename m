Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0IENu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:50:28 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:55044
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750863Ab0IENu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:50:27 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH] acpi: Provide decls for standalone compilation of video.h without ACPI (v2)
Date: Sun,  5 Sep 2010 14:51:49 +0100
Message-Id: <1283694709-8504-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283693757-8199-1-git-send-email-chris@chris-wilson.co.uk>
References: <1283693757-8199-1-git-send-email-chris@chris-wilson.co.uk>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
---
 include/acpi/video.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/acpi/video.h b/include/acpi/video.h
index 551793c..0e98e67 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -1,6 +1,10 @@
 #ifndef __ACPI_VIDEO_H
 #define __ACPI_VIDEO_H
 
+#include <linux/errno.h> /* for ENODEV */
+
+struct acpi_device;
+
 #define ACPI_VIDEO_DISPLAY_CRT  1
 #define ACPI_VIDEO_DISPLAY_TV   2
 #define ACPI_VIDEO_DISPLAY_DVI  3
@@ -26,4 +30,3 @@ static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 #endif
 
 #endif
-
-- 
1.7.1

