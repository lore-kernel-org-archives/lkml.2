Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab2KEXF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:29 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39896 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab2KEXFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:16 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rob Landley <rob@landley.net>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 022/104] Documentation/laptops: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:39 -0800
Message-Id: <1352156701-4038-23-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Rob Landley <rob@landley.net>
CC: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/laptops/thinkpad-acpi.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 9d66682..cf7bc6c 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1398,7 +1398,7 @@ Sysfs notes:
 EXPERIMENTAL: UWB
 -----------------
 
-This feature is marked EXPERIMENTAL because it has not been extensively
+This feature is considered EXPERIMENTAL because it has not been extensively
 tested and validated in various ThinkPad models yet.  The feature may not
 work as expected. USE WITH CAUTION! To use this feature, you need to supply
 the experimental=1 parameter when loading the module.
-- 
1.7.9.5

