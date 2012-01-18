Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2ARJOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:14:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab2ARJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:14:32 -0500
Date: Wed, 18 Jan 2012 10:14:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 2/2] ARM: mach-shmobile: both USB DMAC instances on sh7372
 are slave-only
In-Reply-To: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201181013540.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181012130.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ITZDsX8+xvxwVV46dgnUjURTBTjBvsB7sJsjbzJRZSk
 f6ajI28F+Ml4fGJfhh1A6HkRSLcut4mZjJfFd+W1o5mw3Uq09h
 6VxMRGlCQPHPZVNs/LcEvB92ftofDJbtcJMLuj1fK5CXg0kkrd
 ecQV/iBXanxtnJq5YpzbVx+xcJTRedprNGFovAawP+V7pFlJJ1
 wyeXeVE/sYNg9e16iHh0dD/1qVSCSdvD3L5cZ5zxz2X05sp7Z4
 085GT0CKWNM4k7sA5riNgswu53PLHkXoKQFsHqQW9KLroThGyq
 nGGIbVUk3xbAq7c58llRbWPrz1bF54WFpn4RPXeE7tLGUtM2Fj
 UTR367Kww2ghFEFJ62zTNs7nZq9YtvN4EEsrA/fayMbeyuoZxa
 a9xNRXgRe2wCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/setup-sh7372.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 45a3418..9aa22395 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -662,6 +662,7 @@ static struct sh_dmae_pdata usb_dma0_platform_data = {
 	.dmaor_is_32bit	= 1,
 	.needs_tend_set	= 1,
 	.no_dmars	= 1,
+	.slave_only	= 1,
 };
 
 static struct resource sh7372_usb_dmae0_resources[] = {
@@ -723,6 +724,7 @@ static struct sh_dmae_pdata usb_dma1_platform_data = {
 	.dmaor_is_32bit	= 1,
 	.needs_tend_set	= 1,
 	.no_dmars	= 1,
+	.slave_only	= 1,
 };
 
 static struct resource sh7372_usb_dmae1_resources[] = {
-- 
1.7.2.5

