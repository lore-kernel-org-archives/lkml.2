Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0DGNmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:42:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26250 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab0DGNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:19 -0400
Date: Wed, 07 Apr 2010 15:41:29 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/8] sched: __wake_up_locked() exported
In-reply-to: <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __wake_up_locked() function has been exported in case modules need it.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a1fce0..5fb8a37 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3940,6 +3940,7 @@ void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
 {
 	__wake_up_common(q, mode, 1, 0, NULL);
 }
+EXPORT_SYMBOL_GPL(__wake_up_locked);
 
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
 {
-- 
1.7.0

