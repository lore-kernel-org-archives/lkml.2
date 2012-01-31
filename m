Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2AaDsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:48:33 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42775 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2AaDsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:48:32 -0500
Message-ID: <1327981698.2975.1.camel@phoenix>
Subject: [PATCH] regmap: Remove incorrect unreachable comment in
 regcache_set_val()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 31 Jan 2012 11:48:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache_set_val() returns false if cache[idx] != val.
Thus it actually is not unreachable.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/base/regmap/regcache.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d103401..77ce5ff 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -389,7 +389,6 @@ bool regcache_set_val(void *base, unsigned int idx,
 	default:
 		BUG();
 	}
-	/* unreachable */
 	return false;
 }
 
-- 
1.7.5.4



