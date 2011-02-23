Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1BWFpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:45:40 -0500
Received: from mail.perches.com ([173.55.12.10]:3856 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab1BWFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:30 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] MAINTAINERS: Remove unnecessary linux-kernel@vger.kernel.org entries
Date: Tue, 22 Feb 2011 21:41:58 -0800
Message-Id: <03b0dc89c5badbc0b8f155ecdd5912cad3e278f2.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing lkml is the default and doesn't need separate entries.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fc5d548..1ecba76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2792,7 +2792,6 @@ F:	include/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 F:	Documentation/gpio/gpio.txt
@@ -2815,7 +2814,6 @@ F:	drivers/platform/x86/hdaps.c
 HWPOISON MEMORY FAILURE HANDLING
 M:	Andi Kleen <andi@firstfloor.org>
 L:	linux-mm@kvack.org
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
 S:	Maintained
 F:	mm/memory-failure.c
@@ -4692,7 +4690,6 @@ F:	drivers/i2c/busses/i2c-pasemi.c
 
 PADATA PARALLEL EXECUTION MECHANISM
 M:	Steffen Klassert <steffen.klassert@secunet.com>
-L:	linux-kernel@vger.kernel.org
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	kernel/padata.c
@@ -4842,7 +4839,6 @@ F:	include/crypto/pcrypt.h
 PER-CPU MEMORY ALLOCATOR
 M:	Tejun Heo <tj@kernel.org>
 M:	Christoph Lameter <cl@linux-foundation.org>
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
 S:	Maintained
 F:	include/linux/percpu*.h
@@ -6893,7 +6889,6 @@ F:	sound/soc/codecs/wm*
 
 WORKQUEUE
 M:	Tejun Heo <tj@kernel.org>
-L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
 S:	Maintained
 F:	include/linux/workqueue.h
-- 
1.7.4.rc3

