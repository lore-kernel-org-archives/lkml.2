Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1A1Trj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:47:39 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37155 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab1A1Trf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nvizihddOp9/wmw5VfEZhbDS3DCa4HewHSgTlaTncmn0ebo0JxlFhcjsMRhI/bdrda
         z+75wlw/hsnMxhBcC8w+7+jCcAz7tAtKbV16t7g+eu+Y/dnJGklLWIqEU3MMASJCmZ9F
         f2sOMNR2M4BESEppLF98/bCtrACUbZfwyeTLw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] arch:arm:mbox-db5500.c Change initate to initiate.
Date: Fri, 28 Jan 2011 11:47:20 -0800
Message-Id: <1296244040-3653-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a typo or not. if it is then feel free to take this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-ux500/mbox-db5500.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ux500/mbox-db5500.c b/arch/arm/mach-ux500/mbox-db5500.c
index cbf1571..a4ffb9f 100644
--- a/arch/arm/mach-ux500/mbox-db5500.c
+++ b/arch/arm/mach-ux500/mbox-db5500.c
@@ -498,7 +498,7 @@ struct mbox *mbox_setup(u8 mbox_id, mbox_recv_cb_t *mbox_cb, void *priv)
 #endif
 
 	dev_info(&(mbox->pdev->dev),
-		 "Mailbox driver with index %d initated!\n", mbox_id);
+		 "Mailbox driver with index %d initiated!\n", mbox_id);
 
 exit:
 	return mbox;
-- 
1.6.5.GIT

