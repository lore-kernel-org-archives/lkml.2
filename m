Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2BORzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:55:09 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41620 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab2BORzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:55:05 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cc770: linux/can/dev.h included twice
Date: Wed, 15 Feb 2012 18:55:01 +0100
Message-Id: <1329328501-4737-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329328505;b109608a;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/can/cc770/cc770.c included 'linux/can/dev.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/can/cc770/cc770.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
index c30f0e6..d42a6a7 100644
--- a/drivers/net/can/cc770/cc770.c
+++ b/drivers/net/can/cc770/cc770.c
@@ -34,7 +34,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-#include <linux/can/dev.h>
 #include <linux/can/platform/cc770.h>
 
 #include "cc770.h"
-- 
1.7.8.3

