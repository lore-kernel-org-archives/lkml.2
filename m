Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HSMzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:55:44 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:33929 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832Ab1HSMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:55:36 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, <linux-doc@vger.kernel.org>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v9 3/3] fault injection: add documentation on MMC IO fault injection
Date: Fri, 19 Aug 2011 14:52:38 +0200
Message-ID: <1313758358-27536-4-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
 <1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
 <1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

Add description on how to enable random fault injection
for MMC IO

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 Documentation/fault-injection/fault-injection.txt |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index 82a5d25..70f924e 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -21,6 +21,11 @@ o fail_make_request
   /sys/block/<device>/make-it-fail or
   /sys/block/<device>/<partition>/make-it-fail. (generic_make_request())
 
+o fail_mmc_request
+
+  injects MMC data errors on devices permitted by setting
+  debugfs entries under /sys/kernel/debug/mmc0/fail_mmc_request
+
 Configure fault-injection capabilities behavior
 -----------------------------------------------
 
@@ -115,7 +120,8 @@ use the boot option:
 
 	failslab=
 	fail_page_alloc=
-	fail_make_request=<interval>,<probability>,<space>,<times>
+	fail_make_request=
+	fail_mmc_request=<interval>,<probability>,<space>,<times>
 
 How to add new fault injection capability
 -----------------------------------------
-- 
1.6.3.3

