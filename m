Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1FCJ3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:29:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2466 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1FCJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:29:30 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 3/5] aix94xx: Use angle brackets for system includes
Date: Fri,  3 Jun 2011 02:28:48 -0700
Message-Id: <44c272d56fab3f621c093aef14dd6a3886ed1ea7.1307092589.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1307092588.git.joe@perches.com>
References: <cover.1307092588.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal include style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aic94xx/aic94xx_dump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 67eeba3..a16a77c 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -29,7 +29,7 @@
  *
  */
 
-#include "linux/pci.h"
+#include <linux/pci.h>
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
 #include "aic94xx_reg_def.h"
-- 
1.7.5.rc3.dirty

