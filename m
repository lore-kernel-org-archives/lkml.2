Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2H2Osy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:48:54 -0400
Received: from mail.tpi.com ([70.99.223.143]:4196 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2H2Osw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:48:52 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 3.6-rc3] wlcore: Declare MODULE_FIRMWARE usage
Date: Wed, 29 Aug 2012 08:48:09 -0600
Message-Id: <1346251689-37023-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Luciano Coelho <coelho@ti.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Eliad Peller <eliad@wizery.com>
Cc: Arik Nemtsov <arik@wizery.com>
Cc: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7254860..a55ace6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5663,3 +5663,4 @@ MODULE_PARM_DESC(no_recovery, "Prevent HW recovery. FW will remain stuck.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
+MODULE_FIRMWARE(WL12XX_NVS_NAME);
-- 
1.7.9.5

