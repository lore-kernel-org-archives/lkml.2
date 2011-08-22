Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1HVDCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 23:02:42 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:46255 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab1HVDCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 23:02:40 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]lib:Kconfig.debug Typo remove extra "it"
Date: Sun, 21 Aug 2011 20:02:13 -0700
Message-Id: <1313982133-2084-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below removes an extra "it" in the comment.

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c0cb9c4..1b11409 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -835,7 +835,7 @@ config DEBUG_CREDENTIALS
 
 #
 # Select this config option from the architecture Kconfig, if it
-# it is preferred to always offer frame pointers as a config
+# is preferred to always offer frame pointers as a config
 # option on the architecture (regardless of KERNEL_DEBUG):
 #
 config ARCH_WANT_FRAME_POINTERS
-- 
1.7.6

