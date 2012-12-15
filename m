Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab2LOGDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:03:45 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55577 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802Ab2LOGDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:03:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 1/6] staging/fwserial: Refine Kconfig help text
Date: Sat, 15 Dec 2012 01:03:15 -0500
Message-Id: <1355551400-8204-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users should be informed upfront that this is a Linux-only affair
currently.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/fwserial/Kconfig b/drivers/staging/fwserial/Kconfig
index 580406c..b2f8331 100644
--- a/drivers/staging/fwserial/Kconfig
+++ b/drivers/staging/fwserial/Kconfig
@@ -3,7 +3,9 @@ config FIREWIRE_SERIAL
        depends on FIREWIRE
        help
           This enables TTY over IEEE 1394, providing high-speed serial
-	  connectivity to cabled peers.
+	  connectivity to cabled peers. This driver implements a
+	  ad-hoc transport protocol and is currently limited to
+	  Linux-to-Linux communication.
 
 	  To compile this driver as a module, say M here:  the module will
 	  be called firewire-serial.
-- 
1.8.0.1

