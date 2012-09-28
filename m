Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460Ab2I1Vyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:54:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030232Ab2I1UXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yuval Mintz <yuvalmin@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 030/218] bnx2x: fix 57840_MF pci id
Date: Fri, 28 Sep 2012 13:14:07 -0700
Message-Id: <20120928201504.845360486@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
---
 include/linux/pci_ids.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2148,7 +2148,7 @@
 #define PCI_DEVICE_ID_TIGON3_5704S	0x16a8
 #define PCI_DEVICE_ID_NX2_57800_VF	0x16a9
 #define PCI_DEVICE_ID_NX2_5706S		0x16aa
-#define PCI_DEVICE_ID_NX2_57840_MF	0x16ab
+#define PCI_DEVICE_ID_NX2_57840_MF	0x16a4
 #define PCI_DEVICE_ID_NX2_5708S		0x16ac
 #define PCI_DEVICE_ID_NX2_57840_VF	0x16ad
 #define PCI_DEVICE_ID_NX2_57810_MF	0x16ae


