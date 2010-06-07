Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0FGSt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:49:56 -0400
Received: from mail.perches.com ([173.55.12.10]:2659 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0FGStz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:49:55 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Jakub Schmidtke <sjakub@gmail.com>
Subject: [PATCH 01/17] MAINTAINERS: Add STAGING - ASUS OLED
Date: Mon,  7 Jun 2010 11:49:35 -0700
Message-Id: <9300a59943c63bb11e98b0fcd1b42906a632e321.1275935090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275935090.git.joe@perches.com>
References: <cover.1275935090.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cb181a..004c343 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5448,6 +5448,11 @@ L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 
+STAGING - ASUS OLED
+M:	Jakub Schmidtke <sjakub@gmail.com>
+S:	Odd Fixes
+F:	drivers/staging/asus_oled/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

