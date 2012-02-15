Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2BORzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:55:35 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41671 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041Ab2BORzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:55:33 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Danny Kukawka <dkukawka@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of/fdt.c: asm/setup.h included twice
Date: Wed, 15 Feb 2012 18:55:28 +0100
Message-Id: <1329328528-4847-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329328533;81600313;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/of/fdt.c included 'asm/setup.h' twice, remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/of/fdt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ea2bd1b..91a375f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -23,7 +23,6 @@
 #include <asm/machdep.h>
 #endif /* CONFIG_PPC */
 
-#include <asm/setup.h>
 #include <asm/page.h>
 
 char *of_fdt_get_string(struct boot_param_header *blob, u32 offset)
-- 
1.7.8.3

