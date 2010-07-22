Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0GVBbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:31:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60933 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0GVBa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T1y8HNY47+NmBge6aWsOFpRUyYKoGpZRaR67XMQhmWL4FVV131NxlL/viiEf6A969A
         dXs3pUWKx9slJToxt3GcnrNie3Mt0SOiTGf/g/Aitjo7wszfF8++Ewe8zOIfH/HAANC3
         fOAZPUCBtZ2LFWbZ+LqwiVYH48//LUsuRptr8=
From: ehames@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH 1/2] Staging: wlan-ng: fix style in p80211netdev.c
Date: Wed, 21 Jul 2010 22:31:55 -0300
Message-Id: <4c479f51.19eb640a.387a.6ce2@mx.google.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgardo Hames <ehames@gmail.com>

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 31308b4..ead8a35 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -819,7 +819,8 @@ int wlan_unsetup(wlandevice_t *wlandev)
 
 	if (wlandev->netdev) {
 		wdev = netdev_priv(wlandev->netdev);
-		if(wdev->wiphy) wlan_free_wiphy(wdev->wiphy);
+		if (wdev->wiphy)
+			wlan_free_wiphy(wdev->wiphy);
 		free_netdev(wlandev->netdev);
 		wlandev->netdev = NULL;
 	}
-- 
1.6.3.3

