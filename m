Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab0INOjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:39:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab0INOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:38:59 -0400
Message-ID: <4C8F88B6.2010504@vlnb.net>
Date: Tue, 14 Sep 2010 18:37:42 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Subject: [PATCH 1/17]: Integration of SCST into the Linux kernel tree
References: <4C8F886E.2080407@vlnb.net>
In-Reply-To: <4C8F886E.2080407@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:olZ1LAwbdSL4l8J5PeY6r2RvLRMUZ1QAGBEDxHGm4Sy
 eXgd7a7JHI/9A23AL9kv/vPwUxPEJv5zbIi0ofHR4TxZP+gdYz
 bFOn0410jteKfgkuxi14a9GJseq+ZndUsyy3dt4o2n7Tjcoqky
 tlVdu/76020tNEUHOPgEzrwP7u0rYNjtSK7noEvZKali4yKgPR
 +Zs6C3HJbn7JflR0KTSqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains changes in drivers/Kconfig and drivers/Makefile to integrate
SCST into the Linux kernel tree.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 Kconfig  |    2 ++
 Makefile |    1 +
 2 files changed, 3 insertions(+)

Signed-off-by: 

diff -upkr -X linux-2.6.35/Documentation/dontdiff linux-2.6.35/drivers/Kconfig linux-2.6.35/drivers/Kconfig
--- orig/linux-2.6.35/drivers/Kconfig 01:51:29.000000000 +0400
+++ linux-2.6.35/drivers/Kconfig 14:14:46.000000000 +0400
@@ -22,6 +22,8 @@ source "drivers/ide/Kconfig"
 
 source "drivers/scsi/Kconfig"
 
+source "drivers/scst/Kconfig"
+
 source "drivers/ata/Kconfig"
 
 source "drivers/md/Kconfig"
diff -upkr -X linux-2.6.35/Documentation/dontdiff linux-2.6.35/drivers/Makefile linux-2.6.35/drivers/Makefile
--- orig/linux-2.6.35/drivers/Makefile 01:51:29.000000000 +0400
+++ linux-2.6.35/drivers/Makefile 14:15:29.000000000 +0400
@@ -43,6 +43,7 @@ obj-$(CONFIG_ATM)		+= atm/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_SCSI)		+= scsi/
+obj-$(CONFIG_SCST)		+= scst/
 obj-$(CONFIG_ATA)		+= ata/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/

