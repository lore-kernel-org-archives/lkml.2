Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0KFVB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 17:01:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40250 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0KFVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 17:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eDSs8IpyW1N9rbKeVY+CscNcKeCBjZWeLFdJrAvbb5+Cb1DBJWD1oAaZJC8LNswZMS
         ZS9gBVD7CohNnwH55iUxuncknTpHSvQhRXX0jpiO9KYNDSe0a/FYO/0Qqb8QhDdLfX7I
         XLHAlVsZ6j/4rFSeZrPKVXbAOcBjTXCbx3b1U=
From: Tracey Dent <tdent48227@gmail.com>
To: dan.j.williams@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, linus.walleij@stericsson.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/2] drivers/dma/ioat: Use the ccflag-y instead of EXTRA_CFLAGS
Date: Sat,  6 Nov 2010 17:01:37 -0400
Message-Id: <1289077297-1444-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.161.g3089c
In-Reply-To: <1289077297-1444-1-git-send-email-tdent48227@gmail.com>
References: <1289077297-1444-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs. Following
(documentation/kbuild/makefiles.txt).

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/dma/ioat/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/Makefile b/drivers/dma/ioat/Makefile
index 8997d3f..0ff7270 100644
--- a/drivers/dma/ioat/Makefile
+++ b/drivers/dma/ioat/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := pci.o dma.o dma_v2.o dma_v3.o dca.o
+ioatdma-y := pci.o dma.o dma_v2.o dma_v3.o dca.o
-- 
1.7.3.1.104.gc752e

