Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2BOTVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:21:44 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60236 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab2BOTV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:21:28 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Teddy Wang <teddy.wang@siliconmotion.com.cn>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Javier M. Mellid" <jmunhoz@igalia.com>,
        anish kumar <anish198519851985@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: sm7xx/smtcfb.c included linux/module.h twice
Date: Wed, 15 Feb 2012 20:21:07 +0100
Message-Id: <1329333667-32158-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333688;d0f9d328;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/sm7xx/smtcfb.c included 'linux/module.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/staging/sm7xx/smtcfb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
index ae0035f..1b3e2d0 100644
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -41,7 +41,6 @@
 
 #ifdef CONFIG_PM
 #include <linux/pm.h>
-#include <linux/module.h>
 #endif
 
 #include "smtcfb.h"
-- 
1.7.8.3

