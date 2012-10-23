Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700Ab2JWVOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:14:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56134 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644Ab2JWUFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:01 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Xiantao Zhang <xiantao.zhang@intel.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 012/193] arch/ia64/kvm: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:25 -0700
Message-Id: <1351022666-6960-13-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Xiantao Zhang <xiantao.zhang@intel.com>
CC: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/ia64/kvm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index e794752..2cd225f 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -20,7 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on BROKEN
-	depends on HAVE_KVM && MODULES && EXPERIMENTAL
+	depends on HAVE_KVM && MODULES
 	# for device assignment:
 	depends on PCI
 	depends on BROKEN
-- 
1.7.9.5

