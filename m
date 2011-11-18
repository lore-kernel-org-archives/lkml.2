Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1KRFGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:06:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47550 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1KRFGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:06:33 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 10/10] Drivers: tty: synclink_gt: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:06:27 -0700
Message-Id: <1321592787-9163-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclink_gt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 9a8979f..c795715 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -4676,7 +4676,7 @@ check_again:
 			end = 0;
 
 		if (end == info->rbuf_current) {
-			if (info->rx_enabled){
+			if (info->rx_enabled) {
 				spin_lock_irqsave(&info->lock,flags);
 				rx_start(info);
 				spin_unlock_irqrestore(&info->lock,flags);
-- 
1.7.7.3

