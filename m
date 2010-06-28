Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0F1LzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0F1LzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tZxqOqqBqSMyNuGIZn8X3KIcgFK5imV3xOZL1ViJM3pj3oLCve4p8miTtQxWJuDX1d
         s6dtKUTuO/YJ0edmVQDQejkLHX2gVzo3pHlafbHd1oEmfQdaIAPnbvripMrt78ITuOKk
         V37ZsluphvyH5WCaZ2DJoWRncKZPbGDy43rcg=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Krishna Gudipati <kgudipat@brocade.com>,
       Kulikov Vasiliy <segooon@gmail.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:04 +0400
Message-Id: <1277726105-24600-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/bfa/bfa_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 3a7b3f8..d845506 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -335,7 +335,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT},
 	};
 
-	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
+	*npciids = ARRAY_SIZE(__pciids);
 	*pciids = __pciids;
 }
 
-- 
1.7.0.4

