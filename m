Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1JHSKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:10:38 -0400
Received: from blu0-omc1-s7.blu0.hotmail.com ([65.55.116.18]:47875 "EHLO
	blu0-omc1-s7.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab1JHSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:10:37 -0400
X-Originating-IP: [86.28.179.214]
X-Originating-Email: [jake5991@live.com]
Message-ID: <BLU0-SMTP400327EB20018169910A6BAA2FF0@phx.gbl>
Subject: Subject: [PATCH]
From: Jake Burton <jake5991@live.com>
To: gregkh@suse.de
CC: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 8 Oct 2011 19:01:18 +0100
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2011 18:10:35.0702 (UTC) FILETIME=[93967D60:01CC85E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bdfe02a6701656b757f8c59a226c01a50609f9fb Mon Sep 17 00:00:00 2001
From: Jake <jake5991@live.com>
Date: Sat, 8 Oct 2011 18:38:40 +0100
Subject: [PATCH] Staging: comedi: fix brace coding style issue and whitespace issue in ni_atmio.c
 This is a patch to the ni_atmio.c file that fixes up a brace and whitespace warning found by the checkpatch.pl tool.
Signed-off-by: Jake Burton <jake5991@live.com>

---
 drivers/staging/comedi/drivers/ni_atmio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 3330b3d..e6c6c72 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -268,8 +268,8 @@ static const struct ni_board_struct ni_boards[] = {
 	 }
 };
 
-static const int ni_irqpin[] =
-    { -1, -1, -1, 0, 1, 2, -1, 3, -1, -1, 4, 5, 6, -1, -1, 7 };
+static const int ni_irqpin[] = {
+	-1, -1, -1, 0, 1, 2, -1, 3, -1, -1, 4, 5, 6, -1, -1, 7 };
 
 #define interrupt_pin(a)	(ni_irqpin[(a)])
 
@@ -279,7 +279,7 @@ static const int ni_irqpin[] =
 
 struct ni_private {
 	struct pnp_dev *isapnp_dev;
- NI_PRIVATE_COMMON};
+NI_PRIVATE_COMMON};
 #define devpriv ((struct ni_private *)dev->private)
 
 /* How we access registers */
-- 
1.7.4.1



