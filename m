Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab2K3RIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:08:12 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64692 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2K3RIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:08:09 -0500
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 12:08:09 EST
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 04/32] staging: wlags49_h2: ap_h25: corrects malformed #include warning
Date: Fri, 30 Nov 2012 18:58:29 +0200
Message-Id: <1354294737-5735-4-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extremely minor commit removes quotation marks from within a
comment so that the checkpatch.pl tool won't complain about the
line in question anymore.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/ap_h25.c b/drivers/staging/wlags49_h2/ap_h25.c
index 1c8f2be..454d01b 100644
--- a/drivers/staging/wlags49_h2/ap_h25.c
+++ b/drivers/staging/wlags49_h2/ap_h25.c
@@ -27,7 +27,7 @@
 #include "hcfcfg.h"		// to get hcf_16 etc defined as well as
 				// possible settings which inluence mdd.h or dhf.h
 #include "mdd.h"		// to get COMP_ID_STA etc defined
-#include "dhf.h"		// used to be "fhfmem.h", to get memblock,plugrecord,
+#include "dhf.h"		// used to be fhfmem.h, to get memblock,plugrecord,
 
 static const hcf_8 fw_image_1_data[] = {
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-- 
1.7.10.4

