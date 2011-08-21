Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1HUK5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 06:57:36 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:53451 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab1HUK5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 06:57:22 -0400
From: Rolf Eike Beer <eike@sf-mail.de>
To: linux-kernel@vger.kernel.org
Subject: [Doc] class_find_device: fix reference to argument "match"
Date: Sun, 21 Aug 2011 12:56:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.1-40-desktop; KDE/4.6.4; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108211256.43836.eike@sf-mail.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/base/class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 4f1df2e..5bd577b 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -403,7 +403,7 @@ EXPORT_SYMBOL_GPL(class_for_each_device);
  *
  * Note, you will need to drop the reference with put_device() after use.
  *
- * @fn is allowed to do anything including calling back into class
+ * @match is allowed to do anything including calling back into class
  * code.  There's no locking restriction.
  */
 struct device *class_find_device(struct class *class, struct device *start,
-- 
1.7.6

