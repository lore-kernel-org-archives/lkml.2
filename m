Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1KRF4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:56:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61259 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1KRF4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:56:50 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 27/27] Drivers: tty: synclinkmp: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:56:45 -0700
Message-Id: <1321595805-10819-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclinkmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index 5b9b0f4..73c52d6 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -4881,7 +4881,7 @@ CheckAgain:
 		if (EndIndex == info->current_rx_buf) {
 			/* all buffers have been 'used' but none mark	   */
 			/* the end of a frame. Reset buffers and receiver. */
-			if ( info->rx_enabled ){
+			if ( info->rx_enabled ) {
 				spin_lock_irqsave(&info->lock,flags);
 				rx_start(info);
 				spin_unlock_irqrestore(&info->lock,flags);
-- 
1.7.7.3

