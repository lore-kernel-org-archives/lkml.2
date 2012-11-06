Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2KFTk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:40:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2KFTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:40:23 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] Staging/media: fixed spacing coding style in go7007/wis-uda1342.c
Date: Wed,  7 Nov 2012 04:40:16 +0900
Message-Id: <1352230817-9440-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: that open brace { should be on the previous line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/s2250-board.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 014d384..6f94c17 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -103,8 +103,7 @@ static u16 vid_regs_fp[] = {
 };
 
 /* PAL specific values */
-static u16 vid_regs_fp_pal[] =
-{
+static u16 vid_regs_fp_pal[] = {
 	0x120, 0x017,
 	0x121, 0xd22,
 	0x122, 0x122,
-- 
1.7.9.5

