Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab2JaXMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:12:54 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:53351 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2JaXMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:51 -0400
Message-Id: <8c2fac7167cd7c5201d5e1d8e1ceeb183ee2f63f.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Wed, 31 Oct 2012 13:45:17 -0600
Subject: [PATCH 3/8] ARM: zynq: dts: add description of the second uart
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:28 PM,
	Serialize complete at 10/31/2012 06:12:28 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zynq-7000 has an additional UART at 0xE0001000.  Describe it in the
device tree.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/boot/dts/zynq-ep107.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-ep107.dts
index 574bc04..5caf100 100644
--- a/arch/arm/boot/dts/zynq-ep107.dts
+++ b/arch/arm/boot/dts/zynq-ep107.dts
@@ -59,5 +59,12 @@
 			interrupts = <0 27 4>;
 			clock = <50000000>;
 		};
+
+		uart1: uart@e0001000 {
+			compatible = "xlnx,xuartps";
+			reg = <0xE0001000 0x1000>;
+			interrupts = <0 50 4>;
+			clock = <50000000>;
+		};
 	};
 };
-- 
1.8.0


