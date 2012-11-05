Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab2KEX26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:28:58 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40916 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab2KEXFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:22 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 037/104] arch/s390: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:54 -0800
Message-Id: <1352156701-4038-38-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/s390/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5dba755..3c8a70e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -659,8 +659,8 @@ source "arch/s390/kvm/Kconfig"
 
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

