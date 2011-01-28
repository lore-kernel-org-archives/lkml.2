Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1A1EFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:19 -0500
Received: from mail.perches.com ([173.55.12.10]:3458 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab1A1EEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:55 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] staging: ath6kl: Convert A_NETBUF_QUEUE_EMPTY to return TRUE or FALSE
Date: Thu, 27 Jan 2011 20:04:30 -0800
Message-Id: <df0541518c4f42e84115b10e3888b317c5e07faa.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the return an A_BOOL not int.

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index a1dd024..cdbda89 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -247,7 +247,7 @@ typedef struct sk_buff_head A_NETBUF_QUEUE_T;
 #define A_NETBUF_QUEUE_SIZE(q)  \
     a_netbuf_queue_size(q)
 #define A_NETBUF_QUEUE_EMPTY(q) \
-    a_netbuf_queue_empty(q)
+    (a_netbuf_queue_empty(q) ? TRUE : FALSE)
 
 /*
  * Network buffer support
-- 
1.7.4.rc3

