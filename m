Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1JNM3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:29:31 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58215 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab1JNM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:29:30 -0400
Subject: [PATCH 08/21] m32r: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:28:31 +0200
Message-ID: <1318595311.6132.65.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/m32r/Kconfig |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index b92b944..0e0b312 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -322,13 +322,6 @@ config NODES_SHIFT
 	default "1"
 	depends on NEED_MULTIPLE_NODES
 
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
-config BOOT_IOREMAP
-	bool
-	depends on NUMA
-	default n
-
 endmenu
 

-- 
1.7.4.4




