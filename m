Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0FZUrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 16:47:05 -0400
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:45111 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab0FZUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 16:47:04 -0400
X-Greylist: delayed 2648 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jun 2010 16:47:04 EDT
Subject: [PATCH] staging/easycap: Add dependencies to Kconfig
From: Mike Thomas <rmthomas@sciolus.org>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 26 Jun 2010 20:20:59 +0100
Message-Id: <1277580059.5924.9.camel@E7500.sciolus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "depends on" line was inadvertently omitted from the inaugural patch.

Signed-off-by: Mike Thomas <rmthomas@sciolus.org>
---
 drivers/staging/easycap/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/easycap/Kconfig b/drivers/staging/easycap/Kconfig
index 9bff7cf..bd96f39 100644
--- a/drivers/staging/easycap/Kconfig
+++ b/drivers/staging/easycap/Kconfig
@@ -1,5 +1,6 @@
 config EASYCAP
 	tristate "EasyCAP USB ID 05e1:0408 support"
+	depends on USB && VIDEO_DEV
 
 	---help---
 	  This is an integrated audio/video driver for EasyCAP cards with
-- 



