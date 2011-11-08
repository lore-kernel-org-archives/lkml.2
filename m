Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1KHP4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:56:17 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:39899 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1KHP4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:56:16 -0500
Subject: [PATCH] [TRIVIAL] Blackfin: remove bfin_simple_timer.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:56:11 +0100
Message-ID: <1320767771.14409.389.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it was introduced in commit 1394f03221 ("blackfin architecture"),
bfin_simple_timer.h has always been unused: no file includes it and
(unsurprisingly) the macros it defines are never used.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested (I don't have the Blackfin toolchain at hand).

 arch/blackfin/include/asm/bfin_simple_timer.h |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/bfin_simple_timer.h

diff --git a/arch/blackfin/include/asm/bfin_simple_timer.h b/arch/blackfin/include/asm/bfin_simple_timer.h
deleted file mode 100644
index 5248c13..0000000
--- a/arch/blackfin/include/asm/bfin_simple_timer.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright 2006-2008 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
- */
-
-#ifndef _bfin_simple_timer_h_
-#define _bfin_simple_timer_h_
-
-#include <linux/ioctl.h>
-
-#define BFIN_SIMPLE_TIMER_IOCTL_MAGIC 't'
-
-#define BFIN_SIMPLE_TIMER_SET_PERIOD _IO (BFIN_SIMPLE_TIMER_IOCTL_MAGIC,  2)
-#define BFIN_SIMPLE_TIMER_START      _IO (BFIN_SIMPLE_TIMER_IOCTL_MAGIC,  6)
-#define BFIN_SIMPLE_TIMER_STOP       _IO (BFIN_SIMPLE_TIMER_IOCTL_MAGIC,  8)
-#define BFIN_SIMPLE_TIMER_READ       _IO (BFIN_SIMPLE_TIMER_IOCTL_MAGIC, 10)
-
-#endif
-- 
1.7.4.4

