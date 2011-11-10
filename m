Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab1KJJms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:42:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37476 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934054Ab1KJJmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:42:25 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] linkage: Remove unused NORET_AND macro
Date: Thu, 10 Nov 2011 01:41:43 -0800
Message-Id: <68cd1a5ecd75b0b77b81a20f23cb5dc3992b7922.1320917556.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1320917551.git.joe@perches.com>
References: <cover.1320917551.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only use in kernel.h is gone so remove the macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/linkage.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 3f46aed..c75074c 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -90,6 +90,5 @@
 
 #define NORET_TYPE    /**/
 #define ATTRIB_NORET  __attribute__((noreturn))
-#define NORET_AND     noreturn,
 
 #endif
-- 
1.7.6.405.gc1be0

