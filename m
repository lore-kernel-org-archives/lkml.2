Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0FGSup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:45 -0400
Received: from mail.perches.com ([173.55.12.10]:2727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0FGSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:09 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Henk de Groot <pe1dnn@amsat.org>
Subject: [PATCH 16/17] MAINTAINERS: Add STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
Date: Mon,  7 Jun 2010 11:49:50 -0700
Message-Id: <4b487d578619417fadcd2c11f47396d66c8ceb01.1275935091.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 799d37a..bf83c28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5448,6 +5448,12 @@ L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 
+STAGING - AGERE HERMES II and II.5 WIRELESS DRIVERS
+M:	Henk de Groot <pe1dnn@amsat.org>
+S:	Odd Fixes
+F:	drivers/staging/wlags49_h2/
+F:	drivers/staging/wlags49_h25/
+
 STAGING - ASUS OLED
 M:	Jakub Schmidtke <sjakub@gmail.com>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

