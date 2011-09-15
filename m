Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab1IOUNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:13:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:61479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934748Ab1IOUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873443"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, sameo@linux.intel.com
Subject: [PATCH 16/27] Initconst section fixes for mfd
Date: Thu, 15 Sep 2011 13:09:43 -0700
Message-Id: <1316117394-21666-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: sameo@linux.intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/mfd/ab3100-core.c |    2 +-
 drivers/mfd/ab3550-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index a20e1c4..4f57255 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -809,7 +809,7 @@ struct ab_family_id {
 	char	*name;
 };
 
-static const struct ab_family_id ids[] __devinitdata = {
+static const struct ab_family_id ids[] __devinitconst = {
 	/* AB3100 */
 	{
 		.id = 0xc0,
diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 56ba194..4c5aee3 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1193,7 +1193,7 @@ struct ab_family_id {
 	char	*name;
 };
 
-static const struct ab_family_id ids[] __initdata = {
+static const struct ab_family_id ids[] __initconst = {
 	/* AB3550 */
 	{
 		.id = AB3550_P1A,
-- 
1.7.4.4

