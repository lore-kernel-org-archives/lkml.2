Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1AFAac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:32 -0500
Received: from kroah.org ([198.145.64.141]:35852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab1AFAaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:25 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002304.923508592@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [086/152] MIPS: jz4740: qi_lb60: Fix gpio for the 6th row of the keyboard matrix
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit fe749aab1d21cbb4d87527a7df8799583c233496 upstream.

This patch fixes the gpio number for the 6th row of the keyboard matrix.

(And fixes a typo in my name...)

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/jz4740/board-qi_lb60.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -5,7 +5,7 @@
  *
  * Copyright (c) 2009 Qi Hardware inc.,
  * Author: Xiangfu Liu <xiangfu@qi-hardware.com>
- * Copyright 2010, Lars-Petrer Clausen <lars@metafoo.de>
+ * Copyright 2010, Lars-Peter Clausen <lars@metafoo.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 or later
@@ -235,7 +235,7 @@ static const unsigned int qi_lb60_keypad
 	QI_LB60_GPIO_KEYIN(3),
 	QI_LB60_GPIO_KEYIN(4),
 	QI_LB60_GPIO_KEYIN(5),
-	QI_LB60_GPIO_KEYIN(7),
+	QI_LB60_GPIO_KEYIN(6),
 	QI_LB60_GPIO_KEYIN8,
 };
 


