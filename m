Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab2KFMdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:33:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63150 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KFMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:33:34 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] Staging/media: fixed spacing coding style in go7007/wis-tw9903.c
Date: Tue,  6 Nov 2012 21:33:26 +0900
Message-Id: <1352205206-5794-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: that open brace { should be on the previous line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-tw9903.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw9903.c b/drivers/staging/media/go7007/wis-tw9903.c
index 9230f4a..3821cd5 100644
--- a/drivers/staging/media/go7007/wis-tw9903.c
+++ b/drivers/staging/media/go7007/wis-tw9903.c
@@ -31,8 +31,7 @@ struct wis_tw9903 {
 	int hue;
 };
 
-static u8 initial_registers[] =
-{
+static u8 initial_registers[] = {
 	0x02, 0x44, /* input 1, composite */
 	0x03, 0x92, /* correct digital format */
 	0x04, 0x00,
-- 
1.7.9.5

