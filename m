Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0ELUkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:40:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18831 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0ELUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:40:29 -0400
Date: Wed, 12 May 2010 13:39:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mmotm] misc: fix ad525X_dpot build
Message-Id: <20100512133915.5af0ab5e.randy.dunlap@oracle.com>
In-Reply-To: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BEB1218.007A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add slab.h to fix build:

drivers/misc/ad525x_dpot.c:609: error: implicit declaration of function 'kzalloc'
drivers/misc/ad525x_dpot.c:609: warning: assignment makes pointer from integer without a cast
drivers/misc/ad525x_dpot.c:656: error: implicit declaration of function 'kfree'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/misc/ad525x_dpot.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-0511-1820.orig/drivers/misc/ad525x_dpot.c
+++ mmotm-2010-0511-1820/drivers/misc/ad525x_dpot.c
@@ -70,6 +70,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #define DRIVER_VERSION			"0.2"
 
