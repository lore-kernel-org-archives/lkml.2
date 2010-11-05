Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0KEQqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:46:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37544 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0KEQqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:46:17 -0400
Date: Fri, 5 Nov 2010 17:46:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix warning about usr/include/linux/resource.h missing an
 include
Message-ID: <20101105174608.3f5962bb@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:
usr/include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 include/linux/resource.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.37-rc1.orig/include/linux/resource.h	2010-10-21 10:01:14.000000000 +0200
+++ linux-2.6.37-rc1/include/linux/resource.h	2010-11-05 17:22:56.000000000 +0100
@@ -2,6 +2,7 @@
 #define _LINUX_RESOURCE_H
 
 #include <linux/time.h>
+#include <linux/types.h>
 
 /*
  * Resource control/accounting header file for linux


-- 
Jean Delvare
