Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2BQOHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:07:24 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37393
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2BQOHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:07:23 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] usb: Fix typo in ehci-dbg.c
Date: Fri, 17 Feb 2012 23:06:47 +0900
Message-Id: <1329487607-1995-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "peridic" to "periodic" in
drivers/usb/host/ehci-dbg.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/usb/host/ehci-dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index d6d74d2..fd9109d 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -107,7 +107,7 @@ static void dbg_hcc_params (struct ehci_hcd *ehci, char *label)
 			HCC_PER_PORT_CHANGE_EVENT(params) ? " ppce" : "",
 			HCC_HW_PREFETCH(params) ? " hw prefetch" : "",
 			HCC_32FRAME_PERIODIC_LIST(params) ?
-				" 32 peridic list" : "");
+				" 32 periodic list" : "");
 	}
 }
 #else
-- 
1.7.4.4

