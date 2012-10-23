Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965669Ab2JWVLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:11:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52747 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab2JWUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:04 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 028/193] arch/tile/kvm: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:41 -0700
Message-Id: <1351022666-6960-29-git-send-email-keescook@chromium.org>
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

CC: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/tile/kvm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kvm/Kconfig b/arch/tile/kvm/Kconfig
index 669fcdb..2298cb1 100644
--- a/arch/tile/kvm/Kconfig
+++ b/arch/tile/kvm/Kconfig
@@ -18,7 +18,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM && MODULES && EXPERIMENTAL
+	depends on HAVE_KVM && MODULES
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
-- 
1.7.9.5

