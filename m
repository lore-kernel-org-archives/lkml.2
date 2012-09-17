Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2IQAvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33476 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150Ab2IQAtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:49 -0400
Message-Id: <20120917003641.986936686@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Horst Schirmeier <horst@schirmeier.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 114/135] USB: ftdi_sio: PID for NZR SEM 16+ USB
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horst Schirmeier <horst@schirmeier.com>

commit 26a538b9ea2a3ee10dafc0068f0560dfd7b7ba37 upstream.

This adds the USB PID for the NZR SEM 16+ USB energy monitor device
<http://www.nzr.de>.  It works perfectly with the GPL software on
<http://schou.dk/linux/sparometer/>.

Signed-off-by: Horst Schirmeier <horst@schirmeier.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1197d47..e2fa788 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -704,6 +704,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_PCDJ_DAC2_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NZR_SEM_USB_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_1_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_OPC_U_UC_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C1_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 080d158..9bcaf9c 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -75,6 +75,9 @@
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
 
+/* NZR SEM 16+ USB (http://www.nzr.de) */
+#define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */
+
 /*
  * RR-CirKits LocoBuffer USB (http://www.rr-cirkits.com)
  */


