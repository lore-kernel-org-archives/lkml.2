Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0INCZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:25:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39318 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0INCZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:25:12 -0400
Date: Tue, 14 Sep 2010 12:25:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20100914122510.99c3e3b3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/misc/Makefile between commit
03f582a93ecca6e9584b622570022abf08ed03ec ("misc: Add ab8500 pwm driver")
from the mfd tree and commit b6de6c8f5a6fc18c5c67bb4e53f3d0cfd266b07b
("add Packet hub driver for Topcliff Platform controller hub") from the
driver-core tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

P.S. Greg, I noticed that the driver-core patch above does not have a SOB
from its author.

diff --cc drivers/misc/Makefile
index 33bc441,21b4761..0000000
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@@ -35,4 -35,4 +35,5 @@@ obj-y				+= eeprom
  obj-y				+= cb710/
  obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 +obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
+ obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
