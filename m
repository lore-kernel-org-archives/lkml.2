Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab2DSCbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:31:49 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:30942 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2DSCbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:31:48 -0400
X-Greylist: delayed 3606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 22:31:48 EDT
From: "W. Trevor King" <wking@tremily.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "W. Trevor King" <wking@tremily.us>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] staging: comedi: ni_tio_internal.h: checkpatch.pl
 cleanups
Date: Wed, 18 Apr 2012 21:30:28 -0400
Message-id: <36a94f19a24e5ccf6bcb283f06f685c7ec14449a.1334798829.git.wking@tremily.us>
X-Mailer: git-send-email 1.7.3.4
In-reply-to: <20120418235714.GC5163@kroah.com>
References: <20120418235714.GC5163@kroah.com>
In-reply-to: <cover.1334798829.git.wking@tremily.us>
References: <cover.1334798829.git.wking@tremily.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* No braces for single statement blocks.

Signed-off-by: W. Trevor King <wking@tremily.us>
---
 drivers/staging/comedi/drivers/ni_tio_internal.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio_internal.h b/drivers/staging/comedi/drivers/ni_tio_internal.h
index f9295ec..5e00212 100644
--- a/drivers/staging/comedi/drivers/ni_tio_internal.h
+++ b/drivers/staging/comedi/drivers/ni_tio_internal.h
@@ -694,11 +694,10 @@ static inline unsigned Gi_Gate_Interrupt_Enable_Bit(unsigned counter_index)
 {
 	unsigned bit;
 
-	if (counter_index % 2) {
+	if (counter_index % 2)
 		bit = G1_Gate_Interrupt_Enable_Bit;
-	} else {
+	else
 		bit = G0_Gate_Interrupt_Enable_Bit;
-	}
 	return bit;
 }
 
-- 
1.7.3.4

