Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab2HIQj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:39:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:27702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758678Ab2HIQjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:39:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,741,1336374000"; 
   d="scan'208";a="178055552"
From: james.d.ralston@intel.com
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 3/5] hda_intel: Add Device IDs for Intel Lynx Point-LP PCH
Date: Thu,  9 Aug 2012 09:38:59 -0700
Message-Id: <1344530339-2559-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Ralston <james.d.ralston@intel.com>

This patch adds the Intel HD Audio Device IDs for the Intel Lynx Point-LP PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 sound/pci/hda/hda_intel.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c8aced1..60882c6 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -151,6 +151,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, CPT},"
 			 "{Intel, PPT},"
 			 "{Intel, LPT},"
+			 "{Intel, LPT_LP},"
 			 "{Intel, HPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
@@ -3270,6 +3271,14 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	{ PCI_DEVICE(0x8086, 0x8c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
 	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
+	/* Lynx Point-LP */
+	{ PCI_DEVICE(0x8086, 0x9c20),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
+	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
+	/* Lynx Point-LP */
+	{ PCI_DEVICE(0x8086, 0x9c21),
+	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
+	  AZX_DCAPS_BUFSIZE | AZX_DCAPS_POSFIX_COMBO },
 	/* Haswell */
 	{ PCI_DEVICE(0x8086, 0x0c0c),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |
-- 
1.7.7.6

