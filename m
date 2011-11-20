Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1KTVeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 16:34:19 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11210 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1KTVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 16:34:16 -0500
Date: Sun, 20 Nov 2011 22:34:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com
cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>, trivial@kernel.org
Subject: [PATCH][TRIVIAL] SCSI, qla2xxx: remove redundant semicolon
Message-ID: <alpine.LNX.2.00.1111202231550.17395@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One ';' at the end of the return statement is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 94bded5..b9b3e5a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1055,7 +1055,7 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
 		    "ROM lock failed.\n");
 		return -1;
 	}
-	return 0;;
+	return 0;
 }
 
 static int
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

