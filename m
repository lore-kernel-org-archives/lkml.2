Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab1LMKji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:39:38 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52116 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1LMKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:39:35 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 11/17] UAPI: Guard linux/cuda.h
Date: Tue, 13 Dec 2011 10:04:07 +0000
Message-Id: <1323770653-19177-12-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place reinclusion guards on linux/cuda.h otherwise the UAPI splitter script
won't insert a #include to make the kernel header include the UAPI header.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/linux/cuda.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/cuda.h b/include/linux/cuda.h
index 6a3e638..9f9865f 100644
--- a/include/linux/cuda.h
+++ b/include/linux/cuda.h
@@ -5,6 +5,9 @@
  * Copyright (C) 1996 Paul Mackerras.
  */
 
+#ifndef _LINUX_CUDA_H
+#define _LINUX_CUDA_H
+
 /* CUDA commands (2nd byte) */
 #define CUDA_WARM_START		0
 #define CUDA_AUTOPOLL		1
@@ -34,3 +37,5 @@ extern int cuda_request(struct adb_request *req,
 extern void cuda_poll(void);
 
 #endif	/* __KERNEL */
+
+#endif /* _LINUX_CUDA_H */
-- 
1.7.7.4

