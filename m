Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3ADI3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:29:35 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45787 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3ADI3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:29:33 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: chris@zankel.net, jcmvbkbc@gmail.com, trivial@kernel.org,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH][trivial] xtensa: Fix home page URL in Kconfig
Date: Fri,  4 Jan 2013 17:29:18 +0900
Message-Id: <1357288158-29654-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This home page address has moved to new one.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/xtensa/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 0d1f36a..75fb260 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -22,7 +22,7 @@ config XTENSA
 	  configurable and extensible.  The Linux port to the Xtensa
 	  architecture supports all processor configurations and extensions,
 	  with reasonable minimum requirements.  The Xtensa Linux project has
-	  a home page at <http://xtensa.sourceforge.net/>.
+	  a home page at <http://www.linux-xtensa.org/>.
 
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
-- 
1.8.1

