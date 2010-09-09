Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0IIWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:25:53 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:39116 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab0IIWZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DLAAbbVXwjx2LDQ/tkkYgus0JvAl9j3A1c2pYWHFzT6jVYN1RPTUOPkeVof2cU59wS
         QupPyUxFk2+4pFyIm4/GHTaB8jr50Cbpyph4ogEAG8ZFE28IXN5gvHACOkR5p4s/Jy3J
         jYviqRqoJPLEKwYMxZf2dcD1zzk/37uZR5bzM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 027/223]drivers/ide/hpt366.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:25:46 -0700
Message-Id: <1284071149-7723-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
References: <1284071149-7723-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/ide/hpt366.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index 4516369..d876275 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -12,7 +12,7 @@
  *
  *
  * HighPoint has its own drivers (open source except for the RAID part)
- * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.
+ * available from http://www.highpoint-tech.com/.
  * This may be useful to anyone wanting to work on this driver, however  do not
  * trust  them too much since the code tends to become less and less meaningful
  * as the time passes... :-/
-- 
1.7.2.1

