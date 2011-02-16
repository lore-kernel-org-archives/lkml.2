Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab1BPCJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:09:25 -0500
Received: from kroah.org ([198.145.64.141]:48826 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab1BPBtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:57 2011
Message-Id: <20110216014657.513336307@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        maximilian attems <max@stro.at>
Subject: [032/115] [S390] correct vdso version string
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 13c6680acb3df25722858566b42759215ea5d2e0 upstream.

The glibc vdso code for s390 uses the version string 2.6.29, the
kernel uses the version string 2.6.26. No wonder the vdso code
is never used. The first kernel version to contain the vdso code
is 2.6.29 which makes this the correct version.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/include/asm/vdso.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/vdso.h
+++ b/arch/s390/include/asm/vdso.h
@@ -7,7 +7,7 @@
 #define VDSO32_LBASE	0
 #define VDSO64_LBASE	0
 
-#define VDSO_VERSION_STRING	LINUX_2.6.26
+#define VDSO_VERSION_STRING	LINUX_2.6.29
 
 #ifndef __ASSEMBLY__
 


