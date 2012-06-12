Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2FLKhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:37:46 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:1290 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779Ab2FLKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:37:45 -0400
Message-ID: <1339497459.30984.118.camel@x61.thuisdomein>
Subject: [PATCH] ARM: remove old SA-1111.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Jun 2012 12:37:39 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 12 Jun 2012 10:37:39.0646 (UTC) FILETIME=[63D76DE0:01CD4887]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All (in tree) users of old mach/SA-1111.h were already updated to
include asm/hardware/sa1111.h in v2.6.12-rc2. The old header can safely
be removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only by "git grepping" the (history of) the tree.

 arch/arm/mach-sa1100/include/mach/SA-1111.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)
 delete mode 100644 arch/arm/mach-sa1100/include/mach/SA-1111.h

diff --git a/arch/arm/mach-sa1100/include/mach/SA-1111.h b/arch/arm/mach-sa1100/include/mach/SA-1111.h
deleted file mode 100644
index c38f609..0000000
--- a/arch/arm/mach-sa1100/include/mach/SA-1111.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/*
- * Moved to new location
- */
-#warning using old SA-1111.h - update to <asm/hardware/sa1111.h>
-#include <asm/hardware/sa1111.h>
-- 
1.7.7.6

