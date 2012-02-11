Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab2BKMTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:19:38 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46762
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754585Ab2BKMTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:19:36 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] usb: Fix typo in imx21-dbg.c
Date: Sat, 11 Feb 2012 21:19:10 +0900
Message-Id: <1328962750-1946-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "alocate" to "allocate" in
drivers/usb/host/imx21-dbg.c
---
 drivers/usb/host/imx21-dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/imx21-dbg.c b/drivers/usb/host/imx21-dbg.c
index 6d75334..ec98ece 100644
--- a/drivers/usb/host/imx21-dbg.c
+++ b/drivers/usb/host/imx21-dbg.c
@@ -239,7 +239,7 @@ static int debug_status_show(struct seq_file *s, void *v)
 		"ETDs allocated: %d/%d (max=%d)\n"
 		"ETDs in use sw: %d\n"
 		"ETDs in use hw: %d\n"
-		"DMEM alocated: %d/%d (max=%d)\n"
+		"DMEM allocated: %d/%d (max=%d)\n"
 		"DMEM blocks: %d\n"
 		"Queued waiting for ETD: %d\n"
 		"Queued waiting for DMEM: %d\n",
-- 
1.7.6.5

