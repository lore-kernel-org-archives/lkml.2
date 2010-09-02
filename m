Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0IBCAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:00:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35620 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab0IBCAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:00:04 -0400
Date: Thu, 2 Sep 2010 11:59:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Wells <wellsk40@gmail.com>
Subject: linux-next: manual merge of the input tree with the input-current
 tree
Message-Id: <20100902115958.982d7618.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
drivers/input/touchscreen/Makefile between commit
948e90e22f01287302d84b5b8d4ba330a41dbf8a ("Input: mrst-touchscreen - move
out of staging") from the input-current tree and commit
3045a5f5202a1e0ab6ba2bf90a786cf4cae6932a ("Input: add LPC32xx touchscreen
controller driver") from the input tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/touchscreen/Makefile
index 9061042,22e2d59..0000000
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@@ -23,7 -23,7 +23,8 @@@ obj-$(CONFIG_TOUCHSCREEN_EETI)		+= eeti
  obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
  obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
  obj-$(CONFIG_TOUCHSCREEN_INEXIO)	+= inexio.o
 +obj-$(CONFIG_TOUCHSCREEN_INTEL_MID)	+= intel-mid-touch.o
+ obj-$(CONFIG_TOUCHSCREEN_LPC32XX)	+= lpc32xx_ts.o
  obj-$(CONFIG_TOUCHSCREEN_MC13783)	+= mc13783_ts.o
  obj-$(CONFIG_TOUCHSCREEN_MCS5000)	+= mcs5000_ts.o
  obj-$(CONFIG_TOUCHSCREEN_MIGOR)		+= migor_ts.o
