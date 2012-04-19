Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2DSBbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:31:48 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:26687 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DSBbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:31:36 -0400
From: "W. Trevor King" <wking@tremily.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "W. Trevor King" <wking@tremily.us>, Ian Abbott <abbotti@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] staging: comedi: ni_tio_internal.h: checkpatch.pl line
 wrapping
Date: Wed, 18 Apr 2012 21:30:27 -0400
Message-id: <da507480807811edbf19306d405bc2af371ef029.1334798829.git.wking@tremily.us>
X-Mailer: git-send-email 1.7.3.4
In-reply-to: <20120418235714.GC5163@kroah.com>
References: <20120418235714.GC5163@kroah.com>
In-reply-to: <cover.1334798829.git.wking@tremily.us>
References: <cover.1334798829.git.wking@tremily.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: W. Trevor King <wking@tremily.us>
---
 drivers/staging/comedi/drivers/ni_tio_internal.h |   31 ++++++++++++++--------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio_internal.h b/drivers/staging/comedi/drivers/ni_tio_internal.h
index c4ca537..f9295ec 100644
--- a/drivers/staging/comedi/drivers/ni_tio_internal.h
+++ b/drivers/staging/comedi/drivers/ni_tio_internal.h
@@ -362,8 +362,8 @@ static inline enum ni_gpct_register NITIO_Gi_ABZ_Reg(int counter_index)
 	return 0;
 }
 
-static inline enum ni_gpct_register NITIO_Gi_Interrupt_Acknowledge_Reg(int
-								       counter_index)
+static inline enum ni_gpct_register NITIO_Gi_Interrupt_Acknowledge_Reg(
+	int counter_index)
 {
 	switch (counter_index) {
 	case 0:
@@ -407,8 +407,8 @@ static inline enum ni_gpct_register NITIO_Gi_Status_Reg(int counter_index)
 	return 0;
 }
 
-static inline enum ni_gpct_register NITIO_Gi_Interrupt_Enable_Reg(int
-								  counter_index)
+static inline enum ni_gpct_register NITIO_Gi_Interrupt_Enable_Reg(
+	int counter_index)
 {
 	switch (counter_index) {
 	case 0:
@@ -472,15 +472,22 @@ enum Gi_Counting_Mode_Reg_Bits {
 	Gi_Index_Phase_LowA_HighB = 0x1 << Gi_Index_Phase_Bitshift,
 	Gi_Index_Phase_HighA_LowB = 0x2 << Gi_Index_Phase_Bitshift,
 	Gi_Index_Phase_HighA_HighB = 0x3 << Gi_Index_Phase_Bitshift,
-	Gi_HW_Arm_Enable_Bit = 0x80,	/* from m-series example code, not documented in 660x register level manual */
-	Gi_660x_HW_Arm_Select_Mask = 0x7 << Gi_HW_Arm_Select_Shift,	/* from m-series example code, not documented in 660x register level manual */
+	/* from m-series example code, not documented in 660x register level
+	 * manual */
+	Gi_HW_Arm_Enable_Bit = 0x80,
+	/* from m-series example code, not documented in 660x register level
+	 * manual */
+	Gi_660x_HW_Arm_Select_Mask = 0x7 << Gi_HW_Arm_Select_Shift,
 	Gi_660x_Prescale_X8_Bit = 0x1000,
 	Gi_M_Series_Prescale_X8_Bit = 0x2000,
 	Gi_M_Series_HW_Arm_Select_Mask = 0x1f << Gi_HW_Arm_Select_Shift,
-	/* must be set for clocks over 40MHz, which includes synchronous counting and quadrature modes */
+	/* must be set for clocks over 40MHz, which includes synchronous
+	 * counting and quadrature modes */
 	Gi_660x_Alternate_Sync_Bit = 0x2000,
 	Gi_M_Series_Alternate_Sync_Bit = 0x4000,
-	Gi_660x_Prescale_X2_Bit = 0x4000,	/* from m-series example code, not documented in 660x register level manual */
+	/* from m-series example code, not documented in 660x register level
+	 * manual */
+	Gi_660x_Prescale_X2_Bit = 0x4000,
 	Gi_M_Series_Prescale_X2_Bit = 0x8000,
 };
 
@@ -503,7 +510,8 @@ enum Gi_Mode_Bits {
 	Gi_Level_Gating_Bits = 0x1,
 	Gi_Rising_Edge_Gating_Bits = 0x2,
 	Gi_Falling_Edge_Gating_Bits = 0x3,
-	Gi_Gate_On_Both_Edges_Bit = 0x4,	/* used in conjunction with rising edge gating mode */
+	Gi_Gate_On_Both_Edges_Bit = 0x4,	/* used in conjunction with
+						 * rising edge gating mode */
 	Gi_Trigger_Mode_for_Edge_Gate_Mask = 0x18,
 	Gi_Edge_Gate_Starts_Stops_Bits = 0x0,
 	Gi_Edge_Gate_Stops_Starts_Bits = 0x8,
@@ -748,8 +756,9 @@ static inline void ni_tio_set_bits_transient(struct ni_gpct *counter,
 }
 
 /* ni_tio_set_bits( ) is for safely writing to registers whose bits may be
-twiddled in interrupt context, or whose software copy may be read in interrupt context.
-*/
+ * twiddled in interrupt context, or whose software copy may be read in
+ * interrupt context.
+ */
 static inline void ni_tio_set_bits(struct ni_gpct *counter,
 				   enum ni_gpct_register register_index,
 				   unsigned bit_mask, unsigned bit_values)
-- 
1.7.3.4

