Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab1FGIwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:52:19 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53735 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1FGIwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AAD5N0kyRdoIvI6pAbPwMnWwC92N0TBTyn14apxcKVPB1KJXKrXa9RTcpOXPuHbz7f
         PN/FAUU/PhB6JkEOkdCAeFAQchkr0hDObtSfFdjM1+1i3KnpFukiiGBaQeKlQgs4fsXc
         JcODNb9euxa/IGBO2t6R+ntDX82BydcN/DOUw=
From: Akshay Joshi <me@akshayjoshi.com>
To: gregkh@suse.de, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Akshay Joshi <me@akshayjoshi.com>
Subject: [PATCH] Staging: Winbond: Fix assorted spacing issues.
Date: Tue,  7 Jun 2011 04:51:55 -0400
Message-Id: <1307436715-20108-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the phy_calibration.c file's spacing issues and convert the spaces
to tabs. This reduces the number of errors and warnings returned by
checkpatch.pl.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/phy_calibration.c |  462 ++++++++++++++--------------
 1 files changed, 231 insertions(+), 231 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 79e53e4..c5a07fb 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -44,147 +44,147 @@ static const s32 Angles[] = {
 
 s32 _s13_to_s32(u32 data)
 {
-    u32     val;
+	u32     val;
 
-    val = (data & 0x0FFF);
+	val = (data & 0x0FFF);
 
-    if ((data & BIT(12)) != 0)
-        val |= 0xFFFFF000;
+	if ((data & BIT(12)) != 0)
+		val |= 0xFFFFF000;
 
-    return ((s32) val);
+	return ((s32) val);
 }
 
 u32 _s32_to_s13(s32 data)
 {
-    u32     val;
+	u32     val;
 
-    if (data > 4095)
-        data = 4095;
-    else if (data < -4096)
-        data = -4096;
+	if (data > 4095)
+		data = 4095;
+	else if (data < -4096)
+		data = -4096;
 
-    val = data & 0x1FFF;
+	val = data & 0x1FFF;
 
-    return val;
+	return val;
 }
 
 /****************************************************************************/
 s32 _s4_to_s32(u32 data)
 {
-    s32     val;
+	s32     val;
 
-    val = (data & 0x0007);
+	val = (data & 0x0007);
 
-    if ((data & BIT(3)) != 0)
-        val |= 0xFFFFFFF8;
+	if ((data & BIT(3)) != 0)
+		val |= 0xFFFFFFF8;
 
-    return val;
+	return val;
 }
 
 u32 _s32_to_s4(s32 data)
 {
-    u32     val;
+	u32     val;
 
-    if (data > 7)
-        data = 7;
-    else if (data < -8)
-        data = -8;
+	if (data > 7)
+		data = 7;
+	else if (data < -8)
+		data = -8;
 
-    val = data & 0x000F;
+	val = data & 0x000F;
 
-    return val;
+	return val;
 }
 
 /****************************************************************************/
 s32 _s5_to_s32(u32 data)
 {
-    s32     val;
+	s32     val;
 
-    val = (data & 0x000F);
+	val = (data & 0x000F);
 
-    if ((data & BIT(4)) != 0)
-        val |= 0xFFFFFFF0;
+	if ((data & BIT(4)) != 0)
+		val |= 0xFFFFFFF0;
 
-    return val;
+	return val;
 }
 
 u32 _s32_to_s5(s32 data)
 {
-    u32     val;
+	u32     val;
 
-    if (data > 15)
-        data = 15;
-    else if (data < -16)
-        data = -16;
+	if (data > 15)
+		data = 15;
+	else if (data < -16)
+		data = -16;
 
-    val = data & 0x001F;
+	val = data & 0x001F;
 
-    return val;
+	return val;
 }
 
 /****************************************************************************/
 s32 _s6_to_s32(u32 data)
 {
-    s32     val;
+	s32     val;
 
-    val = (data & 0x001F);
+	val = (data & 0x001F);
 
-    if ((data & BIT(5)) != 0)
-        val |= 0xFFFFFFE0;
+	if ((data & BIT(5)) != 0)
+		val |= 0xFFFFFFE0;
 
-    return val;
+	return val;
 }
 
 u32 _s32_to_s6(s32 data)
 {
-    u32     val;
+	u32     val;
 
-    if (data > 31)
-        data = 31;
-    else if (data < -32)
-        data = -32;
+	if (data > 31)
+		data = 31;
+	else if (data < -32)
+		data = -32;
 
-    val = data & 0x003F;
+	val = data & 0x003F;
 
-    return val;
+	return val;
 }
 
 /****************************************************************************/
 s32 _s9_to_s32(u32 data)
 {
-    s32     val;
+	s32     val;
 
-    val = data & 0x00FF;
+	val = data & 0x00FF;
 
-    if ((data & BIT(8)) != 0)
-        val |= 0xFFFFFF00;
+	if ((data & BIT(8)) != 0)
+		val |= 0xFFFFFF00;
 
-    return val;
+	return val;
 }
 
 u32 _s32_to_s9(s32 data)
 {
-    u32     val;
+	u32     val;
 
-    if (data > 255)
-        data = 255;
-    else if (data < -256)
-        data = -256;
+	if (data > 255)
+		data = 255;
+	else if (data < -256)
+		data = -256;
 
-    val = data & 0x01FF;
+	val = data & 0x01FF;
 
-    return val;
+	return val;
 }
 
 /****************************************************************************/
 s32 _floor(s32 n)
 {
-    if (n > 0)
-	n += 5;
-    else
-        n -= 5;
+	if (n > 0)
+		n += 5;
+	else
+		n -= 5;
 
-    return (n/10);
+	return (n/10);
 }
 
 /****************************************************************************/
@@ -195,105 +195,105 @@ s32 _floor(s32 n)
  */
 u32 _sqrt(u32 sqsum)
 {
-    u32     sq_rt;
-
-    int     g0, g1, g2, g3, g4;
-    int     seed;
-    int     next;
-    int     step;
-
-    g4 =  sqsum / 100000000;
-    g3 = (sqsum - g4*100000000) / 1000000;
-    g2 = (sqsum - g4*100000000 - g3*1000000) / 10000;
-    g1 = (sqsum - g4*100000000 - g3*1000000 - g2*10000) / 100;
-    g0 = (sqsum - g4*100000000 - g3*1000000 - g2*10000 - g1*100);
-
-    next = g4;
-    step = 0;
-    seed = 0;
-    while (((seed+1)*(step+1)) <= next) {
-        step++;
-        seed++;
-    }
-
-    sq_rt = seed * 10000;
-    next = (next-(seed*step))*100 + g3;
-
-    step = 0;
-    seed = 2 * seed * 10;
-    while (((seed+1)*(step+1)) <= next) {
-        step++;
-        seed++;
-    }
-
-    sq_rt = sq_rt + step * 1000;
-    next = (next - seed * step) * 100 + g2;
-    seed = (seed + step) * 10;
-    step = 0;
-    while (((seed+1)*(step+1)) <= next) {
-        step++;
-        seed++;
-    }
-
-    sq_rt = sq_rt + step * 100;
-    next = (next - seed * step) * 100 + g1;
-    seed = (seed + step) * 10;
-    step = 0;
-
-    while (((seed+1)*(step+1)) <= next) {
-        step++;
-        seed++;
-    }
-
-    sq_rt = sq_rt + step * 10;
-    next = (next - seed * step) * 100 + g0;
-    seed = (seed + step) * 10;
-    step = 0;
-
-    while (((seed+1)*(step+1)) <= next) {
-        step++;
-        seed++;
-    }
-
-    sq_rt = sq_rt + step;
-
-    return sq_rt;
+	u32     sq_rt;
+
+	int     g0, g1, g2, g3, g4;
+	int     seed;
+	int     next;
+	int     step;
+
+	g4 =  sqsum / 100000000;
+	g3 = (sqsum - g4*100000000) / 1000000;
+	g2 = (sqsum - g4*100000000 - g3*1000000) / 10000;
+	g1 = (sqsum - g4*100000000 - g3*1000000 - g2*10000) / 100;
+	g0 = (sqsum - g4*100000000 - g3*1000000 - g2*10000 - g1*100);
+
+	next = g4;
+	step = 0;
+	seed = 0;
+	while (((seed+1)*(step+1)) <= next) {
+		step++;
+		seed++;
+	}
+
+	sq_rt = seed * 10000;
+	next = (next-(seed*step))*100 + g3;
+
+	step = 0;
+	seed = 2 * seed * 10;
+	while (((seed+1)*(step+1)) <= next) {
+		step++;
+		seed++;
+	}
+
+	sq_rt = sq_rt + step * 1000;
+	next = (next - seed * step) * 100 + g2;
+	seed = (seed + step) * 10;
+	step = 0;
+	while (((seed+1)*(step+1)) <= next) {
+		step++;
+		seed++;
+	}
+
+	sq_rt = sq_rt + step * 100;
+	next = (next - seed * step) * 100 + g1;
+	seed = (seed + step) * 10;
+	step = 0;
+
+	while (((seed+1)*(step+1)) <= next) {
+		step++;
+		seed++;
+	}
+
+	sq_rt = sq_rt + step * 10;
+	next = (next - seed * step) * 100 + g0;
+	seed = (seed + step) * 10;
+	step = 0;
+
+	while (((seed+1)*(step+1)) <= next) {
+		step++;
+		seed++;
+	}
+
+	sq_rt = sq_rt + step;
+
+	return sq_rt;
 }
 
 /****************************************************************************/
 void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 {
-    s32 X, Y, TargetAngle, CurrAngle;
-    unsigned    Step;
-
-    X = FIXED(AG_CONST);      /* AG_CONST * cos(0) */
-    Y = 0;                    /* AG_CONST * sin(0) */
-    TargetAngle = abs(angle);
-    CurrAngle = 0;
-
-    for (Step = 0; Step < 12; Step++) {
-	s32 NewX;
-
-        if (TargetAngle > CurrAngle) {
-            NewX = X - (Y >> Step);
-            Y = (X >> Step) + Y;
-            X = NewX;
-            CurrAngle += Angles[Step];
-        } else {
-            NewX = X + (Y >> Step);
-            Y = -(X >> Step) + Y;
-            X = NewX;
-            CurrAngle -= Angles[Step];
-        }
-    }
-
-    if (angle > 0) {
-        *cos = X;
-        *sin = Y;
-    } else {
-        *cos = X;
-        *sin = -Y;
-    }
+	s32 X, Y, TargetAngle, CurrAngle;
+	unsigned    Step;
+
+	X = FIXED(AG_CONST);      /* AG_CONST * cos(0) */
+	Y = 0;                    /* AG_CONST * sin(0) */
+	TargetAngle = abs(angle);
+	CurrAngle = 0;
+
+	for (Step = 0; Step < 12; Step++) {
+		s32 NewX;
+
+		if (TargetAngle > CurrAngle) {
+			NewX = X - (Y >> Step);
+			Y = (X >> Step) + Y;
+			X = NewX;
+			CurrAngle += Angles[Step];
+		} else {
+			NewX = X + (Y >> Step);
+			Y = -(X >> Step) + Y;
+			X = NewX;
+			CurrAngle -= Angles[Step];
+		}
+	}
+
+	if (angle > 0) {
+		*cos = X;
+		*sin = Y;
+	} else {
+		*cos = X;
+		*sin = -Y;
+	}
 }
 
 static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 * pValue)
@@ -338,24 +338,24 @@ void _reset_rx_cal(struct hw_data *phw_data)
 /**********************************************/
 void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequency)
 {
-    u32     reg_agc_ctrl3;
-    u32     reg_a_acq_ctrl;
-    u32     reg_b_acq_ctrl;
-    u32     val;
+	u32     reg_agc_ctrl3;
+	u32     reg_a_acq_ctrl;
+	u32     reg_b_acq_ctrl;
+	u32     val;
 
-    PHY_DEBUG(("[CAL] -> [1]_rxadc_dc_offset_cancellation()\n"));
-    phy_init_rf(phw_data);
+	PHY_DEBUG(("[CAL] -> [1]_rxadc_dc_offset_cancellation()\n"));
+	phy_init_rf(phw_data);
 
-    /* set calibration channel */
-    if ((RF_WB_242 == phw_data->phy_type) ||
+	/* set calibration channel */
+	if ((RF_WB_242 == phw_data->phy_type) ||
 		(RF_WB_242_1 == phw_data->phy_type)) /* 20060619.5 Add */{
-        if ((frequency >= 2412) && (frequency <= 2484)) {
-            /* w89rf242 change frequency to 2390Mhz */
-            PHY_DEBUG(("[CAL] W89RF242/11G/Channel=2390Mhz\n"));
+		if ((frequency >= 2412) && (frequency <= 2484)) {
+			/* w89rf242 change frequency to 2390Mhz */
+			PHY_DEBUG(("[CAL] W89RF242/11G/Channel=2390Mhz\n"));
 			phy_set_rf_data(phw_data, 3, (3<<24)|0x025586);
 
-        }
-    } else {
+		}
+	} else {
 
 	}
 
@@ -542,7 +542,7 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 	}
 
 	if (loop >= 19)
-	   fix_cancel_dc_i = 0;
+		fix_cancel_dc_i = 0;
 
 	reg_dc_cancel &= ~(0x03FF);
 	reg_dc_cancel |= (_s32_to_s5(fix_cancel_dc_i) << CANCEL_DC_I_SHIFT);
@@ -657,7 +657,7 @@ void _txqdac_dc_offset_cacellation_winbond(struct hw_data *phw_data)
 	}
 
 	if (loop >= 19)
-	   fix_cancel_dc_q = 0;
+		fix_cancel_dc_q = 0;
 
 	reg_dc_cancel &= ~(0x001F);
 	reg_dc_cancel |= (_s32_to_s5(fix_cancel_dc_q) << CANCEL_DC_Q_SHIFT);
@@ -1154,33 +1154,33 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 		capture_time = 0;
 
 		for (capture_time = 0; capture_time < 10; capture_time++) {
-		/* i. Set "calib_start" to 0x0 */
-		reg_mode_ctrl &= ~MASK_CALIB_START;
-		if (!hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl))/*20060718.1 modify */
-			return 0;
-		PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
+			/* i. Set "calib_start" to 0x0 */
+			reg_mode_ctrl &= ~MASK_CALIB_START;
+			if (!hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl))/*20060718.1 modify */
+				return 0;
+			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-		reg_mode_ctrl &= ~MASK_IQCAL_MODE;
-		reg_mode_ctrl |= (MASK_CALIB_START|0x1);
-		hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
-		PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
+			reg_mode_ctrl &= ~MASK_IQCAL_MODE;
+			reg_mode_ctrl |= (MASK_CALIB_START|0x1);
+			hw_set_dxx_reg(phw_data, REG_MODE_CTRL, reg_mode_ctrl);
+			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
-		/* c. */
-		hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
-		PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
+			/* c. */
+			hw_get_dxx_reg(phw_data, REG_CALIB_READ1, &val);
+			PHY_DEBUG(("[CAL]    CALIB_READ1 = 0x%08X\n", val));
 
-		iqcal_tone_i = _s13_to_s32(val & 0x00001FFF);
-		iqcal_tone_q = _s13_to_s32((val & 0x03FFE000) >> 13);
-		PHY_DEBUG(("[CAL]    ** iqcal_tone_i = %d, iqcal_tone_q = %d\n",
-				   iqcal_tone_i, iqcal_tone_q));
+			iqcal_tone_i = _s13_to_s32(val & 0x00001FFF);
+			iqcal_tone_q = _s13_to_s32((val & 0x03FFE000) >> 13);
+			PHY_DEBUG(("[CAL]    ** iqcal_tone_i = %d, iqcal_tone_q = %d\n",
+				iqcal_tone_i, iqcal_tone_q));
 
-		hw_get_dxx_reg(phw_data, REG_CALIB_READ2, &val);
-		PHY_DEBUG(("[CAL]    CALIB_READ2 = 0x%08X\n", val));
+			hw_get_dxx_reg(phw_data, REG_CALIB_READ2, &val);
+			PHY_DEBUG(("[CAL]    CALIB_READ2 = 0x%08X\n", val));
 
-		iqcal_image_i = _s13_to_s32(val & 0x00001FFF);
-		iqcal_image_q = _s13_to_s32((val & 0x03FFE000) >> 13);
-		PHY_DEBUG(("[CAL]    ** iqcal_image_i = %d, iqcal_image_q = %d\n",
-				   iqcal_image_i, iqcal_image_q));
+			iqcal_image_i = _s13_to_s32(val & 0x00001FFF);
+			iqcal_image_q = _s13_to_s32((val & 0x03FFE000) >> 13);
+			PHY_DEBUG(("[CAL]    ** iqcal_image_i = %d, iqcal_image_q = %d\n",
+				iqcal_image_i, iqcal_image_q));
 			if (capture_time == 0)
 				continue;
 			else {
@@ -1358,7 +1358,7 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 			hw_set_dxx_reg(phw_data, 0x54, val);
 
 			if (loop == 3)
-			return 0;
+				return 0;
 		}
 		PHY_DEBUG(("[CAL]    ** CALIB_DATA = 0x%08X\n", val));
 
@@ -1476,40 +1476,40 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 /******************/
 void phy_set_rf_data(struct hw_data *pHwData, u32 index, u32 value)
 {
-   u32 ltmp = 0;
-
-    switch (pHwData->phy_type) {
-    case RF_MAXIM_2825:
-    case RF_MAXIM_V1: /* 11g Winbond 2nd BB(with Phy board (v1) + Maxim 331) */
-            ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
-            break;
-
-    case RF_MAXIM_2827:
-            ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
-	    break;
-
-    case RF_MAXIM_2828:
-	    ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
-	    break;
-
-    case RF_MAXIM_2829:
-	    ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
-	    break;
-
-    case RF_AIROHA_2230:
-    case RF_AIROHA_2230S: /* 20060420 Add this */
-	    ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(value, 20);
-	    break;
-
-    case RF_AIROHA_7230:
-	    ltmp = (1 << 31) | (0 << 30) | (24 << 24) | (value&0xffffff);
-	    break;
-
-    case RF_WB_242:
-    case RF_WB_242_1:/* 20060619.5 Add */
-	    ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(value, 24);
-	    break;
-    }
+	u32 ltmp = 0;
+
+	switch (pHwData->phy_type) {
+	case RF_MAXIM_2825:
+	case RF_MAXIM_V1: /* 11g Winbond 2nd BB(with Phy board (v1) + Maxim 331) */
+		ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
+		break;
+
+	case RF_MAXIM_2827:
+		ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
+		break;
+
+	case RF_MAXIM_2828:
+		ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
+		break;
+
+	case RF_MAXIM_2829:
+		ltmp = (1 << 31) | (0 << 30) | (18 << 24) | BitReverse(value, 18);
+		break;
+
+	case RF_AIROHA_2230:
+	case RF_AIROHA_2230S: /* 20060420 Add this */
+		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(value, 20);
+		break;
+
+	case RF_AIROHA_7230:
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | (value&0xffffff);
+		break;
+
+	case RF_WB_242:
+	case RF_WB_242_1:/* 20060619.5 Add */
+		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(value, 24);
+		break;
+	}
 
 	Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
 }
-- 
1.7.4.4

