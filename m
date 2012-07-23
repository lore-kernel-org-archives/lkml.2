Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2GWSxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:53:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34601 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751123Ab2GWSxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:53:31 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19zY1o8p/9zOw6+3AutWBqZ/ic8a6rdV+p5wuR+wJ
	y4z8T80WC2tMpM
To: dl9pf@gmx.de, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Trivial: Fix typo in include/linux/clk.h .
From: "Jan-Simon =?utf-8?q?M=C3=B6ller?=" <dl9pf@gmx.de>
Date: Mon, 23 Jul 2012 20:48:56 +0200
Cc: linux@arm.linux.org.uk
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207232048.56672.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <jansimon.moeller@gmx.de>

Signed-off-by: Jan-Simon Möller <jansimon.moeller@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/clk.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index f7bd858..116172f 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -123,7 +123,7 @@ static inline void clk_unprepare(struct clk *clk)
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
- * @id: clock comsumer ID
+ * @id: clock consumer ID
  *
  * Returns a struct clk corresponding to the clock producer, or
  * valid IS_ERR() condition containing errno.  The implementation
@@ -140,7 +140,7 @@ struct clk *clk_get(struct device *dev, const char *id);
 /**
  * devm_clk_get - lookup and obtain a managed reference to a clock producer.
  * @dev: device for clock "consumer"
- * @id: clock comsumer ID
+ * @id: clock consumer ID
  *
  * Returns a struct clk corresponding to the clock producer, or
  * valid IS_ERR() condition containing errno.  The implementation
-- 
1.7.3.4

