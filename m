Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab2ILNAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:00:54 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:16819 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2ILMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqACACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIQEFZxIQUVcGE4gRvGKRUgOVX4EUkXM
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511810"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 22/24] Staging: ipack: update TODO file
Date: Wed, 12 Sep 2012 14:55:44 +0200
Message-Id: <1347454546-23236-22-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the latest patches, the TODO file was outdated.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/TODO |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ipack/TODO b/drivers/staging/ipack/TODO
index b21d33a..ffafe69 100644
--- a/drivers/staging/ipack/TODO
+++ b/drivers/staging/ipack/TODO
@@ -12,29 +12,8 @@ operations between the two kind of boards.
 TODO
 ====
 
-TPCI-200
---------
-
-* It has a linked list with the tpci200 devices it is managing. Get rid of it
-  and use driver_for_each_device() instead.
-
-IP-OCTAL
---------
-
-* It has a linked list which saves the devices it is currently
-  managing. It should use the driver_for_each_device() function. It is not there
-  due to the impossibility of using container_of macro to recover the
-  corresponding "struct ipoctal" because the attribute "struct ipack_device" is
-  a pointer. This code should be refactored.
-
-Ipack
------
-
-* The structures and API exported can be improved a lot. For example, the
-  way to unregistering IP module devices, doing the IP module driver a call to
-  remove_device() to notify the carrier driver, or the opposite with the call to
-  the ipack_driver_ops' remove() function could be improved.
-
+checkpatch.pl warnings
+cleanup
 
 Contact
 =======
-- 
1.7.10.4

