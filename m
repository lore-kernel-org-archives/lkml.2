Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2KELgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:36:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33603 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2KELgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:36:54 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] Staging/media: fixed spacing coding style in go7007/wis-saa7113.c
Date: Mon,  5 Nov 2012 20:36:48 +0900
Message-Id: <1352115408-8217-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: that open brace { should be on the previous line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-saa7113.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-saa7113.c b/drivers/staging/media/go7007/wis-saa7113.c
index 05e0e10..7f155cb 100644
--- a/drivers/staging/media/go7007/wis-saa7113.c
+++ b/drivers/staging/media/go7007/wis-saa7113.c
@@ -32,8 +32,7 @@ struct wis_saa7113 {
 	int hue;
 };
 
-static u8 initial_registers[] =
-{
+static u8 initial_registers[] = {
 	0x01, 0x08,
 	0x02, 0xc0,
 	0x03, 0x33,
-- 
1.7.9.5

