Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab1EZWzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:55:07 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:36464
	"EHLO CH1EHSOBE018.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756405Ab1EZWzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:55:06 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <kumar.gala@freescale.com>, <akpm@linux-foundation.org>,
        <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/misc: add Kbuild header file entry for Freescale hypervisor management driver
Date: Thu, 26 May 2011 17:55:01 -0500
Message-ID: <1306450501-29583-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsl_hypervisor.h includes an ioctl interface, so it should be made available
via "make headers_install".

Signed-off-by: Timur Tabi <timur@freescale.com>
---

This adds one change that I forgot to include in my previous patch,
"drivers/misc: introduce Freescale hypervisor management driver".

Kumar, if at all possible, please squash this patch into that one.

 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 75cf611..68c341a 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -134,6 +134,7 @@ header-y += firewire-cdev.h
 header-y += firewire-constants.h
 header-y += flat.h
 header-y += fs.h
+header-y += fsl_hypervisor.h
 header-y += fuse.h
 header-y += futex.h
 header-y += gameport.h
-- 
1.7.3.4


