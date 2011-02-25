Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1BYGL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:11:56 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:38755 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1BYGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mEe9tlipwIC+5WGKIkYVq8JMjgLoF0O2vsHaYK6bGCTwMFOtZVUcR00GzfAOZBPG6b
         DYsCHzrxB0ybmcj4tt2LG0VDwkLZJOAEpnNAN8aqGkl4iJU+vT5+m7JP1V9JvOjrrMES
         IqUHfcMMEQSHh0PTk/9C/jwWZNhWcO3Q7dDrw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: mchehab@infradead.org, dheitmueller@hauppauge.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 07/21]drivers:media:cx231xx.h remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:11:36 -0800
Message-Id: <1298614296-3689-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/cx231xx/cx231xx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 72bbea2..82a810a 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -464,7 +464,7 @@ struct cx231xx_fh {
 #define I2C_STOP                0x0
 /* 1-- do not transmit STOP at end of transaction */
 #define I2C_NOSTOP              0x1
-/* 1--alllow slave to insert clock wait states */
+/* 1--allow slave to insert clock wait states */
 #define I2C_SYNC                0x1
 
 struct cx231xx_i2c {
-- 
1.7.4.1

