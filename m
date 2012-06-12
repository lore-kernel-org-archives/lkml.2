Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2FLJi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:38:28 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:44650 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752103Ab2FLJi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:38:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEABsN109bdWOb/2dsb2JhbABFtTyBB4MYgT4TiA+5BZE0A5Ufj3uCYg
X-IronPort-AV: E=Sophos;i="4.77,394,1336341600"; 
   d="scan'208";a="1002185975"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ipack: delete sysfs from to-do list.
Date: Tue, 12 Jun 2012 11:37:46 +0200
Message-Id: <1339493866-10464-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have already got rid of sysfs files in the tpci200 driver, it is needed
to delete that mention in the TODO file.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/TODO |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/ipack/TODO b/drivers/staging/ipack/TODO
index 3a45a53..0f8bf20 100644
--- a/drivers/staging/ipack/TODO
+++ b/drivers/staging/ipack/TODO
@@ -15,10 +15,6 @@ TODO
 TPCI-200
 --------
 
-* It receives the name of the mezzanine plugged in each slot by SYSFS.
-  No autodetection supported yet, because the mezzanine driver could not be
-  loaded at the time that the tpci200 driver loads.
-
 * It has a linked list with the tpci200 devices it is managing. Get rid of it
   and use driver_for_each_device() instead.
 
-- 
1.7.10

