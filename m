Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab1LEUUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:20:41 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:34695 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab1LEUTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:19:09 -0500
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5 V5] Add generic stubs for kvm stop check functions
Date: Mon,  5 Dec 2011 15:19:03 -0500
Message-Id: <1323116344-17911-5-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: arnd@arndb.de
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: jeremy.fitzhardinge@citrix.com
Cc: levinsasha928@gmail.com
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/asm-generic/kvm_para.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/kvm_para.h

diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
new file mode 100644
index 0000000..177e1eb
--- /dev/null
+++ b/include/asm-generic/kvm_para.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_GENERIC_KVM_PARA_H
+#define _ASM_GENERIC_KVM_PARA_H
+
+
+/*
+ * This function is used by architectures that support kvm to avoid issuing
+ * false soft lockup messages.
+ */
+static inline bool kvm_check_and_clear_guest_paused(int cpu)
+{
+	return false;
+}
+
+#endif
-- 
1.7.5.4

