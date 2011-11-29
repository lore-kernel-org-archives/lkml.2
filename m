Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1K2CJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 21:09:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48807 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1K2CJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 21:09:00 -0500
Message-ID: <1322532534.3213.1.camel@phoenix>
Subject: [PATCH 2/2] Input: samsung-keypad - remove redundant MODULE_ALIAS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Donghwa Lee <dh09.lee@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Tue, 29 Nov 2011 10:08:54 +0800
In-Reply-To: <1322532472.3213.0.camel@phoenix>
References: <1322532472.3213.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MODULE_DEVICE_TABLE will setup the module alias for us, thus adding
MODULE_ALIAS for an entry already in MODULE_DEVICE_TABLE is redundant.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/samsung-keypad.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/samsung-keypad.c b/drivers/input/keyboard/samsung-keypad.c
index adfdcb4..6fc54b1 100644
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@ -634,4 +634,3 @@ MODULE_DESCRIPTION("Samsung keypad driver");
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
 MODULE_AUTHOR("Donghwa Lee <dh09.lee@samsung.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:samsung-keypad");
-- 
1.7.5.4



