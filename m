Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab1LOX5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:57:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36425 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859Ab1LOX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:57:24 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] pinctrl: Add "struct seq_file;" to pinconf.h
Date: Thu, 15 Dec 2011 16:57:16 -0700
Message-Id: <1323993437-15149-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows one to include pinconf.h without having to include other
headers first.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/pinctrl/pinconf.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index d5b72e6..8c2c88e 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -15,6 +15,7 @@
 #ifdef CONFIG_PINCONF
 
 struct pinctrl_dev;
+struct seq_file;
 
 /**
  * struct pinconf_ops - pin config operations, to be implemented by
-- 
1.7.0.4

