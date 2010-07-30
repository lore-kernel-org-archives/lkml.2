Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0G3R5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:33 -0400
Received: from kroah.org ([198.145.64.141]:58692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932580Ab0G3R4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:43 2010
Message-Id: <20100730175143.538252486@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Vorontsov <avorontsov@mvista.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [107/205] edac: mpc85xx: fix MPC85xx dependency
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <avorontsov@mvista.com>

commit 1cd8521e7d77def75fdb1cb35ecd135385e4be4f upstream.

Since commit 5753c082f66eca5be81f6bda85c1718c5eea6ada ("powerpc/85xx:
Kconfig cleanup"), there is no MPC85xx Kconfig symbol anymore, so the
driver became non-selectable.

This patch fixes the issue by switching to PPC_85xx symbol.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -196,7 +196,7 @@ config EDAC_I5100
 
 config EDAC_MPC85XX
 	tristate "Freescale MPC83xx / MPC85xx"
-	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
+	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || PPC_85xx)
 	help
 	  Support for error detection and correction on the Freescale
 	  MPC8349, MPC8560, MPC8540, MPC8548


