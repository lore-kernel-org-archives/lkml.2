Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2FJJmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:42:18 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3646 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab2FJJmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:42:17 -0400
Message-ID: <1339321335.30984.29.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: Kill flatdevtree_env.h too
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Sun, 10 Jun 2012 11:42:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 10 Jun 2012 09:42:16.0049 (UTC) FILETIME=[51FF4610:01CD46ED]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 430b01e8f5e524a2bfa50074d97d0bdc2505807b ("[POWERPC] Kill
flatdevtree.c") killed the two files including flatdevtree_env.h. It was
apparently just an oversight to not kill that header too. Kill it now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

 arch/powerpc/boot/flatdevtree_env.h |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)
 delete mode 100644 arch/powerpc/boot/flatdevtree_env.h

diff --git a/arch/powerpc/boot/flatdevtree_env.h b/arch/powerpc/boot/flatdevtree_env.h
deleted file mode 100644
index 66e0ebb..0000000
--- a/arch/powerpc/boot/flatdevtree_env.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * This file adds the header file glue so that the shared files
- * flatdevicetree.[ch] can compile and work in the powerpc bootwrapper.
- *
- * strncmp & strchr copied from <file:lib/string.c>
- * Copyright (C) 1991, 1992  Linus Torvalds
- *
- * Maintained by: Mark A. Greer <mgreer@mvista.com>
- */
-#ifndef _PPC_BOOT_FLATDEVTREE_ENV_H_
-#define _PPC_BOOT_FLATDEVTREE_ENV_H_
-
-#include <stdarg.h>
-#include <stddef.h>
-#include "types.h"
-#include "string.h"
-#include "stdio.h"
-#include "ops.h"
-
-#define be16_to_cpu(x)		(x)
-#define cpu_to_be16(x)		(x)
-#define be32_to_cpu(x)		(x)
-#define cpu_to_be32(x)		(x)
-#define be64_to_cpu(x)		(x)
-#define cpu_to_be64(x)		(x)
-
-#endif /* _PPC_BOOT_FLATDEVTREE_ENV_H_ */
-- 
1.7.7.6

