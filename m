Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0FGSus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:50:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2726 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0FGSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 14/17] MAINTAINERS: Add STAGING - VIA VT665X DRIVERS
Date: Mon,  7 Jun 2010 11:49:48 -0700
Message-Id: <d8689ddb4e22fabe7308e12d4e4e1cc58490d3c2.1275935091.git.joe@perches.com>
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
index ada25ae..b0605c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5522,6 +5522,11 @@ M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
 F:	drivers/staging/sm7xx/
 
+STAGING - VIA VT665X DRIVERS
+M:	Forest Bond <forest@alittletooquiet.net>
+S:	Odd Fixes
+F:	drivers/staging/vt665?/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

