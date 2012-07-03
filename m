Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2GCJbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:31:52 -0400
Received: from skyrme.org ([193.175.80.135]:44187 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab2GCJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:31:51 -0400
Date: 3 Jul 2012 09:31:48 +0000
Message-Id: <1341307908-19223-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Dan Williams" <dcbw@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>,
        "Marcelo Tosatti" <marcelo@kvack.org>,
        "Dan Williams" <dcbw@redhat.com>
Subject: [PATCH] net/wireless: remove macro defined twice with same value
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the list of commands CMD_802_11_EEPROM_ACCESS had been
defined twice, unnecessarily, luckily with same value.

Remove one occurence.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Marcelo Tosatti <marcelo@kvack.org>
Cc: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/host.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 2e2dbfa..96726f7 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -68,7 +68,6 @@
 #define CMD_802_11_BEACON_STOP                  0x0049
 #define CMD_802_11_MAC_ADDRESS                  0x004d
 #define CMD_802_11_LED_GPIO_CTRL                0x004e
-#define CMD_802_11_EEPROM_ACCESS                0x0059
 #define CMD_802_11_BAND_CONFIG                  0x0058
 #define CMD_GSPI_BUS_CONFIG                     0x005a
 #define CMD_802_11D_DOMAIN_INFO                 0x005b
-- 
1.7.9.5

