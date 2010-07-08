Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0GHU4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:56:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54247 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab0GHU4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:56:43 -0400
Date: Thu, 8 Jul 2010 13:55:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] tracing: writeback.h needs device.h
Message-Id: <20100708135551.ef5778e2.randy.dunlap@oracle.com>
In-Reply-To: <20100708151022.d2517577.sfr@canb.auug.org.au>
References: <20100708151022.d2517577.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C363B7C.00B8:SCFMA4539814,ss=1,fgs=0
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
