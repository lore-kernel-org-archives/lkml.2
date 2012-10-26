Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2JZAi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:38:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:52974 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab2JZAGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 17/42] usb: host: xhci: New system added for Compliance Mode Patch on SN65LVPE502CP
Date: Thu, 25 Oct 2012 17:05:25 -0700
Message-Id: <20121026000126.509614687@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -479,7 +479,8 @@ static bool compliance_mode_recovery_tim
 
 	if (strstr(dmi_product_name, "Z420") ||
 			strstr(dmi_product_name, "Z620") ||
-			strstr(dmi_product_name, "Z820"))
+			strstr(dmi_product_name, "Z820") ||
+			strstr(dmi_product_name, "Z1"))
 		return true;
 
 	return false;


