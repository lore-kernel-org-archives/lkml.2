Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0I3TB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:01:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42748 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207Ab0I3TBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:01:55 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/3] include:linux: tty.h: new ldisc for TI WiLink ST
Date: Thu, 30 Sep 2010 16:13:28 -0400
Message-Id: <1285877610-3043-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Texas Instrument's WiLink7 connectivity devices pack wireless connectivity
technologies like Bluetooth, FM Radio Receiver and Transmitter, GPS and WLAN
into a single die.
The BT, FM and GPS core on the chip are interfaced to application
processors via a single UART.

This line discipline driver allows such different technologies to be used
simultaneous and independent of each other.
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/ti_wilink_st.h |    5 -----
 include/linux/tty.h                  |    1 +
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ti-st/ti_wilink_st.h b/drivers/staging/ti-st/ti_wilink_st.h
index 537efce..afb0cc6 100644
--- a/drivers/staging/ti-st/ti_wilink_st.h
+++ b/drivers/staging/ti-st/ti_wilink_st.h
@@ -25,11 +25,6 @@
 #ifndef TI_WILINK_ST_H
 #define TI_WILINK_ST_H
 
-/* TODO:
- * Move the following to tty.h upon acceptance
- */
-#define N_TI_WL	22	/* Ldisc for TI's WL BT, FM, GPS combo chips */
-
 #ifdef __KERNEL__
 /**
  * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 86be0cd..e500171 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -50,6 +50,7 @@
 #define N_V253		19	/* Codec control over voice modem */
 #define N_CAIF		20      /* CAIF protocol for talking to modems */
 #define N_GSM0710	21	/* GSM 0710 Mux */
+#define N_TI_WL	22	/* for TI's WL BT, FM, GPS combo chips */
 
 /*
  * This character is the same as _POSIX_VDISABLE: it cannot be used as
-- 
1.6.5

