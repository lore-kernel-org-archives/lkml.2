Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1BBFIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:08:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43904 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BBFIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BUqaJRK9tEqK13RZQg2UzStZY7YLu2bGvqPaaU3e73W/hWyOxeXSFDnve66822EkeR
         AE9O84CE+25NYQBA4X5CHYPOwNLMJmfrMaduPT6U8DLxATvnoWo0Tj9+rlZCHJ2ijzvR
         x0klhO7AMP6clg9t/Zb+Byzr8A5q/VGgjctEk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 7/8]drivers:staging:rt2860:cmm_mac_pci.c change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:07:49 -0800
Message-Id: <1296623269-5450-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rt2860/common/cmm_mac_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rt2860/common/cmm_mac_pci.c b/drivers/staging/rt2860/common/cmm_mac_pci.c
index 850f0fb..21eed25 100644
--- a/drivers/staging/rt2860/common/cmm_mac_pci.c
+++ b/drivers/staging/rt2860/common/cmm_mac_pci.c
@@ -753,7 +753,7 @@ BOOLEAN AsicCheckCommanOk(struct rt_rtmp_adapter *pAd, u8 Command)
 
 	/* This command's status is at the same position as command. So AND command position's bitmask to read status. */
 	if (i < 200) {
-		/* If Status is 1, the comamnd is success. */
+		/* If Status is 1, the command is success. */
 		if (((CmdStatus & ThisCIDMask) == 0x1)
 		    || ((CmdStatus & ThisCIDMask) == 0x100)
 		    || ((CmdStatus & ThisCIDMask) == 0x10000)
-- 
1.6.5.GIT

