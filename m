Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2JQOP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280Ab2JQOPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/10] UAPI: Remove empty conditionals from
 include/linux/Kbuild
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Wed, 17 Oct 2012 15:15:43 +0100
Message-ID: <20121017141543.29084.79155.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove empty conditionals from include/linux/Kbuild as the contents, with new
conditionals, have moved to include/uapi/linux/Kbuild.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/Kbuild |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 5b57367..7729c58 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -19,13 +19,3 @@ header-y += netfilter_ipv4/
 header-y += netfilter_ipv6/
 header-y += usb/
 header-y += wimax/
-
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/arch/$(SRCARCH)/include/uapi/asm/a.out.h),)
-endif
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm.h),)
-endif
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/arch/$(SRCARCH)/include/uapi/asm/kvm_para.h),)
-endif

