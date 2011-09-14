Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1INIr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:47:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32799 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1INIrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:47:25 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 3/3] fault-injection: update documentation with the mmc module param
Date: Wed, 14 Sep 2011 10:46:57 +0200
Message-Id: <1315990017-16912-4-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
References: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 Documentation/fault-injection/fault-injection.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index 70f924e..ba4be8b 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -121,7 +121,7 @@ use the boot option:
 	failslab=
 	fail_page_alloc=
 	fail_make_request=
-	fail_mmc_request=<interval>,<probability>,<space>,<times>
+	mmc_core.fail_request=<interval>,<probability>,<space>,<times>
 
 How to add new fault injection capability
 -----------------------------------------
-- 
1.7.4.1

