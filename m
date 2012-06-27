Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2F0P65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:58:57 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47848 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab2F0P6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:22 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 13/16] UBI: Fastmap: Remove one point from TODO list
Date: Wed, 27 Jun 2012 17:57:53 +0200
Message-Id: <1340812676-14460-14-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastmap works fine with ro mtd devices.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 TODO |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/TODO b/TODO
index a944159..b1ae872 100644
--- a/TODO
+++ b/TODO
@@ -4,7 +4,6 @@ it is merged.
 For all or most of the items there we need to write a testcase. We can put it
 to the ubi-utils.git repository, to a separate branch at the beginning
 
-1. Test with a R/O MTD device: !(mtd->flags & MTD_WRITEABLE)
 2. Implement power-cut emulation infrastructure similar to what is in UBIFS and
    test UBI + fastmap with it.
 3. Test the autoresize feature
-- 
1.7.6.5

