Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2J1XiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:38:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42080 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837Ab2J1X14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:56 -0400
Message-Id: <20121028231554.908880456@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 058/105] usb: host: xhci: New system added for Compliance Mode Patch on
 SN65LVPE502CP
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


