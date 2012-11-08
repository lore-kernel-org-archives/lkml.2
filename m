Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2KHQvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:51:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:41225 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752404Ab2KHQvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:51:03 -0500
Message-Id: <39ad803c969bc47fece5000c955b9894a24d09a9.1352316179.git.ecashin@coraid.com>
In-Reply-To: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 8/8] aoe: update driver-internal version to 64+
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 11:50:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index c253cca..9655ce3 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,6 @@
+
 /* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "60"
+#define VERSION "64+"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.7.1

