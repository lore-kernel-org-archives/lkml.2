Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab2KEXFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:46 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43348 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab2KEXFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:40 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anna-Maria Gleixner <anna-maria@glx-um.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 024/104] arch/alpha: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:41 -0800
Message-Id: <1352156701-4038-25-git-send-email-keescook@chromium.org>
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

CC: Richard Henderson <rth@twiddle.net>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matt Turner <mattst88@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>
CC: Anna-Maria Gleixner <anna-maria@glx-um.de>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/alpha/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 5dd7f5d..65ec1c8 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -557,8 +557,7 @@ config NR_CPUS
           with working support have a maximum of 4 CPUs.
 
 config ARCH_DISCONTIGMEM_ENABLE
-	bool "Discontiguous Memory Support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Discontiguous Memory Support"
 	help
 	  Say Y to support efficient handling of discontiguous physical memory,
 	  for architectures which are either NUMA (Non-Uniform Memory Access)
-- 
1.7.9.5

