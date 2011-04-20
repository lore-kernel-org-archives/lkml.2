Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1DTPv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:51:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:50477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1DTPv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:51:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,247,1301900400"; 
   d="scan'208";a="736088661"
To: jgarzik@pobox.com
Subject: [PATCH 2.6.39-rc3 RESEND] ata_piix: IDE-mode SATA patch for Intel Panther Point DeviceIDs
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com
From: Seth Heasley <seth.heasley@intel.com>
Date: Wed, 20 Apr 2011 08:43:37 -0700
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104200843.37660.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previously submitted patch was word-wrapped.

This patch adds the IDE-mode SATA DeviceIDs for the Intel Panther 
Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.39-rc3/drivers/ata/ata_piix.c.orig	2011-04-11 17:21:51.000000000 -0700
+++ linux-2.6.39-rc3/drivers/ata/ata_piix.c	2011-04-14 11:38:04.000000000 -0700
@@ -309,6 +309,14 @@
 	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (PBG) */
 	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
