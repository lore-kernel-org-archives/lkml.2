Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2GJCsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:48:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38413 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2GJCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:47:34 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lauri.hintsala@bluegiga.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 3/5] staging: csr: netdev.c: Remove unused macros
Date: Mon,  9 Jul 2012 23:43:11 -0300
Message-Id: <1341888193-12182-4-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros are not used, so we can remove it.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/csr/netdev.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index cf19f11..55149df 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -70,11 +70,6 @@
  */
 #define ALLOW_Q_PAUSE
 
-#define ieee2host16(n)  __le16_to_cpu(n)
-#define ieee2host32(n)  __le32_to_cpu(n)
-#define host2ieee16(n)  __cpu_to_le16(n)
-#define host2ieee32(n)  __cpu_to_le32(n)
-
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
 #ifdef UNIFI_NET_NAME
 #define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
-- 
1.7.10.4

