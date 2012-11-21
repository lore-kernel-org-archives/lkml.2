Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2KUPlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:41:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab2KUPlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:41:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] UAPI: (Scripted) Disintegrate include/scsi/fc
To: robert.w.love@intel.com
From: David Howells <dhowells@redhat.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2012 15:40:51 +0000
Message-ID: <20121121154051.9479.33391.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Dave Jones <davej@redhat.com>
---

 include/scsi/fc/Kbuild        |    4 ----
 include/uapi/scsi/fc/Kbuild   |    4 ++++
 include/uapi/scsi/fc/fc_els.h |    0 
 include/uapi/scsi/fc/fc_fs.h  |    0 
 include/uapi/scsi/fc/fc_gs.h  |    0 
 include/uapi/scsi/fc/fc_ns.h  |    0 
 6 files changed, 4 insertions(+), 4 deletions(-)
 rename include/{scsi/fc/fc_els.h => uapi/scsi/fc/fc_els.h} (100%)
 rename include/{scsi/fc/fc_fs.h => uapi/scsi/fc/fc_fs.h} (100%)
 rename include/{scsi/fc/fc_gs.h => uapi/scsi/fc/fc_gs.h} (100%)
 rename include/{scsi/fc/fc_ns.h => uapi/scsi/fc/fc_ns.h} (100%)

diff --git a/include/scsi/fc/Kbuild b/include/scsi/fc/Kbuild
index 5660381..e69de29 100644
--- a/include/scsi/fc/Kbuild
+++ b/include/scsi/fc/Kbuild
@@ -1,4 +0,0 @@
-header-y += fc_els.h
-header-y += fc_fs.h
-header-y += fc_gs.h
-header-y += fc_ns.h
diff --git a/include/uapi/scsi/fc/Kbuild b/include/uapi/scsi/fc/Kbuild
index aafaa5a..5ead9fa 100644
--- a/include/uapi/scsi/fc/Kbuild
+++ b/include/uapi/scsi/fc/Kbuild
@@ -1 +1,5 @@
 # UAPI Header export list
+header-y += fc_els.h
+header-y += fc_fs.h
+header-y += fc_gs.h
+header-y += fc_ns.h
diff --git a/include/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
similarity index 100%
rename from include/scsi/fc/fc_els.h
rename to include/uapi/scsi/fc/fc_els.h
diff --git a/include/scsi/fc/fc_fs.h b/include/uapi/scsi/fc/fc_fs.h
similarity index 100%
rename from include/scsi/fc/fc_fs.h
rename to include/uapi/scsi/fc/fc_fs.h
diff --git a/include/scsi/fc/fc_gs.h b/include/uapi/scsi/fc/fc_gs.h
similarity index 100%
rename from include/scsi/fc/fc_gs.h
rename to include/uapi/scsi/fc/fc_gs.h
diff --git a/include/scsi/fc/fc_ns.h b/include/uapi/scsi/fc/fc_ns.h
similarity index 100%
rename from include/scsi/fc/fc_ns.h
rename to include/uapi/scsi/fc/fc_ns.h

