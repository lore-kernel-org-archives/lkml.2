Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab0HEF45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:56:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59673
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758828Ab0HEF4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:56:55 -0400
Date: Wed, 04 Aug 2010 22:57:14 -0700 (PDT)
Message-Id: <20100804.225714.98906531.davem@davemloft.net>
To: sameo@linux.intel.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: Missing slab.h includes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

I'm getting build failures with Linus's current tree without
these.  Apologies if this is already fixed and just queued up
in a GIT tree somewhere.

diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 9ed6307..36a166b 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/mfd/core.h>
 
 #include <linux/mfd/janz.h>
