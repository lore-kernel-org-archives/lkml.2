Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2GCDCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 23:02:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53937 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GCDCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 23:02:41 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] staging: vt6656: main_usb.c: Remove useless macros
Date: Mon,  2 Jul 2012 23:59:30 -0300
Message-Id: <1341284370-11931-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these macros are not used. So, remove this all.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: devel@driverdev.osuosl.org
Cc: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vt6656/main_usb.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ee5261a..5048341 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -92,22 +92,14 @@ MODULE_DESCRIPTION(DEVICE_FULL_DRV_NAM);
         module_param_array(N, int, NULL, 0);\
         MODULE_PARM_DESC(N, D);
 
-#define RX_DESC_MIN0     16
-#define RX_DESC_MAX0     128
 #define RX_DESC_DEF0     64
 DEVICE_PARAM(RxDescriptors0,"Number of receive usb desc buffer");
 
 
-#define TX_DESC_MIN0     16
-#define TX_DESC_MAX0     128
 #define TX_DESC_DEF0     64
 DEVICE_PARAM(TxDescriptors0,"Number of transmit usb desc buffer");
 
-
-#define CHANNEL_MIN     1
-#define CHANNEL_MAX     14
 #define CHANNEL_DEF     6
-
 DEVICE_PARAM(Channel, "Channel number");
 
 
@@ -120,23 +112,13 @@ DEVICE_PARAM(Channel, "Channel number");
 
 DEVICE_PARAM(PreambleType, "Preamble Type");
 
-
-#define RTS_THRESH_MIN     512
-#define RTS_THRESH_MAX     2347
 #define RTS_THRESH_DEF     2347
-
 DEVICE_PARAM(RTSThreshold, "RTS threshold");
 
-
-#define FRAG_THRESH_MIN     256
-#define FRAG_THRESH_MAX     2346
 #define FRAG_THRESH_DEF     2346
-
 DEVICE_PARAM(FragThreshold, "Fragmentation threshold");
 
 
-#define DATA_RATE_MIN     0
-#define DATA_RATE_MAX     13
 #define DATA_RATE_DEF     13
 /* datarate[] index
    0: indicate 1 Mbps   0x02
@@ -157,10 +139,7 @@ DEVICE_PARAM(FragThreshold, "Fragmentation threshold");
 
 DEVICE_PARAM(ConnectionRate, "Connection data rate");
 
-#define OP_MODE_MAX     2
 #define OP_MODE_DEF     0
-#define OP_MODE_MIN     0
-
 DEVICE_PARAM(OPMode, "Infrastruct, adhoc, AP mode ");
 
 /* OpMode[] is used for transmit.
@@ -176,34 +155,22 @@ DEVICE_PARAM(OPMode, "Infrastruct, adhoc, AP mode ");
 */
 
 #define PS_MODE_DEF     0
-
 DEVICE_PARAM(PSMode, "Power saving mode");
 
 
-#define SHORT_RETRY_MIN     0
-#define SHORT_RETRY_MAX     31
 #define SHORT_RETRY_DEF     8
-
-
 DEVICE_PARAM(ShortRetryLimit, "Short frame retry limits");
 
-#define LONG_RETRY_MIN     0
-#define LONG_RETRY_MAX     15
 #define LONG_RETRY_DEF     4
-
-
 DEVICE_PARAM(LongRetryLimit, "long frame retry limits");
 
-
 /* BasebandType[] baseband type selected
    0: indicate 802.11a type
    1: indicate 802.11b type
    2: indicate 802.11g type
 */
-#define BBP_TYPE_MIN     0
-#define BBP_TYPE_MAX     2
-#define BBP_TYPE_DEF     2
 
+#define BBP_TYPE_DEF     2
 DEVICE_PARAM(BasebandType, "baseband type");
 
 
-- 
1.7.10.4

