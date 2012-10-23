Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab2JWVQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:16:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37088 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626Ab2JWUE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:04:58 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rob Landley <rob@landley.net>,
        Kumar Appaiah <a.kumar@alumni.iitm.ac.in>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 004/193] Documentation/laptops: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:17 -0700
Message-Id: <1351022666-6960-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Rob Landley <rob@landley.net>
CC: Kumar Appaiah <a.kumar@alumni.iitm.ac.in>
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

