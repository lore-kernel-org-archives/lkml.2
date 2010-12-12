Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0LMAMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:12:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36149 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0LLXqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: akpm@linux-foundation.org, mchehab@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [103/223] drivers/media/video/cx23885/cx23885-core.c: fix cx23885_dev_checkrevision()
Message-Id: <20101212234643.A2EF2B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

commit abe1def46d84aa27d3f84d729204b162e8c64d76 upstream.

It was missing the `break'.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=18672

Reported-by: Igor <i2g2r2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/cx23885/cx23885-core.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/video/cx23885/cx23885-core.c
===================================================================
--- linux.orig/drivers/media/video/cx23885/cx23885-core.c
+++ linux/drivers/media/video/cx23885/cx23885-core.c
@@ -737,6 +737,7 @@ static void cx23885_dev_checkrevision(st
 	case 0x0e:
 		/* CX23887-15Z */
 		dev->hwrevision = 0xc0;
+		break;
 	case 0x0f:
 		/* CX23887-14Z */
 		dev->hwrevision = 0xb1;
