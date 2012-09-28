Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2I1TBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:01:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab2I1TB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Horst Schirmeier <horst@schirmeier.com>
Subject: [ 153/262] USB: ftdi_sio: PID for NZR SEM 16+ USB
Date: Fri, 28 Sep 2012 11:51:22 -0700
Message-Id: <20120928183016.069747760@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horst Schirmeier <horst@schirmeier.com>

commit 26a538b9ea2a3ee10dafc0068f0560dfd7b7ba37 upstream.

This adds the USB PID for the NZR SEM 16+ USB energy monitor device
<http://www.nzr.de>.  It works perfectly with the GPL software on
<http://schou.dk/linux/sparometer/>.

Signed-off-by: Horst Schirmeier <horst@schirmeier.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -704,6 +704,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_PCDJ_DAC2_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NZR_SEM_USB_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_1_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_OPC_U_UC_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C1_PID) },
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


