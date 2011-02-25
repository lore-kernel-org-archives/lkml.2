Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab1BYGKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:10:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59536 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1BYGKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:10:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kWrsTsLzv++7rX3jwg8am/4djbqJSrnLSIvS8c8w2xEpVK8KV1G0yQb9hmAULdVXw9
         bsBBsuZJJm3FIqcxVFT/gp4WQf+1occK/S1m03gmHbhl5wzZB/qJD8eViUnNH+3ugdQM
         QgZJKHNQbUsSQnCHnIS3VG9XCmpBORo55L8HA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/21]arch:powerpc:eeh.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:10:18 -0800
Message-Id: <1298614218-3532-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/powerpc/platforms/pseries/eeh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 17a11c8..3cc4d10 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -876,7 +876,7 @@ void eeh_restore_bars(struct pci_dn *pdn)
  *
  * Save the values of the device bars. Unlike the restore
  * routine, this routine is *not* recursive. This is because
- * PCI devices are added individuallly; but, for the restore,
+ * PCI devices are added individually; but, for the restore,
  * an entire slot is reset at a time.
  */
 static void eeh_save_bars(struct pci_dn *pdn)
-- 
1.7.4.1

