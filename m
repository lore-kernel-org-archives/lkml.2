Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab0D3TFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:05:11 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:36322 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044Ab0D3TDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:03:49 -0400
Date: Thu, 29 Apr 2010 10:57:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] virtio_9p.h: include linux/types.h
Message-Id: <20100429105713.07bcf2f9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BD9C88E.0135:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add <linux/types.h> to <linux/virtio_9p.h> so that types are explicitly
defined:
linux/virtio_9p.h:15: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
---
 include/linux/virtio_9p.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-2634-rc5.orig/include/linux/virtio_9p.h
+++ lnx-2634-rc5/include/linux/virtio_9p.h
@@ -2,6 +2,7 @@
 #define _LINUX_VIRTIO_9P_H
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
+#include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
