Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0CYRYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:24:44 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35786 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0CYRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NFwpK5mHgRNgVx0egxOWiOwhqojkwN7JObCvqs1zoscBysh4YCkd53s8+PsmHBuA+2
         uLE/8g5tga34hl1rGtLbwkqOVuZJbg22BgfUtduQMkpB34rjqO6LhM9Isi74ui97gwAu
         h48R3XGpLLbF8dYtrQTyJZXTsXTC//cPOWzzQ=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <damm@igel.co.jp>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] USB gadget r8a66597-udc.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:40 +0100
Message-Id: <1269537767-7553-10-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/gadget/r8a66597-udc.c: linux/err.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/usb/gadget/r8a66597-udc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 5e13d23..8b45145 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
-- 
1.7.0.3.296.g9776a

