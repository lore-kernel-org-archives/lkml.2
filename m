Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1ABHqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:46:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:36211 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1ABHYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 157/260] sis-agp: Remove SIS 760, handled by amd64-agp
Date: Sun,  2 Jan 2011 02:17:33 -0500
Message-Id: <1293952756-15010-158-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:02.0822 (UTC) FILETIME=[E4373C60:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit d831692a1a8e9ceaaa9bb16bb3fc503b7e372558 upstream.

SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
amd64-agp is apparently preferable since it has workarounds for some
BIOS misconfigurations that sis-agp doesn't handle.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/agp/sis-agp.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 6c3837a..95fdd4d 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -415,14 +415,6 @@ static struct pci_device_id agp_sis_pci_table[] = {
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
-	{
-		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
-		.class_mask	= ~0,
-		.vendor		= PCI_VENDOR_ID_SI,
-		.device		= PCI_DEVICE_ID_SI_760,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	},
 	{ }
 };
 
-- 
1.7.3.3

