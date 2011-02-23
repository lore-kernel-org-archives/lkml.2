Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1BWPzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:55:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34644 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754352Ab1BWPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:55:33 -0500
X-Authenticated: #52724904
X-Provags-ID: V01U2FsdGVkX1/zGGdQrhjznMIPJzbckFhFDm8HDCD1HeeNH7eHY6
	GNXzC5OAWThtNt
From: David Jenni <dave.j@gmx.ch>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jenni <dave.j@gmx.ch>
Subject: [PATCH] Filesystem: fifo: Fixed coding style issue.
Date: Wed, 23 Feb 2011 16:51:05 +0100
Message-Id: <1298476265-437-1-git-send-email-dave.j@gmx.ch>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: David Jenni <dave.j@gmx.ch>
---
 fs/fifo.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/fifo.c b/fs/fifo.c
index 4e303c2..b1a524d 100644
--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -66,8 +66,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
 				/* suppress POLLHUP until we have
 				 * seen a writer */
 				filp->f_version = pipe->w_counter;
-			} else 
-			{
+			} else {
 				wait_for_partner(inode, &pipe->w_counter);
 				if(signal_pending(current))
 					goto err_rd;
-- 
1.7.3.4

