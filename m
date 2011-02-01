Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab1BANsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:48:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19991 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab1BANsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:48:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6243"; a="72780239"
From: Anirudh Ghayal <aghayal@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Trilok Soni <tsoni@codeaurora.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [RFC v2 PATCH 1/7] matrix_keypad: Increase the max limit of rows and columns
Date: Tue,  1 Feb 2011 19:17:37 +0530
Message-Id: <1296568063-12010-2-git-send-email-aghayal@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trilok Soni <tsoni@codeaurora.org>

Some keyboard controller have support for more than
16 columns and rows. Moving this value to 32.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
---
Changes from v1:
Moved the max columns and rows to 32

 include/linux/input/matrix_keypad.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index 6974746..fe7c4b9 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -4,8 +4,8 @@
 #include <linux/types.h>
 #include <linux/input.h>
 
-#define MATRIX_MAX_ROWS		16
-#define MATRIX_MAX_COLS		16
+#define MATRIX_MAX_ROWS		32
+#define MATRIX_MAX_COLS		32
 
 #define KEY(row, col, val)	((((row) & (MATRIX_MAX_ROWS - 1)) << 24) |\
 				 (((col) & (MATRIX_MAX_COLS - 1)) << 16) |\
-- 
1.7.3.5

