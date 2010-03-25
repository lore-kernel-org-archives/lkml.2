Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0CYRXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:09 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0CYRXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WbWwimUlxuc2jtdK6JD1AGVWQvQgZEzUGdwjUyyAJxYD65ad2NIjy1t2ICakJ2GF4+
         p3BSIb3MtMvMRtyxny3Ud+odYspbKXUi3nsj8+mO0r6YGCCzELUSxfaWYIeSbPwq+y4x
         d4FdV++8PLYYxerYOFXs5IpcolL+VPla0ADos=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>, Daniel Mack <daniel@caiaq.de>,
       Vladimir Zapolskiy <vzapolskiy@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] ARM mach-mx3: duplicated include
Date: Thu, 25 Mar 2010 18:22:34 +0100
Message-Id: <1269537767-7553-4-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-mx3/mx31lite-db.c: linux/platform_device.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/mach-mx3/mx31lite-db.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx3/mx31lite-db.c b/arch/arm/mach-mx3/mx31lite-db.c
index ccd8742..16c955e 100644
--- a/arch/arm/mach-mx3/mx31lite-db.c
+++ b/arch/arm/mach-mx3/mx31lite-db.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
-#include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
 
-- 
1.7.0.3.296.g9776a

