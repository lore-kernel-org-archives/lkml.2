Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2KELfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:35:52 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45825 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2KELfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:35:50 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] Staging/media: fixed spacing coding style in go7007/wis-saa7115.c
Date: Mon,  5 Nov 2012 20:35:45 +0900
Message-Id: <1352115345-8149-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: that open brace { should be on the previous line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-saa7115.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-saa7115.c b/drivers/staging/media/go7007/wis-saa7115.c
index 46cff59..b31a82b 100644
--- a/drivers/staging/media/go7007/wis-saa7115.c
+++ b/drivers/staging/media/go7007/wis-saa7115.c
@@ -32,8 +32,7 @@ struct wis_saa7115 {
 	int hue;
 };
 
-static u8 initial_registers[] =
-{
+static u8 initial_registers[] = {
 	0x01, 0x08,
 	0x02, 0xc0,
 	0x03, 0x20,
-- 
1.7.9.5

