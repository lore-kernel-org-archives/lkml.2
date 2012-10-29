Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271Ab2J2SI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:08:28 -0400
Received: from 8bytes.org ([85.214.48.195]:59555 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759825Ab2J2SIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:08:25 -0400
From: Joerg Roedel <joro@8bytes.org>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/2] kvm, svm: Update MAINTAINERS entry
Date: Mon, 29 Oct 2012 19:08:21 +0100
Message-Id: <1351534101-28578-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Oct 29 19:08:24 2012
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 508ec61822971498816730
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no access to my AMD email address anymore. Update
entry in MAINTAINERS to the new address.

Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0267ba2..d881321 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4234,10 +4234,10 @@ F:	include/linux/kvm*
 F:	virt/kvm/
 
 KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
-M:	Joerg Roedel <joerg.roedel@amd.com>
+M:	Joerg Roedel <joro@8bytes.org>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
-S:	Supported
+S:	Maintained
 F:	arch/x86/include/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
-- 
1.7.9.5


