Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1KWLZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:25:45 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:39315 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1KWLZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:25:44 -0500
Message-ID: <1322047542.1753.63.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] leds: Kconfig: Fix typo 'D2NET_V2'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 12:25:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This typo was added in the commit 84712e9aa4 ("[ARM] Kirkwood: add LaCie
d2 Network v2 support"), ie the commit that added support for
MACH_D2NET_V2.

 drivers/leds/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..1b75a56 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -347,7 +347,8 @@ config LEDS_MC13783
 config LEDS_NS2
 	tristate "LED support for Network Space v2 GPIO LEDs"
 	depends on LEDS_CLASS
-	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || MACH_NETSPACE_MAX_V2 || D2NET_V2
+	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || \
+		   MACH_NETSPACE_MAX_V2 || MACH_D2NET_V2
 	default y
 	help
 	  This option enable support for the dual-GPIO LED found on the
-- 
1.7.7.3

