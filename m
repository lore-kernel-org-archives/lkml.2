Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab1KJNKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:10:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59850 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934179Ab1KJNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:10:09 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ce4100: fix a build error
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 13:21:10 +0000
Message-ID: <20111110132107.14762.18160.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Fix a build error. CE4100 with no serial errors because the alternate
function is only a prototype not a null function as intended.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/ce4100/ce4100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 28071bb..4c61b52 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -109,7 +109,7 @@ static __init void sdv_serial_fixup(void)
 }
 
 #else
-static inline void sdv_serial_fixup(void);
+static inline void sdv_serial_fixup(void) {};
 #endif
 
 static void __init sdv_arch_setup(void)

