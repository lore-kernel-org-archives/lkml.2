Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2GDOXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:23:48 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:57954 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753301Ab2GDOXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:23:18 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2012 10:23:18 EDT
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, John Linn <john.linn@xilinx.com>
Subject: [PATCH 2/3] ARM: zynq: Add compatible entry for the ZC702 board.
Date: Wed,  4 Jul 2012 10:13:34 -0400
Message-Id: <1341411215-3617-3-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
References: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the kernel to start on this platform with the
vendor-provided device tree blob.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: John Linn <john.linn@xilinx.com>

---
 arch/arm/mach-zynq/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 12a2984..a58c83b 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -106,6 +106,7 @@ static void __init xilinx_map_io(void)
 
 static const char *xilinx_dt_match[] = {
 	"xlnx,zynq-ep107",
+	"xlnx,zynq-zc702",
 	NULL
 };
 
-- 
1.7.8.6


