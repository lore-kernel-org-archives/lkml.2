Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2B0SyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:54:02 -0500
Received: from que11.charter.net ([209.225.8.21]:61295 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2B0SyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:54:00 -0500
X-Authority-Analysis: v=1.1 cv=JYQIUidRAECiNa+jsiaNMIhYElg3H2WoMKCJIGO75f4=
 c=1 sm=1 a=k7e4s-J0mtkA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=A9V0xx8wijEQ5X3AB2YA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: sgruszka@redhat.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 2/4] iwlegacy: Kconfig: Change Debug Option to be more clear
Date: Mon, 27 Feb 2012 12:25:31 -0600
Message-Id: <1330367133-26465-3-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1330367133-26465-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the menuconfig system doesn't indent the debug options
for the 3945 /4965, add some text to make it clear which
debug options are being configured.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlegacy/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index 4d81b80..fb91972 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -60,7 +60,7 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.
 
-menu "Debugging Options"
+menu "iwl3945 / iwl4965 Debugging Options"
 	depends on IWLEGACY
 
 config IWLEGACY_DEBUG
-- 
1.7.6.4

