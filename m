Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2LXCPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:15:00 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43166 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab2LXCOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:14:55 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 11/29] video/uvesafb: rename random32() to prandom_u32()
Date: Mon, 24 Dec 2012 11:13:58 +0900
Message-Id: <1356315256-6572-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/uvesafb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 2f8f82d..d120b11 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -166,7 +166,7 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 	memcpy(&m->id, &uvesafb_cn_id, sizeof(m->id));
 	m->seq = seq;
 	m->len = len;
-	m->ack = random32();
+	m->ack = prandom_u32();
 
 	/* uvesafb_task structure */
 	memcpy(m + 1, &task->t, sizeof(task->t));
-- 
1.7.11.7

