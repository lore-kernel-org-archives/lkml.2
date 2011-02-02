Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1BBFHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:07:02 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:38710 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1BBFHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cbQCoB8uEtdNOUvVez31ANYEtnnIrnDrg9T49OQNg789lT8vOR/rDi+X4hZbHD3XoI
         exEYtH/LI65bBCrS2MYIA3uCmq7TTJDB1BFk8ObPioPA4TZqpX25PTVOJcjBRL9IvyEu
         QsDPosCrOgHlIkV2BPDFgth7EuKhyS6qQvDnM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 4/8]drivers:atm:firestream.c change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:06:45 -0800
Message-Id: <1296623205-5296-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/atm/firestream.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 7d912ba..049650d 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1031,7 +1031,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 		/* We now use the "submit_command" function to submit commands to
 		   the firestream. There is a define up near the definition of
 		   that routine that switches this routine between immediate write
-		   to the immediate comamnd registers and queuing the commands in
+		   to the immediate command registers and queuing the commands in
 		   the HPTXQ for execution. This last technique might be more
 		   efficient if we know we're going to submit a whole lot of
 		   commands in one go, but this driver is not setup to be able to
-- 
1.6.5.GIT

