Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab0IBVMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:12:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49676 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab0IBVMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UOL61iq48Z1RteNWqxesgKSjkUXjlPuIhNGYPsahBYGdr7YXjHacP7Z4aRv/NNIb8G
         jsEyUW5CYxXHjLzRIZ79bl8LJoxxb154q7obm0Zj/8vIhsMPS0xOn8oPJlBPtberadIn
         Ar6LVRbdIaHVUpuArhK5qhn5yScPbPieLgycU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 61/91] arch/mips/math-emu/ieee754xcpt.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:12:17 -0700
Message-Id: <1283461951-7988-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/math-emu/ieee754xcpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/math-emu/ieee754xcpt.c b/arch/mips/math-emu/ieee754xcpt.c
index e02423a..2399e44 100644
--- a/arch/mips/math-emu/ieee754xcpt.c
+++ b/arch/mips/math-emu/ieee754xcpt.c
@@ -1,7 +1,7 @@
 /*
  * MIPS floating point support
  * Copyright (C) 1994-2000 Algorithmics Ltd.
- * http://www.algor.co.uk
+ * http://www.mips.com/ 
  *
  * ########################################################################
  *
-- 
1.7.2.1

