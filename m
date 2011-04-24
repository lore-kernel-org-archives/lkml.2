Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1DXPW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 11:22:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53941 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab1DXPWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 11:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lD4Uy1IeZjjpdYa4BM9IDKSr9qCMM1ZxQEIlMwtkkRmvRMPvoallRHpRms1d6i7AiQ
         zy+SH06zGTQ8zYE04dxCTxzYzBmTzixUPPV4Va0jJe80JZYdNeJQ66K3aKt84dgeG1nl
         Z96DpSY4oxvqfjbxmt7FPEj6YslTA/SifHqAU=
Subject: [PATCH] Input: qt1070 - Add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bo Shen <voice.shen@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 23:22:45 +0800
Message-ID: <1303658565.8556.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the necessary MODULE_DEVICE_TABLE() information allows the
driver to be automatically loaded by udev

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/qt1070.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/qt1070.c b/drivers/input/keyboard/qt1070.c
index fba8404..ca7b891 100644
--- a/drivers/input/keyboard/qt1070.c
+++ b/drivers/input/keyboard/qt1070.c
@@ -248,6 +248,7 @@ static const struct i2c_device_id qt1070_id[] = {
 	{ "qt1070", 0 },
 	{ },
 };
+MODULE_DEVICE_TABLE(i2c, qt1070_id);
 
 static struct i2c_driver qt1070_driver = {
 	.driver	= {
-- 
1.7.1



