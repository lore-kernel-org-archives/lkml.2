Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1GJWOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 18:14:47 -0400
Received: from gw.minian.org ([83.96.227.91]:55887 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755023Ab1GJWOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 18:14:44 -0400
From: Edwin van Vliet <edwin@cheatah.nl>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH 2/2] drivers/tty/synclink: remove double comment
Date: Mon, 11 Jul 2011 00:14:37 +0200
Message-Id: <1310336077-26835-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redundant comment line was removed

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 drivers/tty/synclink.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 272e417..e67fb20 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -2124,7 +2124,6 @@ static int mgsl_write(struct tty_struct * tty,
 	if ( info->params.mode == MGSL_MODE_HDLC ||
 			info->params.mode == MGSL_MODE_RAW ) {
 		/* operating in synchronous (frame oriented) mode */
-		/* operating in synchronous (frame oriented) mode */
 		if (info->tx_active) {
 
 			if ( info->params.mode == MGSL_MODE_HDLC ) {
-- 
1.7.5.4

