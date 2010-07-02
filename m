Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0GBXpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 19:45:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50260 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0GBXpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 19:45:20 -0400
Date: Fri, 2 Jul 2010 16:44:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       bcollins@bluecherry.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging/solo: add delay.h header
Message-Id: <20100702164413.20171588.randy.dunlap@oracle.com>
In-Reply-To: <20100702163505.272e6fca.sfr@canb.auug.org.au>
References: <20100702163505.272e6fca.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C2E7A05.00F6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Several solo drivers need <linux/delay.h>, so add it to the
private solo6010.h header file.

drivers/staging/solo6x10/solo6010-core.c:191: error: implicit declaration of function 'mdelay'
drivers/staging/solo6x10/solo6010-tw28.c:181: error: implicit declaration of function 'msleep_interruptible'
drivers/staging/solo6x10/solo6010-gpio.c:78: error: implicit declaration of function 'udelay'
drivers/staging/solo6x10/solo6010-v4l2-enc.c:254: error: implicit declaration of function 'mdelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/solo6x10/solo6010.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100702.orig/drivers/staging/solo6x10/solo6010.h
+++ linux-next-20100702/drivers/staging/solo6x10/solo6010.h
@@ -26,6 +26,7 @@
 #include <linux/semaphore.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/delay.h>
 #include <linux/wait.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
