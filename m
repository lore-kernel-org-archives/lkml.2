Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2EGJPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:15:06 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:3443 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab2EGJPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:15:05 -0400
Message-ID: <1336382099.1933.21.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Kconfig: replace "--- help ---" with "---help---"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 11:14:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 May 2012 09:14:58.0945 (UTC) FILETIME=[E0298710:01CD2C31]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three Kconfig entries with "--- help ---" attributes, and over
2000 Kconfig entries with "---help---" attributes.  Apparently the three
attributes with embedded spaces are valid. Still, I see little reason
for using this obscure variant. And replacing those three attributes
with the common variant makes grepping Kconfig files for help texts a
bit easier too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/usb/host/Kconfig |    2 +-
 drivers/w1/Kconfig       |    2 +-
 net/caif/Kconfig         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index f788eb8..e96c4b9 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -152,7 +152,7 @@ config USB_EHCI_HCD_OMAP
 	bool "EHCI support for OMAP3 and later chips"
 	depends on USB_EHCI_HCD && ARCH_OMAP
 	default y
-	--- help ---
+	---help---
 	  Enables support for the on-chip EHCI controller on
 	  OMAP3 and later chips.
 
diff --git a/drivers/w1/Kconfig b/drivers/w1/Kconfig
index fd2c7bd..6743bde 100644
--- a/drivers/w1/Kconfig
+++ b/drivers/w1/Kconfig
@@ -16,7 +16,7 @@ config W1_CON
 	depends on CONNECTOR
 	bool "Userspace communication over connector"
 	default y
-	--- help ---
+	---help---
 	  This allows to communicate with userspace using connector. For more
 	  information see <file:Documentation/connector/connector.txt>.
 	  There are three types of messages between w1 core and userspace:
diff --git a/net/caif/Kconfig b/net/caif/Kconfig
index 936361e..d369495 100644
--- a/net/caif/Kconfig
+++ b/net/caif/Kconfig
@@ -25,7 +25,7 @@ config  CAIF_DEBUG
 	bool "Enable Debug"
 	depends on CAIF
 	default n
-	--- help ---
+	---help---
 	Enable the inclusion of debug code in the CAIF stack.
 	Be aware that doing this will impact performance.
 	If unsure say N.
-- 
1.7.7.6



