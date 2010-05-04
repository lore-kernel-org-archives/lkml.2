Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0EDUAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:00:46 -0400
Received: from [69.28.251.93] ([69.28.251.93]:44851 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933575Ab0EDUAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:00:45 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 4 May 2010 12:51:34 -0700
Subject: [PATCH] mtd: map.h: add missing bug.h include
Message-Id: <bef290de42df7fe0112febe9f92fd5dc3be2890d@localhost.localdomain>
To: <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 include/linux/mtd/map.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index b981b87..01703d4 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/string.h>
+#include <linux/bug.h>
 
 #include <linux/mtd/compatmac.h>
 
-- 
1.6.3.1

