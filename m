Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1DEQ6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:58:54 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:50643 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1DEQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WhVIeymw2EcgIFxRkhl7YlYy2DJT4vMHUVANIlJ5fmRwnDBf2NwYKhNlgRdzSSQ9BF
         Ea1lXj+N4PjIND2NEXsBY8u6O3OkiJDtXd4cdQTL0rT0dP3jroFOQkAZQdkpFsfadrKJ
         IoCvMdP9EZwVHYtbt0BbjHggjO38YHDeVDzBY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [RFC 2/5]arch:powerpc:sysdev:Makefile Remove unused config in the Makefile.
Date: Tue,  5 Apr 2011 09:58:19 -0700
Message-Id: <1302022702-24541-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused config variable found by using a kernel
cleanup script.
Note: I did try to cross compile these but hit erros while doing so..
(gcc is not setup to cross compile) and am unsure if anymore needs to be done.
Please have a look if/when anybody has free time.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org

---
 arch/powerpc/sysdev/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index 1e0c933..243b6ad 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -18,7 +18,6 @@ obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
 obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
 obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
 obj-$(CONFIG_MPC8xxx_GPIO)	+= mpc8xxx_gpio.o
-obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
 obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
 obj-$(CONFIG_FSL_RIO)		+= fsl_rio.o
 obj-$(CONFIG_TSI108_BRIDGE)	+= tsi108_pci.o tsi108_dev.o
-- 
1.7.4.2

