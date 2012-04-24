Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab2DXXIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:08:25 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:9635 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab2DXXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:08:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1335308900!4006749!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: videobuf2-dma-contig: include header for exported symbols
Date: Tue, 24 Apr 2012 16:08:12 -0700
User-Agent: KMail/1.9.9
CC: <linux-media@vger.kernel.org>, <pawel@osciak.com>,
        <m.szyprowski@samsung.com>, <kyungmin.park@samsung.com>,
        <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204241608.13305.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the header to pickup the definitions of the exported symbols.

Quiets the following sparse warnings:

warning: symbol 'vb2_dma_contig_memops' was not declared. Should it be static?
warning: symbol 'vb2_dma_contig_init_ctx' was not declared. Should it be static?
warning: symbol 'vb2_dma_contig_cleanup_ctx' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

---

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f17ad98..a1bee6c 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -15,6 +15,7 @@
 #include <linux/dma-mapping.h>
 
 #include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-memops.h>
 
 struct vb2_dc_conf {
