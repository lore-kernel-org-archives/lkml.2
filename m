Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0FSFJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:09:44 -0400
Received: from smtp-out-037.synserver.de ([212.40.180.37]:1031 "HELO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753725Ab0FSFJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:09:42 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13414
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 07/26] MIPS: JZ4740: Add setup code
Date: Sat, 19 Jun 2010 07:08:12 +0200
Message-Id: <1276924111-11158-8-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1276924111-11158-1-git-send-email-lars@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds plat_mem_setup and get_system_type for JZ4740 SoCs.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/setup.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/jz4740/setup.c

diff --git a/arch/mips/jz4740/setup.c b/arch/mips/jz4740/setup.c
new file mode 100644
index 0000000..6a9e14d
--- /dev/null
+++ b/arch/mips/jz4740/setup.c
@@ -0,0 +1,29 @@
+/*
+ *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  JZ4740 setup code
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+
+#include "reset.h"
+
+void __init plat_mem_setup(void)
+{
+	jz4740_reset_init();
+}
+
+const char *get_system_type(void)
+{
+	return "JZ4740";
+}
-- 
1.5.6.5

