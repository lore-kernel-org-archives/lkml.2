Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2JPB4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:56:52 -0400
Received: from noserose.net ([66.220.18.76]:42986 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752619Ab2JPB4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:56:50 -0400
Date: Mon, 15 Oct 2012 18:56:44 -0700
Message-Id: <626e559d4795c200ebd8c170cfcf98a966fa5185.1350331035.git.ecashin@coraid.com>
In-Reply-To: <cover.1350331035.git.ecashin@coraid.com>
References: <cover.1350331035.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 9/9] aoe: update driver-internal version number to 60
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 8e8da1c..536942b 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "50"
+#define VERSION "60"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.7.1

