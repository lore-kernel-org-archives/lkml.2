Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab0C0C3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:29:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab0C0C2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:04 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
       Jie Yang <jie.yang@atheros.com>, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: [PATCH 6/9] drivers/net: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:55 -0700
Message-Id: <6b7a0c43891d5af5796b681898d901bbf2e1cda1.1269655208.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/atlx/atl1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 9ba5470..0ebd820 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -84,7 +84,7 @@
 
 #define ATLX_DRIVER_VERSION "2.1.3"
 MODULE_AUTHOR("Xiong Huang <xiong.huang@atheros.com>, \
-	Chris Snook <csnook@redhat.com>, Jay Cliburn <jcliburn@gmail.com>");
+Chris Snook <csnook@redhat.com>, Jay Cliburn <jcliburn@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ATLX_DRIVER_VERSION);
 
-- 
1.7.0.14.g7e948

