Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0CYXUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:20:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58837 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab0CYXUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:20:40 -0400
From: pavan_savoy@ti.com
To: marcel@holtmann.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in,
       Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] serial: TTY: new ldiscs for staging
Date: Thu, 25 Mar 2010 18:20:16 -0500
Message-Id: <1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Push the max ldiscs by a few number to allow ldiscs
to exist in the staging directory

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 include/linux/tty.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4409967..227c0a8 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -23,7 +23,7 @@
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
-#define NR_LDISCS		20
+#define NR_LDISCS		25	/* add few ldiscs for staging */
 
 /* line disciplines */
 #define N_TTY		0
-- 
1.5.4.3

