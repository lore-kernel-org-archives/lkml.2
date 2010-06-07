Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0FGSvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:51:18 -0400
Received: from mail.perches.com ([173.55.12.10]:2725 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0FGSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:50:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Teddy Wang <teddy.wang@siliconmotion.com.cn>
Subject: [PATCH 13/17] MAINTAINERS: Add STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
Date: Mon,  7 Jun 2010 11:49:47 -0700
Message-Id: <731775bff4188da59b7217d785d81e57cc910b22.1275935091.git.joe@perches.com>
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
index 33679ab..ada25ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5517,6 +5517,11 @@ M:	Willy Tarreau <willy@meta-x.org>
 S:	Odd Fixes
 F:	drivers/staging/panel/
 
+STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
+M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
+S:	Odd Fixes
+F:	drivers/staging/sm7xx/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4

