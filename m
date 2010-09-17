Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0IQI0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:26:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63415 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0IQIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UZPrOljaOhEtdQaX/cLwv/w6l8p4ZpmjCphqnjSqbU6g20vL9RoUBH6fm1vramdhw8
         EcHSyHMWzLeymC9Cg/TAcJEnqX03tQIwz2R+bZKnovL4XmzHIVoHgdUwb+KDgegP6Fp+
         0Up6rCbHTnscvJP/FQ1cBw32FDn/QF8laWc5U=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 7/9] staging: rtl8712: '&pointer[0]' to 'pointer' fix
Date: Fri, 17 Sep 2010 11:24:49 +0300
Message-Id: <c3d8b3731125f327f5c33fafed57767ce62481ed.1284711623.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100916225346.GA14448@kroah.com>
References: <20100916225346.GA14448@kroah.com>
In-Reply-To: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
References: <668ce39e9bd64e2a285367e2cc0963d678d1b501.1284711623.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index a54e25d..685a7b1 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1917,7 +1917,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 									irqL);
 			return -EINVAL;
 		}
-		printk(KERN_INFO "r8712u: BSSID:%pM\n", &bssid[0]);
+		printk(KERN_INFO "r8712u: BSSID:%pM\n", bssid);
 		if (!memcmp(bssid, pnetwork->network.MacAddress, ETH_ALEN)) {
 			/* BSSID match, then check if supporting wpa/wpa2 */
 			pbuf = r8712_get_wpa_ie(&pnetwork->network.IEs[12],
-- 
1.7.2.2

