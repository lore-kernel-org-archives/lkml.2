Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1KAAYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:24:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab1KAAR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:17:29 -0400
Message-Id: <093448$3uejrh@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599665"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:37:20 -0500
Subject: [PATCH v5 08/36] Hexagon: Add delay functions
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/delay.h |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/delay.h

diff --git a/arch/hexagon/include/asm/delay.h b/arch/hexagon/include/asm/delay.h
new file mode 100644
index 0000000..9ab12e9
--- /dev/null
+++ b/arch/hexagon/include/asm/delay.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
+
+#include <asm/param.h>
+
+extern void __udelay(unsigned long usecs);
+
+#define udelay(usecs) __udelay((usecs))
+
+#endif /* _ASM_DELAY_H */
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
