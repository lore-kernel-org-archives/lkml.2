Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1DSXqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:46:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:47982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1DSXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,242,1301900400"; 
   d="scan'208";a="735772471"
From: Seth Heasley <seth.heasley@intel.com>
To: jgarzik@pobox.com
Subject: [PATCH 2.6.39-rc3] ahci: AHCI-mode SATA patch for Intel Panther Point DeviceIDs
Date: Tue, 19 Apr 2011 16:38:41 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.35.6-45.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191638.41267.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the AHCI-mode SATA DeviceIDs for the Intel 
Panther Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.39-rc3/drivers/ata/ahci.c.orig	2011-04-11 
17:21:51.000000000 -0700
+++ linux-2.6.39-rc3/drivers/ata/ahci.c	2011-04-14 
11:59:24.000000000 -0700
@@ -261,6 +261,12 @@
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC 
AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1e02), board_ahci }, /* Panther Point 
AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1e03), board_ahci }, /* Panther Point 
AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1e04), board_ahci }, /* Panther Point 
RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e05), board_ahci }, /* Panther Point 
RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point 
RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point 
RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, 
PCI_ANY_ID,
