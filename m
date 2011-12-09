Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1LIEWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:22:55 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:42565 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753719Ab1LIEWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:22:52 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH v3.2 06/10] MAINTAINERS: Update mfd F: patterns
Date: Thu,  8 Dec 2011 20:21:44 -0800
Message-Id: <754158ba88821fa37f89f55695ae47b1a06f2647.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8959e74399c ("mfd: Delete ab3550 driver")
removed the driver, update the patterns.

CC: Linus Walleij <linus.walleij@stericsson.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d98e5e..96c354c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1181,7 +1181,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ux500/
 F:	drivers/dma/ste_dma40*
-F:	drivers/mfd/ab3550*
 F:	drivers/mfd/abx500*
 F:	drivers/mfd/ab8500*
 F:	drivers/mfd/stmpe*
-- 
1.7.8.111.gad25c.dirty

