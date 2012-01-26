Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2AZOqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:46:17 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37441
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751991Ab2AZOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:46:15 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] pci: Fix typo in setup-res.c
Date: Thu, 26 Jan 2012 23:45:47 +0900
Message-Id: <1327589147-2193-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "resouce" to "resource" in
dricers/pci/setup-res.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/pci/setup-res.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index b66bfdb..5c18194 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -228,7 +228,7 @@ int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsiz
 	int ret;
 
 	if (!res->parent) {
-		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resouce %pR "
+		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resource %pR "
 			 "\n", resno, res);
 		return -EINVAL;
 	}
-- 
1.7.6.5

