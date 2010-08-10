Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab0HJEmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:42:49 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:14556 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0HJEmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:42:44 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH]pid.c: remove unused header files
Date: Tue, 10 Aug 2010 12:42:24 +0800
Message-ID: <14414B36FFA0F1418CB707361EAA199A01987804@CNBEEXC006.nsn-intra.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]pid.c: remove unused header files
Thread-Index: Acs4Rm11DAhjkIVxRKyuc+rQMLISSA==
From: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Aug 2010 04:42:26.0988 (UTC) FILETIME=[6EE9E6C0:01CB3846]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]pid.c: remove unused header files

git diff kernel/pid.c
diff --git a/kernel/pid.c b/kernel/pid.c
index e9fd8c1..97fa0b7 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -27,15 +27,12 @@
  */
 
 #include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/rculist.h>
 #include <linux/bootmem.h>
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
 #include <linux/init_task.h>
-#include <linux/syscalls.h>
 
 #define pid_hashfn(nr, ns)     \
        hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
