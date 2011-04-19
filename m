Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1DSXxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:53:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:47010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1DSXxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:53:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,242,1301900400"; 
   d="scan'208";a="735775055"
From: Seth Heasley <seth.heasley@intel.com>
To: jgarzik@pobox.com
Subject: [PATCH 2.6.39-rc3] ata_piix: IDE-mode SATA patch for Intel Panther Point DeviceIDs
Date: Tue, 19 Apr 2011 16:45:17 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.35.6-45.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191645.17789.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the IDE-mode SATA DeviceIDs for the Intel Panther 
Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.39-rc3/drivers/ata/ata_piix.c.orig	2011-04-11 
17:21:51.000000000 -0700
+++ linux-2.6.39-rc3/drivers/ata/ata_piix.c	2011-04-14 
11:38:04.000000000 -0700
@@ -309,6 +309,14 @@
 	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (PBG) */
 	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
ich8_2port_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
ich8_2port_sata },
+	/* SATA Controller IDE (Panther Point) */
+	{ 0x8086, 0x1e09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 
ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
