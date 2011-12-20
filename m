Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1LTHSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:18:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63555 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1LTHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:17:54 -0500
Message-ID: <1324365465.9836.1.camel@phoenix>
Subject: [PATCH] devres: Fix a typo in devm_kfree comment
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Date: Tue, 20 Dec 2011 15:17:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/base/devres.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 65cd748..524bf96 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -639,7 +639,7 @@ EXPORT_SYMBOL_GPL(devm_kzalloc);
  * @dev: Device this memory belongs to
  * @p: Memory to free
  *
- * Free memory allocated with dev_kzalloc().
+ * Free memory allocated with devm_kzalloc().
  */
 void devm_kfree(struct device *dev, void *p)
 {
-- 
1.7.5.4



