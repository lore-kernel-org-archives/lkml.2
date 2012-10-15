Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2JOVnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:43:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2JOVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:43:30 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TtU46XPs5IkA:10 a=TRgVYD6ZyiEA:10 a=ha3O63_jkVoA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=jo8P0UgX770A:10 a=_DFGc7OWwY14PL9uOa8A:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Mon, 15 Oct 2012 16:43:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] include/version.h: Update for kernel 3.7
Message-ID: <507c837f.D1Nk8uFiYhA4dhxy%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value for LINUX_VERSION_CODE was not updated for kernel 3.7-rc1.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---

Index: linux-2.6/include/linux/version.h
===================================================================
--- linux-2.6.orig/include/linux/version.h
+++ linux-2.6/include/linux/version.h
@@ -1,2 +1,2 @@
-#define LINUX_VERSION_CODE 198144
+#define LINUX_VERSION_CODE 198400
 #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
