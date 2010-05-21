Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab0EUQES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:04:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36811 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945Ab0EUQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:04:16 -0400
Date: Fri, 21 May 2010 09:03:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
       Marc Zyngier <maz@misterjones.org>
Subject: [PATCH] interrupt.h: fix fatal kernel-doc error
Message-Id: <20100521090301.716af51c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BF6AEEF.003F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc fatal error:
/** beginning a non-kernel-doc comment block:
(That alone does not kill kernel-doc, but the 'enum' was
totally confusing to it.)

Error(/lnx/src/TMP/linux-2.6.34-git6//include/linux/interrupt.h:88): cannot understand prototype: 'enum '
make[2]: *** [Documentation/DocBook/genericirq.xml] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/interrupt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.34-git6.orig/include/linux/interrupt.h
+++ linux-2.6.34-git6/include/linux/interrupt.h
@@ -78,7 +78,7 @@ enum {
 	IRQTF_AFFINITY,
 };
 
-/**
+/*
  * These values can be returned by request_any_context_irq() and
  * describe the context the interrupt will be run in.
  *
