Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab1C3Vpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:45:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964851Ab1C3VHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447645"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: michaelc@cs.wisc.edu, James.Bottomley@suse.de, ak@linux.intel.com,
        max@stro.at, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [124/275] scsi_dh_alua: add netapp to dev list
Message-Id: <20110330210604.4199B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mike Christie <michaelc@cs.wisc.edu>

commit cd4a8814d44672bd2c8f04a472121bfbe193809c upstream.

Newer Netapp target software supports ALUA, so
this patch adds them to the scsi_dev_alua dev list.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/device_handler/scsi_dh_alua.c	2011-03-29 22:51:18.530249026 -0700
+++ linux-2.6.35.y/drivers/scsi/device_handler/scsi_dh_alua.c	2011-03-29 23:54:49.334740074 -0700
@@ -720,6 +720,7 @@
 	{"Intel", "Multi-Flex"},
 	{"NETAPP", "LUN"},
 	{"AIX", "NVDISK"},
+	{"NETAPP", "LUN"},
 	{NULL, NULL}
 };
 
