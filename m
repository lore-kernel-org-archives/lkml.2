Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1JLMZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:25:34 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44541 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1JLMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:25:33 -0400
Subject: [PATCH] [TRIVIAL] h8300: drop puzzling Kconfig dependencies
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 14:25:31 +0200
Message-ID: <1318422331.2336.14.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were probably just copied and pasted from drivers/tty/Kconfig.
(Badly, since the symbol UM doesn't exist.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/h8300/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 091ed61..7ed7714 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -160,7 +160,7 @@ config VT_CONSOLE
 
 config HW_CONSOLE
 	bool
-	depends on VT && !S390 && !UM
+	depends on VT
 	default y
 
 comment "Unix98 PTY support"
-- 
1.7.4.4



