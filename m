Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1DEQ7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:59:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47412 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1DEQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xzD95dP2i2vAJv5GqFhq+pZu6f2bL9NjjqX+tXA7EdUw0sY5wIo3OjnYmYjZ60Lx2l
         8L4v33621sc+swtLFa8Eq7h1O3ISPvWXh1+uXpT+Dnaz18QOHGgMPlHqdKoWTEq9ZfdN
         xhO2RGwumFaOwzYhaTJsIxrmYrZcpFQHcgu3w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [RFC 5/5]arch:powerpc:kernel:Makefile Remove unused config in the Makefile.
Date: Tue,  5 Apr 2011 09:58:22 -0700
Message-Id: <1302022702-24541-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused config variable found by using a kernel
cleanup script.
Note: I did try to cross compile these but hit erros while doing so..
(gcc is not setup to cross compile) and am unsure if anymore needs to be done.
Please have a look if/when anybody has free time.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org

---
 arch/powerpc/kernel/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 3bb2a3e..4fa0d52 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -75,7 +75,6 @@ obj-$(CONFIG_PPC_FSL_BOOK3E)	+= cpu_setup_fsl_booke.o dbell.o
 obj-$(CONFIG_PPC_BOOK3E_64)	+= dbell.o
 
 extra-y				:= head_$(CONFIG_WORD_SIZE).o
-extra-$(CONFIG_PPC_BOOK3E_32)	:= head_new_booke.o
 extra-$(CONFIG_40x)		:= head_40x.o
 extra-$(CONFIG_44x)		:= head_44x.o
 extra-$(CONFIG_FSL_BOOKE)	:= head_fsl_booke.o
-- 
1.7.4.2

