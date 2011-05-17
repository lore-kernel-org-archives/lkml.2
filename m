Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1EQWLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:11:43 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60364
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932415Ab1EQWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:11:42 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Connector: Set the CN_NETLINK_USERS correctly
Date: Tue, 17 May 2011 15:25:37 -0700
Message-Id: <1305671138-19443-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CN_NETLINK_USERS must be set to the highest valid index +1.
Thanks to Evgeniy for pointing this out.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 include/linux/connector.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/connector.h b/include/linux/connector.h
index 7c60d09..f696bcc 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -44,7 +44,7 @@
 #define CN_VAL_DRBD			0x1
 #define CN_KVP_IDX			0x9	/* HyperV KVP */
 
-#define CN_NETLINK_USERS		9
+#define CN_NETLINK_USERS		10	/* Highest index + 1 */
 
 /*
  * Maximum connector's message size.
-- 
1.7.4.1

