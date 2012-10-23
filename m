Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660Ab2JWVLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:11:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41025 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933661Ab2JWUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:04 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 025/193] arch/s390: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:38 -0700
Message-Id: <1351022666-6960-26-git-send-email-keescook@chromium.org>
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

CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/s390/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3f3d9ca..9bcbb8c 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -658,8 +658,8 @@ source "arch/s390/kvm/Kconfig"
 
 config S390_GUEST
 	def_bool y
-	prompt "s390 support for virtio devices (EXPERIMENTAL)"
-	depends on 64BIT && EXPERIMENTAL
+	prompt "s390 support for virtio devices"
+	depends on 64BIT
 	select VIRTUALIZATION
 	select VIRTIO
 	select VIRTIO_CONSOLE
-- 
1.7.9.5

