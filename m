Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2AXAZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:25:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:43526 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2AXAZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:25:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="99799611"
From: Seth Heasley <seth.heasley@intel.com>
To: tiwai@suse.de, alsa-devel@alsa-project.org, perex@perex.cz
Subject: [PATCH 1/6] hda_intel: Add Lynx Point HD Audio Controller DeviceIDs
Date: Mon, 23 Jan 2012 16:24:31 -0800
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, james.d.ralston@intel.com,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231624.31275.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the HD Audio DeviceIDs for the Intel Lynx Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 sound/pci/hda/hda_intel.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0852e20..adb4fa7 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -148,6 +148,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, PCH},"
 			 "{Intel, CPT},"
 			 "{Intel, PPT},"
+			 "{Intel, LPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
@@ -2989,6 +2990,10 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	{ PCI_DEVICE(0x8086, 0x1e20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
 	  AZX_DCAPS_BUFSIZE},
+	/* Lynx Point */
+	{ PCI_DEVICE(0x8086, 0x8c20),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
+	  AZX_DCAPS_BUFSIZE},
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |
-- 
1.7.4.4

