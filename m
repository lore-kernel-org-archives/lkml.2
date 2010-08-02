Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0HBUur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:50:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65109 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0HBUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=r1N9aO7sIP1QTyfBMlMkfCgzE0IrYPUiTzkHLTf8h2Wy3RwDzi3KdUyPjnBeg9bFAD
         HqPJQJmzcILV3EZwlsbXIR3yl4H3AR2c/s73Uf+5ryI+w9suDLFo0znWbx+wskE9MR/9
         zDW52r86UQqwlvv+LmdDwu6UTgSnBiEXmSYE4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]hostap:hostap_hw.c Fix typo.
Date: Mon,  2 Aug 2010 13:50:43 -0700
Message-Id: <1280782243-14778-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes a typo in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 2f999fc..e9d9d62 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -1896,7 +1896,7 @@ fail:
 /* Some SMP systems have reported number of odd errors with hostap_pci. fid
  * register has changed values between consecutive reads for an unknown reason.
  * This should really not happen, so more debugging is needed. This test
- * version is a big slower, but it will detect most of such register changes
+ * version is a bit slower, but it will detect most of such register changes
  * and will try to get the correct fid eventually. */
 #define EXTRA_FID_READ_TESTS
 
-- 
1.7.1.rc1.21.gf3bd6

