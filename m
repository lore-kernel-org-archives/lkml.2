Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2IQBMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:12:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33709 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758Ab2IQAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:33 -0400
Message-Id: <20120917003636.588561236@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yuval Mintz <yuvalmin@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 075/135] bnx2x: fix 57840_MF pci id
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuval Mintz <yuvalmin@broadcom.com>

[ Upstream commit 5c879d2094946081af934739850c7260e8b25d3c ]

Commit c3def943c7117d42caaed3478731ea7c3c87190e have added support for
new pci ids of the 57840 board, while failing to change the obsolete value
in 'pci_ids.h'.
This patch does so, allowing the probe of such devices.

Signed-off-by: Yuval Mintz <yuvalmin@broadcom.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/pci_ids.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2aaee0c..67cc215 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2124,7 +2124,7 @@
 #define PCI_DEVICE_ID_TIGON3_5704S	0x16a8
 #define PCI_DEVICE_ID_NX2_57800_VF	0x16a9
 #define PCI_DEVICE_ID_NX2_5706S		0x16aa
-#define PCI_DEVICE_ID_NX2_57840_MF	0x16ab
+#define PCI_DEVICE_ID_NX2_57840_MF	0x16a4
 #define PCI_DEVICE_ID_NX2_5708S		0x16ac
 #define PCI_DEVICE_ID_NX2_57840_VF	0x16ad
 #define PCI_DEVICE_ID_NX2_57810_MF	0x16ae


