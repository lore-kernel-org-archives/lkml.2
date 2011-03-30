Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab1C3RBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:01:32 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:40054 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab1C3RBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YJ77uVrd2SNW7vLad46Kp48VPH1SUpAEaMSw5WFLEK3o7eaC93tk0slofjgG0WIxGE
         PsaXrcDjADTin/d4BrnOLhw/9IcXf1JxTXjit2pKW2Mhd2BnJXv0ZjZnqFsJsbiHwq/A
         2nVWP2Gdapk/lgPYCI/TO85dpwnBoCz9PN3rA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/5]drivers: Typo change teh to the.
Date: Wed, 30 Mar 2011 10:01:14 -0700
Message-Id: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes some typos in various parts of the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/infiniband/hw/qib/qib_twsi.c      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c              |    2 +-
 drivers/staging/octeon/cvmx-helper-util.c |    2 +-
 fs/notify/inotify/inotify_fsnotify.c      |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_twsi.c b/drivers/infiniband/hw/qib/qib_twsi.c
index 6f31ca5..ddde72e 100644
--- a/drivers/infiniband/hw/qib/qib_twsi.c
+++ b/drivers/infiniband/hw/qib/qib_twsi.c
@@ -41,7 +41,7 @@
  * QLogic_IB "Two Wire Serial Interface" driver.
  * Originally written for a not-quite-i2c serial eeprom, which is
  * still used on some supported boards. Later boards have added a
- * variety of other uses, most board-specific, so teh bit-boffing
+ * variety of other uses, most board-specific, so the bit-boffing
  * part has been split off to this file, while the other parts
  * have been moved to chip-specific files.
  *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4746dcd..7dab966 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3040,7 +3040,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
 	pring->iocb_continueq_cnt++;
 
-	/* Now, determine whetehr the list is completed for processing */
+	/* Now, determine whether the list is completed for processing */
 	irsp = &rspiocbp->iocb;
 	if (irsp->ulpLe) {
 		/*
diff --git a/drivers/staging/octeon/cvmx-helper-util.c b/drivers/staging/octeon/cvmx-helper-util.c
index 41ef8a4..131182b 100644
--- a/drivers/staging/octeon/cvmx-helper-util.c
+++ b/drivers/staging/octeon/cvmx-helper-util.c
@@ -362,7 +362,7 @@ int __cvmx_helper_setup_gmx(int interface, int num_ports)
 }
 
 /**
- * Returns the IPD/PKO port number for a port on teh given
+ * Returns the IPD/PKO port number for a port on the given
  * interface.
  *
  * @interface: Interface to use
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index a91b69a..7400898 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -194,7 +194,7 @@ static int idr_callback(int id, void *p, void *data)
 
 static void inotify_free_group_priv(struct fsnotify_group *group)
 {
-	/* ideally the idr is empty and we won't hit the BUG in teh callback */
+	/* ideally the idr is empty and we won't hit the BUG in the callback */
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
-- 
1.7.4.1

