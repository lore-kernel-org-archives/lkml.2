Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2JQORw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:17:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab2JQOPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/10] UAPI: Remove empty non-UAPI Kbuild files
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Wed, 17 Oct 2012 15:15:51 +0100
Message-ID: <20121017141550.29084.28637.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove non-UAPI Kbuild files that have become empty as a result of UAPI
disintegration.  They used to have only header-y lines in them and those have
now moved to the Kbuild files in the corresponding uapi/ directories.

Possibly these should not be removed but rather have a comment inserted to say
they are intentionally left blank.  This would make it easier to add generated
header lines in future without having to restore the infrastructure.

Note that at this point not all the UAPI disintegration parts have been merged,
so it is likely that more empty Kbuild files will turn up.

It is probably necessary to make the files non-empty to prevent the patch
program from automatically deleting them when it reduces them to nothing.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/Kbuild                        |    4 ----
 include/asm-generic/Kbuild            |    0 
 include/drm/Kbuild                    |    0 
 include/linux/Kbuild                  |   16 ----------------
 include/linux/byteorder/Kbuild        |    0 
 include/linux/caif/Kbuild             |    0 
 include/linux/can/Kbuild              |    0 
 include/linux/isdn/Kbuild             |    0 
 include/linux/mmc/Kbuild              |    0 
 include/linux/netfilter/Kbuild        |    1 -
 include/linux/netfilter/ipset/Kbuild  |    0 
 include/linux/netfilter_arp/Kbuild    |    0 
 include/linux/netfilter_bridge/Kbuild |    0 
 include/linux/netfilter_ipv4/Kbuild   |    0 
 include/linux/netfilter_ipv6/Kbuild   |    0 
 include/linux/nfsd/Kbuild             |    0 
 include/linux/spi/Kbuild              |    0 
 include/linux/sunrpc/Kbuild           |    0 
 include/linux/tc_act/Kbuild           |    0 
 include/linux/tc_ematch/Kbuild        |    0 
 include/linux/wimax/Kbuild            |    0 
 include/mtd/Kbuild                    |    0 
 include/xen/Kbuild                    |    0 
 23 files changed, 21 deletions(-)
 delete mode 100644 include/asm-generic/Kbuild
 delete mode 100644 include/drm/Kbuild
 delete mode 100644 include/linux/byteorder/Kbuild
 delete mode 100644 include/linux/caif/Kbuild
 delete mode 100644 include/linux/can/Kbuild
 delete mode 100644 include/linux/isdn/Kbuild
 delete mode 100644 include/linux/mmc/Kbuild
 delete mode 100644 include/linux/netfilter/Kbuild
 delete mode 100644 include/linux/netfilter/ipset/Kbuild
 delete mode 100644 include/linux/netfilter_arp/Kbuild
 delete mode 100644 include/linux/netfilter_bridge/Kbuild
 delete mode 100644 include/linux/netfilter_ipv4/Kbuild
 delete mode 100644 include/linux/netfilter_ipv6/Kbuild
 delete mode 100644 include/linux/nfsd/Kbuild
 delete mode 100644 include/linux/spi/Kbuild
 delete mode 100644 include/linux/sunrpc/Kbuild
 delete mode 100644 include/linux/tc_act/Kbuild
 delete mode 100644 include/linux/tc_ematch/Kbuild
 delete mode 100644 include/linux/wimax/Kbuild
 delete mode 100644 include/mtd/Kbuild
 delete mode 100644 include/xen/Kbuild

diff --git a/include/Kbuild b/include/Kbuild
index 8d226bf..83256b6 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -1,12 +1,8 @@
 # Top-level Makefile calls into asm-$(ARCH)
 # List only non-arch directories below
 
-header-y += asm-generic/
 header-y += linux/
 header-y += sound/
-header-y += mtd/
 header-y += rdma/
 header-y += video/
-header-y += drm/
-header-y += xen/
 header-y += scsi/
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/drm/Kbuild b/include/drm/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 7729c58..7fe2dae 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -1,21 +1,5 @@
-header-y += byteorder/
-header-y += can/
-header-y += caif/
 header-y += dvb/
 header-y += hdlc/
 header-y += hsi/
-header-y += isdn/
-header-y += mmc/
-header-y += nfsd/
 header-y += raid/
-header-y += spi/
-header-y += sunrpc/
-header-y += tc_act/
-header-y += tc_ematch/
-header-y += netfilter/
-header-y += netfilter_arp/
-header-y += netfilter_bridge/
-header-y += netfilter_ipv4/
-header-y += netfilter_ipv6/
 header-y += usb/
-header-y += wimax/
diff --git a/include/linux/byteorder/Kbuild b/include/linux/byteorder/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/caif/Kbuild b/include/linux/caif/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/can/Kbuild b/include/linux/can/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/isdn/Kbuild b/include/linux/isdn/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/mmc/Kbuild b/include/linux/mmc/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
deleted file mode 100644
index b332202..0000000
--- a/include/linux/netfilter/Kbuild
+++ /dev/null
@@ -1 +0,0 @@
-header-y += ipset/
diff --git a/include/linux/netfilter/ipset/Kbuild b/include/linux/netfilter/ipset/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/netfilter_arp/Kbuild b/include/linux/netfilter_arp/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/netfilter_bridge/Kbuild b/include/linux/netfilter_bridge/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/nfsd/Kbuild b/include/linux/nfsd/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/spi/Kbuild b/include/linux/spi/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/sunrpc/Kbuild b/include/linux/sunrpc/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/tc_act/Kbuild b/include/linux/tc_act/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/tc_ematch/Kbuild b/include/linux/tc_ematch/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/wimax/Kbuild b/include/linux/wimax/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/mtd/Kbuild b/include/mtd/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/xen/Kbuild b/include/xen/Kbuild
deleted file mode 100644
index e69de29..0000000

