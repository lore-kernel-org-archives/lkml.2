Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2EQKOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:14:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445Ab2EQKOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:14:31 -0400
From: Avi Kivity <avi@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] KVM: ia64: Mark ia64 KVM as BROKEN
Date: Thu, 17 May 2012 13:14:08 +0300
Message-Id: <1337249648-16894-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Practically all patches to ia64 KVM are build fixes; numerous warnings remain;
the last patch from the maintainer was committed more than three years ago.  It
is clear that no one is using this thing.

Mark as BROKEN to ensure people don't get hit by pointless build problems.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index 9806e55..df5351e 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -19,6 +19,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on BROKEN
 	depends on HAVE_KVM && MODULES && EXPERIMENTAL
 	# for device assignment:
 	depends on PCI
-- 
1.7.10.1

