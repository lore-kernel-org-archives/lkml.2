Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2DZQS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:18:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39742 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab2DZQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:18:58 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: add kerneldoc for pinctrl_ops device tree functions
Date: Thu, 26 Apr 2012 10:18:52 -0600
Message-Id: <1335457132-6699-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/pinctrl/pinctrl.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index c22d040..3b894a6 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -72,6 +72,15 @@ struct pinctrl_gpio_range {
  *	group selector @pins, and the size of the array in @num_pins
  * @pin_dbg_show: optional debugfs display hook that will provide per-device
  *	info for a certain pin in debugfs
+ * @dt_node_to_map: parse a device tree "pin configuration node", and create
+ *	mapping table entries for it. These are returned through the @map and
+ *	@num_maps output parameters. This function is optional, and may be
+ *	omitted for pinctrl drivers that do not support device tree.
+ * @dt_free_map: free mapping table entries created via @dt_node_to_map. The
+ *	top-level @map pointer must be freed, along with any dynamically
+ *	allocated members of the mapping table entries themselves. This
+ *	function is optional, and may be omitted for pinctrl drivers that do
+ *	not support device tree.
  */
 struct pinctrl_ops {
 	int (*get_groups_count) (struct pinctrl_dev *pctldev);
-- 
1.7.0.4

