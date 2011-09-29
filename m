Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1I1QeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:34:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1I1QeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:34:09 -0400
From: yxlraid@gmail.com
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com,
        dan.j.williams@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 2/8] [SCSI] mvsas: add support for 9480 device id
Date: Thu, 29 Sep 2011 00:33:24 -0700
Message-Id: <4e834c7f.6539440a.62a1.fffffe8b@mx.google.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <mvsas>
References: <mvsas>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- Add support for Marvell 88SE9480 SAS/SATA HBA

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e9af66..2bbf43c 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -707,6 +707,15 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
 	{ PCI_VDEVICE(TTI, 0x2760), chip_9480 },
 	{
 		.vendor		= 0x1b4b,
+		.device		= 0x9480,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= 0x9480,
+		.class		= 0,
+		.class_mask	= 0,
+		.driver_data	= chip_9480,
+	},
+	{
+		.vendor		= 0x1b4b,
 		.device		= 0x9445,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= 0x9480,
-- 
1.7.4.4

