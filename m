Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0EXAIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:08:18 -0400
Received: from xenotime.net ([72.52.115.56]:40989 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755734Ab0EXAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:08:04 -0400
Date: Sun, 23 May 2010 17:02:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Eric Moore <Eric.Moore@lsi.com>
Subject: [PATCH 8/9] fusion: fix kernel-doc notation
Message-ID: <12746593502411@xenotime.net>
In-Reply-To: <12746593501290@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a
short description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
---
 drivers/message/fusion/mptscsih.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- lnx-2634-docs.orig/drivers/message/fusion/mptscsih.c
+++ lnx-2634-docs/drivers/message/fusion/mptscsih.c
@@ -2561,9 +2561,7 @@ mptscsih_getclear_scsi_lookup(MPT_ADAPTE
 }
 
 /**
- * mptscsih_set_scsi_lookup
- *
- * writes a scmd entry into the ScsiLookup[] array list
+ * mptscsih_set_scsi_lookup - write a scmd entry into the ScsiLookup[] array list
  *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
@@ -2726,7 +2724,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 
 /**
- *	mptscsih_get_completion_code -
+ *	mptscsih_get_completion_code - get completion code from MPT request
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@req: Pointer to original MPT request frame
  *	@reply: Pointer to MPT reply frame (NULL if TurboReply)


-- 

