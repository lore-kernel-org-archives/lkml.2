Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab0HFS0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:26:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64187 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761758Ab0HFS0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ii6I4C4/wJIHaerSJeCRFLDr3wyjQcr5hSiSE7QB4fPCMB4uIVNeKzLaAQDeMeJOLO
         ZNz6ss5zTx+J9dw9cL2hZKqaTTPYOgnzylcv7dfl1HKWL3y93IszjinF8869U62eeNOM
         dJvjFhXaa3NExIp+Qg8KxYZmvtAi0tKRXPWHM=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] percpu: add missing markup in mm/slub_def.h
Date: Sat,  7 Aug 2010 03:26:26 +0900
Message-Id: <1281119187-12640-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/slub_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 4ba59cf..ccf2716 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -67,7 +67,7 @@ struct kmem_cache_order_objects {
  * Slab cache management.
  */
 struct kmem_cache {
-	struct kmem_cache_cpu *cpu_slab;
+	struct kmem_cache_cpu __percpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
 	unsigned long flags;
 	int size;		/* The size of an object including meta data */
-- 
1.7.0.4

