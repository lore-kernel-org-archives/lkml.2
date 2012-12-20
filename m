Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2LTTM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:12:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20666 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2LTTM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:12:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kvm tools: remove unneeded check from disk code
Date: Thu, 20 Dec 2012 14:11:11 -0500
Message-Id: <1356030701-16284-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already know 'disk' is non-null.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/kvm/disk/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/disk/core.c b/tools/kvm/disk/core.c
index dd59751..4e9bda0 100644
--- a/tools/kvm/disk/core.c
+++ b/tools/kvm/disk/core.c
@@ -105,7 +105,7 @@ struct disk_image *disk_image__new(int fd, u64 size,
 	}
 
 #ifdef CONFIG_HAS_AIO
-	if (disk) {
+	{
 		pthread_t thread;
 
 		disk->evt = eventfd(0, 0);
-- 
1.8.0

