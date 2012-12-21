Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2LUMss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 07:48:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2LUMsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 07:48:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/2] UAPI: Remove empty Kbuild files
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 12:48:40 +0000
Message-ID: <20121221124840.9484.93112.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Empty files can get deleted by the patch program, so remove empty Kbuild files
and their links from the parent Kbuilds.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/Kbuild            |    3 ---
 include/linux/Kbuild      |    5 -----
 include/linux/hdlc/Kbuild |    0 
 include/linux/hsi/Kbuild  |    0 
 include/linux/raid/Kbuild |    0 
 include/linux/usb/Kbuild  |    0 
 include/rdma/Kbuild       |    0 
 include/sound/Kbuild      |    0 
 8 files changed, 8 deletions(-)
 delete mode 100644 include/linux/Kbuild
 delete mode 100644 include/linux/hdlc/Kbuild
 delete mode 100644 include/linux/hsi/Kbuild
 delete mode 100644 include/linux/raid/Kbuild
 delete mode 100644 include/linux/usb/Kbuild
 delete mode 100644 include/rdma/Kbuild
 delete mode 100644 include/sound/Kbuild

diff --git a/include/Kbuild b/include/Kbuild
index 83256b6..1dfd33e 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -1,8 +1,5 @@
 # Top-level Makefile calls into asm-$(ARCH)
 # List only non-arch directories below
 
-header-y += linux/
-header-y += sound/
-header-y += rdma/
 header-y += video/
 header-y += scsi/
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
deleted file mode 100644
index 7fe2dae..0000000
--- a/include/linux/Kbuild
+++ /dev/null
@@ -1,5 +0,0 @@
-header-y += dvb/
-header-y += hdlc/
-header-y += hsi/
-header-y += raid/
-header-y += usb/
diff --git a/include/linux/hdlc/Kbuild b/include/linux/hdlc/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/hsi/Kbuild b/include/linux/hsi/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/raid/Kbuild b/include/linux/raid/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/usb/Kbuild b/include/linux/usb/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/rdma/Kbuild b/include/rdma/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/sound/Kbuild b/include/sound/Kbuild
deleted file mode 100644
index e69de29..0000000

