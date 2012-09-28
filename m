Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032096Ab2I1U6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:58:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58739 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422954Ab2I1UsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:00 -0400
X-Sasl-enc: LJmevmpIkGYNgSemljj0T2suc8aiu6rIKBl14HVbfvYG 1348865279
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Horst Schirmeier <horst@schirmeier.com>
Subject: [ 074/127] USB: ftdi_sio: PID for NZR SEM 16+ USB
Date: Fri, 28 Sep 2012 13:34:07 -0700
Message-Id: <20120928203054.547106677@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -702,6 +702,7 @@ static struct usb_device_id id_table_com
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


