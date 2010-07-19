Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0GSXto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:49:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31722 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0GSXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:49:42 -0400
Date: Mon, 19 Jul 2010 16:49:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, axboe@kernel.dk
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next/resend] writeback.h: needs linux/device.h
Message-Id: <20100719164917.fb77b1d7.randy.dunlap@oracle.com>
In-Reply-To: <20100719133841.babc9ccb.sfr@canb.auug.org.au>
References: <20100719133841.babc9ccb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C44E48E.0016:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

include/trace/events/writeback.h uses dev_name(), so it needs to
include linux/device.h.

include/trace/events/writeback.h:12: error: implicit declaration of function 'dev_name'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/trace/events/writeback.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100708.orig/include/trace/events/writeback.h
+++ linux-next-20100708/include/trace/events/writeback.h
@@ -5,6 +5,7 @@
 #define _TRACE_WRITEBACK_H
 
 #include <linux/backing-dev.h>
+#include <linux/device.h>
 #include <linux/writeback.h>
 
 struct wb_writeback_work;
