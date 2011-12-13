Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1LMKkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:40:03 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52178 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1LMKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:00 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 12/17] UAPI: Alter the S390 asm include guards to be recognisable by the UAPI splitter
Date: Tue, 13 Dec 2011 10:04:08 +0000
Message-Id: <1323770653-19177-13-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alter some of the S390 asm include guards to fit a pattern that the UAPI
splitter recognises.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 arch/s390/include/asm/chpid.h |    2 +-
 arch/s390/include/asm/itcw.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/chpid.h b/arch/s390/include/asm/chpid.h
index fc71d8a..8e88e22 100644
--- a/arch/s390/include/asm/chpid.h
+++ b/arch/s390/include/asm/chpid.h
@@ -6,7 +6,7 @@
  */
 
 #ifndef _ASM_S390_CHPID_H
-#define _ASM_S390_CHPID_H _ASM_S390_CHPID_H
+#define _ASM_S390_CHPID_H
 
 #include <linux/string.h>
 #include <linux/types.h>
diff --git a/arch/s390/include/asm/itcw.h b/arch/s390/include/asm/itcw.h
index a9bc5c3..fb1bedd 100644
--- a/arch/s390/include/asm/itcw.h
+++ b/arch/s390/include/asm/itcw.h
@@ -6,7 +6,7 @@
  */
 
 #ifndef _ASM_S390_ITCW_H
-#define _ASM_S390_ITCW_H _ASM_S390_ITCW_H
+#define _ASM_S390_ITCW_H
 
 #include <linux/types.h>
 #include <asm/fcx.h>
-- 
1.7.7.4

