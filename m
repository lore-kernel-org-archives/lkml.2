Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab1KNXqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:46:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab1KNXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:46:21 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        penberg@kernel.org, mingo@elte.hu,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 2/5] virtio-pci: Fix compilation issue
Date: Tue, 15 Nov 2011 01:43:14 +0200
Message-Id: <1321314197-5265-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
In-Reply-To: <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
References: <20111114181854.GA24953@redhat.com>
 <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/virtio/virtio_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 7625434..d242fcc 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -129,10 +129,10 @@ static void __iomem *virtio_pci_map_cfg(struct virtio_pci_device *vp_dev, u8 cap
         bir &= VIRTIO_PCI_CAP_CFG_BIR_MASK;
         size >>= VIRTIO_PCI_CAP_CFG_SIZE_SHIFT;
         size &= VIRTIO_PCI_CAP_CFG_SIZE_MASK;
-        off >>= VIRTIO_PCI_CAP_CFG_OFF_SHIFT;
-        off &= VIRTIO_PCI_CAP_CFG_OFF_MASK;
+        offset >>= VIRTIO_PCI_CAP_CFG_OFF_SHIFT;
+        offset &= VIRTIO_PCI_CAP_CFG_OFF_MASK;
 	/* Align offset appropriately */
-	off &= ~(align - 1);
+	offset &= ~(align - 1);
 
 	/* It's possible for a device to supply a huge config space,
 	 * but we'll never need to map more than a page ATM. */
-- 
1.7.8.rc1

