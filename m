Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1DEQ7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:59:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55450 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab1DEQ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mOLMwmv8EAvv7u+DoFq72q3Oj9eOtuo+HhgVHX2PQwJKE7kMWa7oRApCPOzR++oGF3
         kXuE5oCQzr+Nu/Xy6czmOCltwnXMxbbiEawaIBy6oFdDoeiUg0ScTDd+EKjcHJj7X0Wq
         B5FaJLcPBUrE1RgOD2utSUPLHFODN2n6SW9zs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        David Howells <dhowells@redhat.com>, linux-am33-list@redhat.com
Subject: [RFC 4/5]arch:mn10300:kernel:Makefile Remove unused config in the Makefile.
Date: Tue,  5 Apr 2011 09:58:21 -0700
Message-Id: <1302022702-24541-4-git-send-email-justinmattock@gmail.com>
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
CC: David Howells <dhowells@redhat.com> 
CC: linux-am33-list@redhat.com

---
 arch/mn10300/kernel/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index 47ed30f..74b20ad 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_GDBSTUB_ON_TTYSx) += gdb-io-serial.o gdb-io-serial-low.o
 obj-$(CONFIG_GDBSTUB_ON_TTYSMx) += gdb-io-ttysm.o gdb-io-ttysm-low.o
 
 obj-$(CONFIG_MN10300_RTC) += rtc.o
-obj-$(CONFIG_PROFILE) += profile.o profile-low.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
-- 
1.7.4.2

