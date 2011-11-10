Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219Ab1KJJnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:43:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43059 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934133Ab1KJJnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:43:21 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] linkage: Remove unused ATTRIB_NORET macro
Date: Thu, 10 Nov 2011 01:41:46 -0800
Message-Id: <67addf036e1cfeb85996f9abd7658e902419acba.1320917558.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1320917551.git.joe@perches.com>
References: <cover.1320917551.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses have been renamed so delete the unused macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/linkage.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 6a8f252..807f1e5 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -88,6 +88,4 @@
 
 #endif
 
-#define ATTRIB_NORET  __attribute__((noreturn))
-
 #endif
-- 
1.7.6.405.gc1be0

