Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2KBMIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:08:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35232 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2KBMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:08:49 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] Staging/media: fixed spacing coding style in go7007/wis-ov7640.c
Date: Fri,  2 Nov 2012 21:08:41 +0900
Message-Id: <1351858121-5708-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: that open brace { should be on the previous line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-ov7640.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-ov7640.c b/drivers/staging/media/go7007/wis-ov7640.c
index 6bc9470..eb5efc9 100644
--- a/drivers/staging/media/go7007/wis-ov7640.c
+++ b/drivers/staging/media/go7007/wis-ov7640.c
@@ -29,8 +29,7 @@ struct wis_ov7640 {
 	int hue;
 };
 
-static u8 initial_registers[] =
-{
+static u8 initial_registers[] = {
 	0x12, 0x80,
 	0x12, 0x54,
 	0x14, 0x24,
-- 
1.7.9.5

