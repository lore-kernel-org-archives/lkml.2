Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0DMNJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:09:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DMNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:09:17 -0400
Message-ID: <4BC46CE8.8020609@vlnb.net>
Date: Tue, 13 Apr 2010 17:08:56 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH][RFC 1/2/3/5] Changes in drivers/Kconfig and drivers/Makefile
References: <4BC4613B.6030109@vlnb.net> <4BC4638F.5070908@vlnb.net>
In-Reply-To: <4BC4638F.5070908@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19uFaniwg8B2ohzOFYUxbFrRGuwRcQ+j0fFiQi
 UMCw8mZPzFi4JtvLZZ+JA/mWwb8QPBT5u5DlA2UeoZjCZztK0r
 FvNOkRVpkl3+08dDbdkdg==
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

diff -upkr -X linux-2.6.33/Documentation/dontdiff linux-2.6.33/drivers/Kconfig linux-2.6.33/drivers/Kconfig
--- orig/linux-2.6.33/drivers/Kconfig 01:51:29.000000000 +0400
+++ linux-2.6.33/drivers/Kconfig 14:14:46.000000000 +0400
@@ -24,6 +24,8 @@ source "drivers/ide/Kconfig"
 
 source "drivers/scsi/Kconfig"
 
+source "drivers/scst/Kconfig"
+
 source "drivers/ata/Kconfig"
 
 source "drivers/md/Kconfig"
diff -upkr -X linux-2.6.33/Documentation/dontdiff linux-2.6.33/drivers/Makefile linux-2.6.33/drivers/Makefile
--- orig/linux-2.6.33/drivers/Makefile 01:51:29.000000000 +0400
+++ linux-2.6.33/drivers/Makefile 14:15:29.000000000 +0400
@@ -41,6 +41,7 @@ obj-$(CONFIG_ATM)		+= atm/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_SCSI)		+= scsi/
+obj-$(CONFIG_SCST)		+= scst/
 obj-$(CONFIG_ATA)		+= ata/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/

