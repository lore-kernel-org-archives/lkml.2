Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0LFWHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:42 -0500
Received: from mail.perches.com ([173.55.12.10]:2351 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/29] include/linux/device.h: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:11 -0800
Message-Id: <68da45054628c4e6b4ce77b52b73ae4bad87dde9.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro argument neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/device.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 1e2d335..129cc25 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -743,7 +743,7 @@ do {						     \
  * file/line information and a backtrace.
  */
 #define dev_WARN(dev, format, arg...) \
-	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ## arg);
+	WARN(1, "Device: %s\n" format, dev_driver_string(dev), ##arg);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
-- 
1.7.3.2.245.g03276.dirty

