Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2JQTJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:09:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56440 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592Ab2JQTJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:09:13 -0400
Message-ID: <507F0258.8030503@ti.com>
Date: Wed, 17 Oct 2012 14:09:12 -0500
From: "Alexis R. Cortes" <alexis.cortes@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: <sarah.a.sharp@linux.intel.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brian.quach@ti.com>, <jorge.llamas@ti.com>
Subject: [PATCH] usb: host: xhci: New system added for Compliance Mode Patch
 on SN65LVPE502CP
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This minor change adds a new system to which the "Fix Compliance Mode
on SN65LVPE502CP Hardware" patch has to be applied also.

System added:
Vendor: Hewlett-Packard. System Model: Z1

Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
---
 drivers/usb/host/xhci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8d7fcbb..7d462bf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -479,7 +479,8 @@ static bool compliance_mode_recovery_timer_quirk_check(void)
 
 	if (strstr(dmi_product_name, "Z420") ||
 			strstr(dmi_product_name, "Z620") ||
-			strstr(dmi_product_name, "Z820"))
+			strstr(dmi_product_name, "Z820") ||
+			strstr(dmi_product_name, "Z1"))
 		return true;
 
 	return false;
-- 
1.7.1

