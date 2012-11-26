Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab2KZRKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab2KZRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 172/270] usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP
Date: Mon, 26 Nov 2012 14:57:42 -0200
Message-Id: <1353949160-26803-173-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Alexis R. Cortes" <alexis.cortes@ti.com>

commit 470809741a28c3092279f4e1f3f432e534d46068 upstream.

This minor change adds a new system to which the "Fix Compliance Mode
on SN65LVPE502CP Hardware" patch has to be applied also.

System added:
Vendor: Hewlett-Packard. System Model: Z1

Signed-off-by: Alexis R. Cortes <alexis.cortes@ti.com>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index db4a2fa..ad29888 100644
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
1.7.9.5

