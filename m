Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0HKCYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:24:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58197 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab0HKCYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XvEjZMI2gcV4dOLky4AEcKNEvO9TbGMoZIrj8huCqTOh26xzbq2/ne8hcI1GEviICt
         G2+YshZvD/PGDdvorWDxmFjZDXoU+h/g/0SMTYGAleSYbHsp9kLJr8HGloOSUqLR0P51
         b93w6jR/6bIavGJZicnbgrrvip/nN5imnJII8=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix a typo on comments in mm/percpu.c
Date: Wed, 11 Aug 2010 11:24:10 +0900
Message-Id: <1281493450-2685-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'eqaul' should be 'equal'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 5e78131..3ec4dc9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -31,7 +31,7 @@
  * as small as 4 bytes.  The allocator organizes chunks into lists
  * according to free size and tries to allocate from the fullest one.
  * Each chunk keeps the maximum contiguous area size hint which is
- * guaranteed to be eqaul to or larger than the maximum contiguous
+ * guaranteed to be equal to or larger than the maximum contiguous
  * area in the chunk.  This helps the allocator not to iterate the
  * chunk maps unnecessarily.
  *
-- 
1.7.0.4

