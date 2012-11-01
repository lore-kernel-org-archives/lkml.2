Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab2KATrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:47:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48985 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935175Ab2KATrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:47:02 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Will Drewry <wad@chromium.org>, Geremy Condra <gcondra@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/4] arch/arm: select HAVE_ARCH_SECCOMP_FILTER
Date: Thu,  1 Nov 2012 12:46:39 -0700
Message-Id: <1351799199-6853-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351799199-6853-1-git-send-email-keescook@chromium.org>
References: <1351799199-6853-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>

Reflect architectural support for seccomp filter.

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ade7e92..0e8d490 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -21,6 +21,7 @@ config ARM
 	select HAVE_AOUT
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
 	select HAVE_C_RECORDMCOUNT
-- 
1.7.9.5

