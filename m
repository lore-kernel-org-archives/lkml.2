Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0HPMqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:46:08 -0400
Received: from msa106.auone-net.jp ([61.117.18.166]:33029 "EHLO
	msa106.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0HPMqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:46:07 -0400
X-Greylist: delayed 951 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 08:46:06 EDT
Date: Mon, 16 Aug 2010 21:30:11 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@md.metrocast.net>, Steven Toth <stoth@kernellabs.com>,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        "David T. L. Wong" <davidtlwong@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cx23885: Use enum for board type definitions.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20100816123012.9C5FC62C03A@msa106.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 drivers/media/video/cx23885/cx23885.h |   62 +++++++++++++++++----------------
 1 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index ed94b17..55dc282 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -54,36 +54,38 @@
 
 #define BUFFER_TIMEOUT     (HZ)  /* 0.5 seconds */
 
-#define CX23885_BOARD_NOAUTO               UNSET
-#define CX23885_BOARD_UNKNOWN                  0
-#define CX23885_BOARD_HAUPPAUGE_HVR1800lp      1
-#define CX23885_BOARD_HAUPPAUGE_HVR1800        2
-#define CX23885_BOARD_HAUPPAUGE_HVR1250        3
-#define CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP   4
-#define CX23885_BOARD_HAUPPAUGE_HVR1500Q       5
-#define CX23885_BOARD_HAUPPAUGE_HVR1500        6
-#define CX23885_BOARD_HAUPPAUGE_HVR1200        7
-#define CX23885_BOARD_HAUPPAUGE_HVR1700        8
-#define CX23885_BOARD_HAUPPAUGE_HVR1400        9
-#define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
-#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
-#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12
-#define CX23885_BOARD_COMPRO_VIDEOMATE_E650F   13
-#define CX23885_BOARD_TBS_6920                 14
-#define CX23885_BOARD_TEVII_S470               15
-#define CX23885_BOARD_DVBWORLD_2005            16
-#define CX23885_BOARD_NETUP_DUAL_DVBS2_CI      17
-#define CX23885_BOARD_HAUPPAUGE_HVR1270        18
-#define CX23885_BOARD_HAUPPAUGE_HVR1275        19
-#define CX23885_BOARD_HAUPPAUGE_HVR1255        20
-#define CX23885_BOARD_HAUPPAUGE_HVR1210        21
-#define CX23885_BOARD_MYGICA_X8506             22
-#define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
-#define CX23885_BOARD_HAUPPAUGE_HVR1850        24
-#define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
-#define CX23885_BOARD_HAUPPAUGE_HVR1290        26
-#define CX23885_BOARD_MYGICA_X8558PRO          27
-#define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
+enum {
+	CX23885_BOARD_NOAUTO = UNSET,
+	CX23885_BOARD_UNKNOWN = 0,
+	CX23885_BOARD_HAUPPAUGE_HVR1800lp,
+	CX23885_BOARD_HAUPPAUGE_HVR1800,
+	CX23885_BOARD_HAUPPAUGE_HVR1250,
+	CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP,
+	CX23885_BOARD_HAUPPAUGE_HVR1500Q,
+	CX23885_BOARD_HAUPPAUGE_HVR1500,
+	CX23885_BOARD_HAUPPAUGE_HVR1200,
+	CX23885_BOARD_HAUPPAUGE_HVR1700,
+	CX23885_BOARD_HAUPPAUGE_HVR1400,
+	CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
+	CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
+	CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
+	CX23885_BOARD_COMPRO_VIDEOMATE_E650F,
+	CX23885_BOARD_TBS_6920,
+	CX23885_BOARD_TEVII_S470,
+	CX23885_BOARD_DVBWORLD_2005,
+	CX23885_BOARD_NETUP_DUAL_DVBS2_CI,
+	CX23885_BOARD_HAUPPAUGE_HVR1270,
+	CX23885_BOARD_HAUPPAUGE_HVR1275,
+	CX23885_BOARD_HAUPPAUGE_HVR1255,
+	CX23885_BOARD_HAUPPAUGE_HVR1210,
+	CX23885_BOARD_MYGICA_X8506,
+	CX23885_BOARD_MAGICPRO_PROHDTVE2,
+	CX23885_BOARD_HAUPPAUGE_HVR1850,
+	CX23885_BOARD_COMPRO_VIDEOMATE_E800,
+	CX23885_BOARD_HAUPPAUGE_HVR1290,
+	CX23885_BOARD_MYGICA_X8558PRO,
+	CX23885_BOARD_LEADTEK_WINFAST_PXTV1200
+};
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
1.7.1

