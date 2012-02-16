Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab2BPN4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:56:11 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51480 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000Ab2BPN4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:56:09 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Danny Kukawka <dkukawka@suse.de>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/powerpc/platforms/powernv/setup.c: included asm/xics.h twice
Date: Thu, 16 Feb 2012 14:56:03 +0100
Message-Id: <1329400563-31959-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400569;9a629392;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/powerpc/platforms/powernv/setup.c: included 'asm/xics.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/powerpc/platforms/powernv/setup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 467bd4a..db1ad1c 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -31,7 +31,6 @@
 #include <asm/xics.h>
 #include <asm/rtas.h>
 #include <asm/opal.h>
-#include <asm/xics.h>
 
 #include "powernv.h"
 
-- 
1.7.8.3

