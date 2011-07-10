Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1GJWUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 18:20:49 -0400
Received: from gw.minian.org ([83.96.227.91]:39520 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756721Ab1GJWUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 18:20:47 -0400
From: Edwin van Vliet <edwin@cheatah.nl>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH 3/3] drivers/input/tablet/aiptek: removed double define
Date: Mon, 11 Jul 2011 00:20:41 +0200
Message-Id: <1310336441-26893-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constant AIPTEK_TOOL_BUTTON_PEN_MODE was diefined twice

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 drivers/input/tablet/aiptek.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 0a619c5..6d89fd1 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -225,7 +225,6 @@
 	/* toolMode codes
 	 */
 #define AIPTEK_TOOL_BUTTON_PEN_MODE			BTN_TOOL_PEN
-#define AIPTEK_TOOL_BUTTON_PEN_MODE			BTN_TOOL_PEN
 #define AIPTEK_TOOL_BUTTON_PENCIL_MODE			BTN_TOOL_PENCIL
 #define AIPTEK_TOOL_BUTTON_BRUSH_MODE			BTN_TOOL_BRUSH
 #define AIPTEK_TOOL_BUTTON_AIRBRUSH_MODE		BTN_TOOL_AIRBRUSH
-- 
1.7.5.4

