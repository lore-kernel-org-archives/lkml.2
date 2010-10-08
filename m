Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0JHAHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:07:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0JHACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qe4KKoXBW3N3j39ReQSvYQzeR3VMWlouXd6fKUjAqfSKs34GcqU/lE/bzscDJ/v/nK
         HWg6T2/nPX+Wk2EDplQGni/R/bRu9FRPiTc+mbUVhBu4KKgxYHZIwZ5GBW8vRsbDIV2C
         9EiKWDQA3kIGzOZOSrkZRR7Twx0Mq+z7fexvY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 13/33] Staging: hv: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:33 -0400
Message-Id: <1286496113-11897-13-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/hv/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index b63515c..cd1c43a 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -4,9 +4,9 @@ obj-$(CONFIG_HYPERV_BLOCK)	+= hv_blkvsc.o
 obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
 obj-$(CONFIG_HYPERV_UTILS)	+= hv_utils.o
 
-hv_vmbus-objs := vmbus_drv.o osd.o \
+hv_vmbus-y := vmbus_drv.o osd.o \
 		 vmbus.o hv.o connection.o channel.o \
 		 channel_mgmt.o channel_interface.o ring_buffer.o
-hv_storvsc-objs := storvsc_drv.o storvsc.o
-hv_blkvsc-objs := blkvsc_drv.o blkvsc.o
-hv_netvsc-objs := netvsc_drv.o netvsc.o rndis_filter.o
+hv_storvsc-y := storvsc_drv.o storvsc.o
+hv_blkvsc-y := blkvsc_drv.o blkvsc.o
+hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o
-- 
1.7.3.1.50.g1e633

