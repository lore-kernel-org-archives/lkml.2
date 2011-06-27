Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1F0OeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:34:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64677 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1F0OeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tFXlS99dq2Hloaye8noZV1q+iRqcP4pjjXjeLgQ61nouaQuBgvMNoZ28V8NL2ZZHPy
         l8GSmhNPBG5SXBteTlMG0kCmlF6BVhbdLrrWw5UFPEJurNKDvFFiTEkg2b6hojGcknIL
         04/AvyHwibSiIUsFcld4E34VQkDfOeLuVxle4=
Subject: [PATCH 2/2] Input: tnetv107x-ts - fix MODULE_ALIAS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Cyril Chemparathy <cyril@ti.com>, linux-input@vger.kernel.org
In-Reply-To: <1309185168.29085.0.camel@phoenix>
References: <1309185168.29085.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 22:33:57 +0800
Message-ID: <1309185237.29085.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the space between "platform:" prefix and the driver name.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/tnetv107x-ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/tnetv107x-ts.c b/drivers/input/touchscreen/tnetv107x-ts.c
index 22a3411..089b0a0 100644
--- a/drivers/input/touchscreen/tnetv107x-ts.c
+++ b/drivers/input/touchscreen/tnetv107x-ts.c
@@ -393,5 +393,5 @@ module_exit(tsc_exit);
 
 MODULE_AUTHOR("Cyril Chemparathy");
 MODULE_DESCRIPTION("TNETV107X Touchscreen Driver");
-MODULE_ALIAS("platform: tnetv107x-ts");
+MODULE_ALIAS("platform:tnetv107x-ts");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1



