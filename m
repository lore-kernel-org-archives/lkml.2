Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0GROj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:39:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab0GROjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:39:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vlueo7wDpPh3CEdRgNNok9ukBxM8Bv84EzLvYPzIRY4rwIxvM51l3Nq0fNLpxRDMdq
         iVhOzTlsaPM5cA0JnMQ/x/URq9Xoo5EKW9BsEVsDEKU3rjsKeNB0dhAPu3xHfED39d5T
         8ktm7Tl6E/eAqguzplK5OtbQZl2X6t/4pWakY=
Message-ID: <4C431211.6030706@gmail.com>
Date: Sun, 18 Jul 2010 22:39:13 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] keypad/nuc900: change keypad driver name from 'nuc900-keypad'
 to 'nuc900-kpi'
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I ever changed the keypad platform device name from 'nuc900-keypad' to
'nuc900-kpi', but I forget to modify the related keypad driver name,so
the keypad driver does not work,I have to send the patch to fix this issue.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/input/keyboard/w90p910_keypad.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/w90p910_keypad.c b/drivers/input/keyboard/w90p910_keypad.c
index 4ef764c..ee2bf6b 100644
--- a/drivers/input/keyboard/w90p910_keypad.c
+++ b/drivers/input/keyboard/w90p910_keypad.c
@@ -258,7 +258,7 @@ static struct platform_driver w90p910_keypad_driver = {
 	.probe		= w90p910_keypad_probe,
 	.remove		= __devexit_p(w90p910_keypad_remove),
 	.driver		= {
-		.name	= "nuc900-keypad",
+		.name	= "nuc900-kpi",
 		.owner	= THIS_MODULE,
 	},
 };
-- 
1.6.3.3
