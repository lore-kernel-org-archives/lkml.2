Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0CYRXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:44 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35786 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0CYRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WPUJ+0YhRc7PqvpKEHsiOg2UUlPWbPf0183t2hJMvJJ7DkBc/COBOmQ7Mv61ZQiokF
         Kt0TsHHGnF3ogw+tKQrdsupgzCxGCP+jFS37q6MDu++4XR7wWXnCFutdFmNZGyo7xPZ7
         G447GTg3PTP/ZcMZe9PSJBvk6AepnrCjELOYY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Koen Kooi <koen@openembedded.org>, linux-fbdev@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] Video omap lcd_omap3beagle.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:46 +0100
Message-Id: <1269537767-7553-16-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/omap/lcd_omap3beagle.c: plat/mux.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/video/omap/lcd_omap3beagle.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/omap/lcd_omap3beagle.c b/drivers/video/omap/lcd_omap3beagle.c
index ca75cc2..ac715f9 100644
--- a/drivers/video/omap/lcd_omap3beagle.c
+++ b/drivers/video/omap/lcd_omap3beagle.c
@@ -26,7 +26,6 @@
 #include <linux/i2c/twl.h>
 
 #include <plat/mux.h>
-#include <plat/mux.h>
 #include <asm/mach-types.h>
 
 #include "omapfb.h"
-- 
1.7.0.3.296.g9776a

