Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab1DAQvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:51:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20109 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1DAQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:51:09 -0400
Date: Fri, 1 Apr 2011 09:50:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH -next] staging: fix hv_mouse build, needs delay.h
Message-Id: <20110401095054.722068ce.randy.dunlap@oracle.com>
In-Reply-To: <20110401142520.2699bbb0.sfr@canb.auug.org.au>
References: <20110401142520.2699bbb0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D960271.0178:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix hv_mouse.c build, it needs delay.h:

drivers/staging/hv/hv_mouse.c:293: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110401.orig/drivers/staging/hv/hv_mouse.c
+++ linux-next-20110401/drivers/staging/hv/hv_mouse.c
@@ -14,6 +14,7 @@
  */
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
