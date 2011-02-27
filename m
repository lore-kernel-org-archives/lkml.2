Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1B0Eel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1B0Eee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c3S7PpDo/kspOMawpiox5D+g6BmrRUoz+vNhdPIT3lmjX4I7ZpxifHpkZ4F59iP/wS
         F7XN3vwb/xReG3q2A/ZjuChGhJCE+sexTd/cUH0X7Oa5/SadGaCPgOwlpMU58/B84Bun
         swNyfhkrCJQR8sowylwDY7ry0nmYLg0HmVgu4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH 02/17]drivers:watchdog:sbc_epx_c3.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:33:55 -0800
Message-Id: <1298781250-2718-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word.. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Wim Van Sebroeck <wim@iguana.be>
CC: linux-watchdog@vger.kernel.org 
---
 drivers/watchdog/sbc_epx_c3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 28f1214..3066a51 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -220,7 +220,7 @@ module_exit(watchdog_exit);
 MODULE_AUTHOR("Calin A. Culianu <calin@ajvar.org>");
 MODULE_DESCRIPTION("Hardware Watchdog Device for Winsystems EPX-C3 SBC.  "
 	"Note that there is no way to probe for this device -- "
-	"so only use it if you are *sure* you are runnning on this specific "
+	"so only use it if you are *sure* you are running on this specific "
 	"SBC system from Winsystems!  It writes to IO ports 0x1ee and 0x1ef!");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-- 
1.7.4.1

