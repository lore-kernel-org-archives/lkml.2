Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0IJXiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:38:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:56585 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0IJXiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:38:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,348,1280732400"; 
   d="scan'208";a="656227380"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: perex@perex.cz
Subject: [PATCH 2.6.35.4] hda_intel: ALSA HD Audio patch for Intel Patsburg DeviceIDs
Date: Fri, 10 Sep 2010 16:29:56 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
        seth.heasley@intel.com
References: <201001121703.36016.seth.heasley@intel.com>
In-Reply-To: <201001121703.36016.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009101629.56579.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Patsburg (PCH) HD Audio Controller DeviceIDs.
 
Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.35.4/sound/pci/hda/hda_intel.c.orig	2010-08-26 16:47:12.000000000 -0700
+++ linux-2.6.35.4/sound/pci/hda/hda_intel.c	2010-09-01 13:25:54.429224879 -0700
@@ -126,6 +126,7 @@
 			 "{Intel, ICH10},"
 			 "{Intel, PCH},"
 			 "{Intel, CPT},"
+			 "{Intel, PBG},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
 			 "{ATI, SB600},"
@@ -2748,6 +2749,8 @@
 	{ PCI_DEVICE(0x8086, 0x3b57), .driver_data = AZX_DRIVER_ICH },
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_PCH },
+	/* PBG */
+	{ PCI_DEVICE(0x8086, 0x1d20), .driver_data = AZX_DRIVER_PCH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
 	/* ATI SB 450/600 */
