Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2H1Nkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 09:40:36 -0400
Received: from noserose.net ([66.220.18.76]:35694 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751796Ab2H1Nkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 09:40:35 -0400
Message-Id: <42e4af1771ac8e76324cdcebf35439838e781841.1346158422.git.ecashin@coraid.com>
In-Reply-To: <cover.1346158422.git.ecashin@coraid.com>
References: <cover.1346158422.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Sat, 25 Aug 2012 10:39:56 -0400
Subject: [PATCH 12/14] aoe: update internal version number to 49
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal version number of the aoe driver appears in a console
message when the driver loads and is usually obtained by the user with
the userland aoe-version tool, part of the aoetools.[1]

Although this patchset includes bugfixes backported from
higher-numbered versions published on the coraid.com website, it is a
form of version 49.

1. http://aoetools.sourceforge.net/

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index eb41fc5..32aede9 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "47"
+#define VERSION "49"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.7.2.5

