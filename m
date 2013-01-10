Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3AJPid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:38:33 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51611 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab3AJPcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:52 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v3 06/44] metag: Add MAINTAINERS entry
Date: Thu, 10 Jan 2013 15:30:34 +0000
Message-ID: <1357831872-29451-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry for the metag architecture port.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ae9f8b8..122ae6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5151,6 +5151,13 @@ F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/uapi/mtd/
 
+METAG ARCHITECTURE
+M:	James Hogan <james.hogan@imgtec.com>
+S:	Supported
+F:	arch/metag/
+F:	Documentation/metag/
+F:	Documentation/devicetree/bindings/metag/
+
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
 L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
-- 
1.7.7.6


