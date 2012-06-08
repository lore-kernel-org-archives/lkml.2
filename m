Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab2FHUtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:49:24 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:4162 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab2FHUtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:49:22 -0400
Message-ID: <1339188557.30984.10.camel@x61.thuisdomein>
Subject: [PATCH] sh: Kill off last dead UBC header
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 22:49:17 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 20:49:17.0697 (UTC) FILETIME=[2BEE9F10:01CD45B8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7025bec9125b0a02edcaf22c2dce753bf2c95480 ("sh: Kill off dead UBC
headers.") skipped arch/sh/include/cpu-sh2a/cpu/ubc.h. Since nothing is
using that header either, kill it off too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only. Seems obviously correct anyway.

 arch/sh/include/cpu-sh2a/cpu/ubc.h |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)
 delete mode 100644 arch/sh/include/cpu-sh2a/cpu/ubc.h

diff --git a/arch/sh/include/cpu-sh2a/cpu/ubc.h b/arch/sh/include/cpu-sh2a/cpu/ubc.h
deleted file mode 100644
index 1192e1c..0000000
--- a/arch/sh/include/cpu-sh2a/cpu/ubc.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * SH-2A UBC definitions
- *
- * Copyright (C) 2008 Kieran Bingham
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef __ASM_CPU_SH2A_UBC_H
-#define __ASM_CPU_SH2A_UBC_H
-
-#define UBC_BARA                0xfffc0400
-#define UBC_BAMRA               0xfffc0404
-#define UBC_BBRA                0xfffc04a0	/* 16 bit access */
-#define UBC_BDRA                0xfffc0408
-#define UBC_BDMRA               0xfffc040c
-
-#define UBC_BARB                0xfffc0410
-#define UBC_BAMRB               0xfffc0414
-#define UBC_BBRB                0xfffc04b0	/* 16 bit access */
-#define UBC_BDRB                0xfffc0418
-#define UBC_BDMRB               0xfffc041c
-
-#define UBC_BRCR                0xfffc04c0
-
-#endif /* __ASM_CPU_SH2A_UBC_H */
-- 
1.7.7.6

