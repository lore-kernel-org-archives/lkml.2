Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0CVVTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:19:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45954 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab0CVVTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:19:33 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de
Cc: alan@lxorguk.ukuu.org.uk, pavan_savoy@ti.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] serial: TTY: new ldisc for TI BT/FM/GPS chips
Date: Mon, 22 Mar 2010 16:19:11 -0500
Message-Id: <1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

A new N_TI_SHARED line discipline added for TI BT/FM/GPS
combo chips which make use of same TTY to communicate
with chip. This is to be made use of individual protocol
BT/FM/GPS drivers.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 include/linux/tty.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4409967..3eda091 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -23,7 +23,7 @@
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		20
+#define NR_LDISCS		21
 
 /* line disciplines */
 #define N_TTY		0
@@ -48,6 +48,7 @@
 #define N_PPS		18	/* Pulse per Second */
 
 #define N_V253		19	/* Codec control over voice modem */
+#define N_TI_SHARED	20	/* for TI's WL7 connectivity chips */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.5.4.3

