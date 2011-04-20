Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1DTSHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:07:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:21132 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1DTSHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:07:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,247,1301900400"; 
   d="scan'208";a="736147078"
From: Seth Heasley <seth.heasley@intel.com>
To: perex@perex.cz
Subject: [PATCH 2.6.39-rc3] hda_intel: ALSA HD Audio patch for Intel Panther Point DeviceIDs
Date: Wed, 20 Apr 2011 10:59:57 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.35.6-45.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104201059.57882.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the HD Audio Controller DeviceIDs for the Intel Panther Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
--- linux-2.6.39-rc3/sound/pci/hda/hda_intel.c.orig	2011-04-11 17:21:51.000000000 -0700
+++ linux-2.6.39-rc3/sound/pci/hda/hda_intel.c	2011-04-14 11:44:40.000000000 -0700
@@ -126,6 +126,7 @@
 			 "{Intel, ICH10},"
 			 "{Intel, PCH},"
 			 "{Intel, CPT},"
+			 "{Intel, PPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
@@ -2759,6 +2760,8 @@
 	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_PCH },
 	/* PBG */
 	{ PCI_DEVICE(0x8086, 0x1d20), .driver_data = AZX_DRIVER_PCH },
+	/* Panther Point */
+	{ PCI_DEVICE(0x8086, 0x1e20), .driver_data = AZX_DRIVER_PCH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
 	/* Generic Intel */
