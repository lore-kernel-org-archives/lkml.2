Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0JZNDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:03:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0JZNDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=wruJIjIaukiML7s1T+cIaP/Vyqysv25RNxHEdhIuxjsz1YlQhYmdIZCDnA2o1TnRxX
         7SZ5wa6Sh81WdUlXlvqnK1P87gxW0juu1Oih62ZhaFSTudK3zHjEK4ieTDCUOBDbyObh
         gD8kf2P5NtsdBGAAP0D35hn/pSK/0OwNppobQ=
Subject: [PATCH]mmu_notifier.h: clean up comment
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 21:01:47 +0800
Message-ID: <1288098107.3221.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up comment for mmu_notifier.h. 

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
include/linux/mmu_notifier.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 4e02ee2..43dcfbd 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -227,7 +227,7 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 
 /*
  * These two macros will sometime replace ptep_clear_flush.
- * ptep_clear_flush is impleemnted as macro itself, so this also is
+ * ptep_clear_flush is implemented as macro itself, so this also is
  * implemented as a macro until ptep_clear_flush will converted to an
  * inline function, to diminish the risk of compilation failure. The
  * invalidate_page method over time can be moved outside the PT lock


