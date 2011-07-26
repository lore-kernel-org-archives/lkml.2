Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1GZUM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:12:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39571 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1GZUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:12:26 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4 3/3] fault injection: add documentation on MMC IO fault injection
Date: Tue, 26 Jul 2011 22:11:59 +0200
Message-Id: <1311711119-6286-4-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311711119-6286-1-git-send-email-per.forlin@linaro.org>
References: <1311711119-6286-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description on how to enable random fault injection
for MMC IO

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 Documentation/fault-injection/fault-injection.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index 7be15e4..27eede4 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -21,6 +21,11 @@ o fail_make_request
   /sys/block/<device>/make-it-fail or
   /sys/block/<device>/<partition>/make-it-fail. (generic_make_request())
 
+o fail_mmc_request
+
+  injects MMC data errors on devices permitted by setting
+  /sys/kernel/debug/mmc0/make-it-fail
+
 Configure fault-injection capabilities behavior
 -----------------------------------------------
 
-- 
1.7.4.1

