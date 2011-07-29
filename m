Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1G2WpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:45:13 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.93]:47295 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1G2WpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:45:12 -0400
Date: Sat, 30 Jul 2011 00:45:08 +0200
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
        Peter Feuerer <peter@piie.net>
Subject: [PATCH 1/3] acerhdf.c: spaces in aliased changed to *
Message-Id: <20110730004508.911be745.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Anton V. Boyarshinov" <boyarsh@altlinux.org>

Subject: [PATCH 1/3] acerhdf.c: spaces in aliased changed to *

It seems that aliases shouldn't contain spaces, as
module-init-tools uses them as delimeters in module.alias file

Signed-off-by: Anton V. Boyarshinov <boyarsh@altlinux.org>
Acked-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index fca3489..7a8568b 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -703,15 +703,15 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
-MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
-MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMU*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMA*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOA*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMU*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMA*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
-- 
1.7.6

