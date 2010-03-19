Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0CSB3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:29:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1848 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0CSB3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:29:44 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: [PATCH v3 1/9] include/linux/wireless.h: Add IW_HANDLER macro to initialize array entry
Date: Thu, 18 Mar 2010 18:29:32 -0700
Message-Id: <278cd636841ab997e0f6956abcfad715a8e58895.1268961559.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1268961559.git.joe@perches.com>
References: <cover.1268961559.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copied the idea from orinoco

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/wireless.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 5b4c6c7..0955b67 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -346,6 +346,8 @@
 #define SIOCIWFIRST	0x8B00
 #define SIOCIWLAST	SIOCIWLASTPRIV		/* 0x8BFF */
 #define IW_IOCTL_IDX(cmd)	((cmd) - SIOCIWFIRST)
+#define IW_HANDLER(id, func)			\
+	[IW_IOCTL_IDX(id)] = func
 
 /* Odd : get (world access), even : set (root access) */
 #define IW_IS_SET(cmd)	(!((cmd) & 0x1))
-- 
1.7.0.14.g7e948

