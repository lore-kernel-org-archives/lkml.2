Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1BBFH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:07:27 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58600 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1BBFHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oOgZg+PiTWfPzq+/IkEMBSIvBzDZoyR8ku0EjCLET09FjKWx0/BTwANCkIWzQzt0mW
         NQOBxfDVcJbrl8sJK7FrP5rm5qITFMa9V37KRWgJa0F23ySflBZQ8nJK6kpphqETPOwB
         Yj2YBPYcDsnk7hHGId99otwgRLNnn73vxPqgg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/8]drivers:block:smart1,2.h change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:07:09 -0800
Message-Id: <1296623229-5349-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/block/smart1,2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/smart1,2.h b/drivers/block/smart1,2.h
index a0b403a..e5565fb 100644
--- a/drivers/block/smart1,2.h
+++ b/drivers/block/smart1,2.h
@@ -95,7 +95,7 @@ static unsigned long smart4_completed(ctlr_info_t *h)
  /*
  *  This hardware returns interrupt pending at a different place and 
  *  it does not tell us if the fifo is empty, we will have check  
- *  that by getting a 0 back from the comamnd_completed call. 
+ *  that by getting a 0 back from the command_completed call. 
  */
 static unsigned long smart4_intr_pending(ctlr_info_t *h)
 {
-- 
1.6.5.GIT

