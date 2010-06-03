Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0FCXhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:37:07 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:20257 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754110Ab0FCXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:37:05 -0400
Subject: 0001-staging-comedi-drivers-fix-space-coding-style-in-am9.patch
From: Bob Beattie <bob.beattie@ntlworld.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       bob.beattie@ntlworld.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 00:19:02 +0100
Message-ID: <1275607142.6347.7.camel@Opteron1210>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=f3p7Ev6qf3cA:10 a=yQWWgrYGNuUA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=UqNyHwLrgTyiQ4Ng0soA:9 a=1F2VXGeXkOYgXAXI-g6Ev3g_QTIA:4 a=QEXdDO2ut3YA:10 a=_dQi-Dcv4p4A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1b4f1ada44589c52f26aafea9b33db1b1831d3ec Mon Sep 17 00:00:00 2001
From: Bob Beattie <bob.beattie@ntlworld.com>
Date: Thu, 3 Jun 2010 23:43:44 +0100
Subject: [PATCH] staging: comedi: drivers: fix space coding style in am9513.h
 This is a patch to the file am9513.h that fixes missing space warnings found by the checkpatch.pl tool.
 Signed-off-by: Bob Beattie <bob.beattie@ntlworld.com>

---
 drivers/staging/comedi/drivers/am9513.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/am9513.h b/drivers/staging/comedi/drivers/am9513.h
index 73367d6..0bb839e 100644
--- a/drivers/staging/comedi/drivers/am9513.h
+++ b/drivers/staging/comedi/drivers/am9513.h
@@ -47,32 +47,32 @@
 #ifdef Am9513_8BITBUS

 #define Am9513_write_register(reg, val)				\
-	do{							\
+	do {							\
 		Am9513_output_control(reg);			\
 		Am9513_output_data(val>>8);			\
 		Am9513_output_data(val&0xff);			\
-	}while (0)
+	} while (0)

 #define Am9513_read_register(reg, val)				\
-	do{							\
+	do {							\
 		Am9513_output_control(reg);			\
-		val=Am9513_input_data()<<8;			\
-		val|=Am9513_input_data();			\
-	}while (0)
+		val = Am9513_input_data()<<8;			\
+		val |= Am9513_input_data();			\
+	} while (0)

 #else /* Am9513_16BITBUS */

 #define Am9513_write_register(reg, val)				\
-	do{							\
+	do {							\
 		Am9513_output_control(reg);			\
 		Am9513_output_data(val);			\
-	}while (0)
+	} while (0)

 #define Am9513_read_register(reg, val)				\
-	do{							\
+	do {							\
 		Am9513_output_control(reg);			\
-		val=Am9513_input_data();			\
-	}while (0)
+		val = Am9513_input_data();			\
+	} while (0)

 #endif

--
1.7.0.4



