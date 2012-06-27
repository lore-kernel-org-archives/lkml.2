Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab2F0QAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:00:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47840 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab2F0P6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:15 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 06/16] UBI: Fastmap: Address another TODO
Date: Wed, 27 Jun 2012 17:57:46 +0200
Message-Id: <1340812676-14460-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index c2434cd..4d8ef9e 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -797,13 +797,6 @@ out:
  * @ubi: UBI device object
  * @ai: UBI attach info to be filled
  *
- * TODO: not urgent, but at some point - check the code with kernel doc and fix
- * its complaints.
- *
- * TODO: not urgent, but for consistency, follow the UBI/UBIFS style and put a
- * dot at the end of the first short description sentence (globally):
- *    ubi_scan_fastmap - scan the fastmap. (<-dot).
- *
  * TODO: not urgent, but it is desireble to document error codes in the header
  * comments and probably describe what the function does, if there is something
  * to say (globally).
-- 
1.7.6.5

