Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab2LDBxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:53:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:44705 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260Ab2LDBxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:53:02 -0500
Message-Id: <46f3ff7466aac9b5dfdb7d1d8d6b858a8a3b23b7.1354501189.git.ecashin@coraid.com>
In-Reply-To: <cover.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 7/7] aoe: update internal version number to 81
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 3 Dec 2012 20:53:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version number is printed to the console on module
initialization and is available in sysfs, which is where the
userland aoe-version tool looks for it.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index f8d6c7e..1756494 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,6 +1,5 @@
-
 /* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "64+"
+#define VERSION "81"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.7.1

