Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0HXTaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:30:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1316 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0HXTaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:30:14 -0400
Subject: [PATCH net-next] include/linux/if_ether.h: Remove unused #define
 MAC_FMT
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 12:30:11 -0700
Message-ID: <1282678211.25208.1.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last use was removed, so remove the #define.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/if_ether.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index bed7a46..f9c3df0 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -137,8 +137,6 @@ extern struct ctl_table ether_table[];
 
 extern ssize_t sysfs_format_mac(char *buf, const unsigned char *addr, int len);
 
-#define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
-
 #endif
 
 #endif	/* _LINUX_IF_ETHER_H */


