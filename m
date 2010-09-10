Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0IJXro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:47:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:53460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0IJXrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:47:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,348,1280732400"; 
   d="scan'208";a="553476452"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.35.4] ata_piix: IDE Mode SATA patch for Intel Patsburg DeviceIDs
Date: Fri, 10 Sep 2010 16:39:28 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
References: <201001121701.28589.seth.heasley@intel.com> <201009090942.40760.seth.heasley@intel.com>
In-Reply-To: <201009090942.40760.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009101639.28973.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Patsburg (PCH) IDE mode SATA Controller DeviceIDs.
 
Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.35.4/drivers/ata/ata_piix.c.orig	2010-08-26 16:47:12.000000000 -0700
+++ linux-2.6.35.4/drivers/ata/ata_piix.c	2010-08-31 17:29:43.697162374 -0700
@@ -302,6 +302,10 @@
 	{ 0x8086, 0x1c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (CPT) */
 	{ 0x8086, 0x1c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (PBG) */
+	{ 0x8086, 0x1d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (PBG) */
+	{ 0x8086, 0x1d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
