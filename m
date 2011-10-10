Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1JJL4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:56:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45076 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1JJLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:55:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 09/13] drbd: Remove unused GENLA_F_MAY_IGNORE flag
Date: Mon, 10 Oct 2011 13:55:02 +0200
Message-Id: <1318247706-7732-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
References: <1318247706-7732-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 include/linux/genl_magic_struct.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/genl_magic_struct.h b/include/linux/genl_magic_struct.h
index ba911da..f3c3425 100644
--- a/include/linux/genl_magic_struct.h
+++ b/include/linux/genl_magic_struct.h
@@ -40,11 +40,6 @@ extern void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void);
  * yet implemented features, if newer userland tries to use them even though
  * the genl_family version clearly indicates they are not available.
  *
- * @GENLA_F_MAY_IGNORE: To clearly document the fact, for good measure.
- * To be used for API extensions for things that have sane defaults,
- * so newer userland can still talk to older kernel, knowing it will
- * silently ignore these attributes if not yet known.
- *
  * NOTE: These flags overload
  *   NLA_F_NESTED		(1 << 15)
  *   NLA_F_NET_BYTEORDER	(1 << 14)
@@ -55,7 +50,6 @@ extern void CONCAT_(GENL_MAGIC_FAMILY, _genl_unregister)(void);
  * See also: nla_type()
  */
 enum {
-	GENLA_F_MAY_IGNORE	= 0,
 	GENLA_F_MANDATORY	= 1 << 14,
 	GENLA_F_REQUIRED	= 1 << 15,
 
-- 
1.7.4.1

