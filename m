Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2HQO6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:58:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62041 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2HQO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:57:40 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/4] sync include/mtd/ubi-user.h: DROP CONFIG_MTD_UBI_BEB_LIMIT
Date: Fri, 17 Aug 2012 16:57:21 +0200
Message-Id: <1345215442-19082-4-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
References: <1345215442-19082-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 include/mtd/ubi-user.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 32771cf..44720d3 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -259,8 +259,8 @@ enum {
  * If the device has more bad eraseblocks than this limit, UBI does not reserve
  * any physical eraseblocks for new bad eraseblocks, but attempts to use
  * available eraseblocks (if any).
- * The accepted range is 0-255. If 0 is given, the default kernel config value
- * CONFIG_MTD_UBI_BEB_LIMIT will be used for compatibility.
+ * The accepted range is 0-255. If 0 is given, the default value
+ * MTD_UBI_DEFAULT_BEB_LIMIT will be used for compatibility.
  */
 struct ubi_attach_req {
 	__s32 ubi_num;
-- 
1.7.2.5

