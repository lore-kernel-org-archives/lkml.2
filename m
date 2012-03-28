Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2C0K2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:28:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40616 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2C0K2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:28:40 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] pch_phub: delete duplicate definitions
Date: Wed, 28 Mar 2012 19:27:34 +0900
Message-Id: <1332930454-6193-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/misc/pch_phub.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..9fbcacd 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -65,10 +65,6 @@
 #define PCI_VENDOR_ID_ROHM			0x10db
 #define PCI_DEVICE_ID_ROHM_ML7213_PHUB		0x801A
 
-/* Macros for ML7213 */
-#define PCI_VENDOR_ID_ROHM			0x10db
-#define PCI_DEVICE_ID_ROHM_ML7213_PHUB		0x801A
-
 /* Macros for ML7223 */
 #define PCI_DEVICE_ID_ROHM_ML7223_mPHUB	0x8012 /* for Bus-m */
 #define PCI_DEVICE_ID_ROHM_ML7223_nPHUB	0x8002 /* for Bus-n */
-- 
1.7.7.6

