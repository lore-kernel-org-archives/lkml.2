Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2LEQWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:22:54 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51591 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2LEQJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 07/44] metag: Add MAINTAINERS entry
Date: Wed, 5 Dec 2012 16:08:25 +0000
Message-ID: <1354723742-6195-8-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry for the metag architecture port. Will and myself
will be maintaining it between us.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Will Newton <will.newton@imgtec.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9386a63..b2b64ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4849,6 +4849,14 @@ F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/mtd/
 
+METAG ARCHITECTURE
+M:	James Hogan <james.hogan@imgtec.com>
+M:	Will Newton <will.newton@imgtec.com>
+S:	Maintained
+F:	arch/metag/
+F:	Documentation/metag/
+F:	Documentation/devicetree/bindings/metag/
+
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
 L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
-- 
1.7.7.6


