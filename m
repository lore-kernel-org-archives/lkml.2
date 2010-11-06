Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0KFSwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:52:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47104 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0KFSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CeeGwoL2ye5XOho9t6fqydKVEhQbk4bu0GXcT2jKCkg7xPwXg/lUd6Qasv3ODSEtTx
         l8E08AesolcQqtNAVvoogzFjp8FrwGKjqdijb0u/ZBXbGANKoEPf7irFVowhYBeQeBH5
         0znFLgpNzh4ognbhk2e1b1StmQvQfWeTo9ZWM=
From: Tracey Dent <tdent48227@gmail.com>
To: avi@redhat.com
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] KVM x86: Makefile clean up
Date: Sat,  6 Nov 2010 14:52:58 -0400
Message-Id: <1289069578-1907-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed makefile to use the ccflags-y option instead of EXTRA_CFLAGS.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 arch/x86/kvm/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 31a7035..a851df9 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -1,5 +1,5 @@
 
-EXTRA_CFLAGS += -Ivirt/kvm -Iarch/x86/kvm
+ccflags-y += -Ivirt/kvm -Iarch/x86/kvm
 
 CFLAGS_x86.o := -I.
 CFLAGS_svm.o := -I.
-- 
1.7.3.2.146.gca209

