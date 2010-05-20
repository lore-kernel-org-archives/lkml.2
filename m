Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0ETVJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:09:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25989 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0ETVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:09:47 -0400
Date: Thu, 20 May 2010 14:08:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH -mmotm] media: ak881x needs slab.h
Message-Id: <20100520140823.a9b81de9.randy.dunlap@oracle.com>
In-Reply-To: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BF5A4F1.00BD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add slab.h to fix ak881x build:

drivers/media/video/ak881x.c:265:error: implicit declaration of function 'kzalloc'
drivers/media/video/ak881x.c:265:warning: assignment makes pointer from integer without a cast
drivers/media/video/ak881x.c:283:error: implicit declaration of function 'kfree'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/ak881x.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-0519-1612.orig/drivers/media/video/ak881x.c
+++ mmotm-2010-0519-1612/drivers/media/video/ak881x.c
@@ -11,6 +11,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 
 #include <media/ak881x.h>
