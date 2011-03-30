Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406Ab1C3VpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:45:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857Ab1C3VHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133343"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, ak@linux.intel.com,
        max@stro.at, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [125/275] scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list
Message-Id: <20110330210605.5093F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Brian King <brking@linux.vnet.ibm.com>

commit 22963a37b3437a25812cc856afa5a84ad4a3f541 upstream.

Adds IBM Power Virtual SCSI ALUA devices to the ALUA device handler.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/scsi/device_handler/scsi_dh_alua.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/device_handler/scsi_dh_alua.c	2011-03-29 23:03:00.822279127 -0700
+++ linux-2.6.35.y/drivers/scsi/device_handler/scsi_dh_alua.c	2011-03-29 23:03:00.839278695 -0700
@@ -721,6 +721,7 @@
 	{"NETAPP", "LUN"},
 	{"AIX", "NVDISK"},
 	{"NETAPP", "LUN"},
+	{"AIX", "NVDISK"},
 	{NULL, NULL}
 };
 
