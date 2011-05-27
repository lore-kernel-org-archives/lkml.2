Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1E0FbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:31:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2110 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1E0FbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:31:10 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] [media] DVB: Make declarations of struct usb_device_id const
Date: Thu, 26 May 2011 22:31:00 -0700
Message-Id: <67a2a12e29e7a0d667bf3c13680d1a9daad818b1.1306473714.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.2.365.g5cfe4
In-Reply-To: <cover.1306473713.git.joe@perches.com>
References: <cover.1306473713.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Const is still good.

Most declarations are static, dib0700 is just const.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/dvb-usb/a800.c            |    2 +-
 drivers/media/dvb/dvb-usb/af9005.c          |    2 +-
 drivers/media/dvb/dvb-usb/af9015.c          |    2 +-
 drivers/media/dvb/dvb-usb/anysee.c          |    2 +-
 drivers/media/dvb/dvb-usb/au6610.c          |    2 +-
 drivers/media/dvb/dvb-usb/az6027.c          |    2 +-
 drivers/media/dvb/dvb-usb/ce6230.c          |    2 +-
 drivers/media/dvb/dvb-usb/cinergyT2-core.c  |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c           |    2 +-
 drivers/media/dvb/dvb-usb/dib0700.h         |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c       |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c       |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c          |    2 +-
 drivers/media/dvb/dvb-usb/dtt200u.c         |    2 +-
 drivers/media/dvb/dvb-usb/dtv5100.c         |    2 +-
 drivers/media/dvb/dvb-usb/dw2102.c          |    2 +-
 drivers/media/dvb/dvb-usb/ec168.c           |    2 +-
 drivers/media/dvb/dvb-usb/friio.c           |    2 +-
 drivers/media/dvb/dvb-usb/gl861.c           |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk.c          |    2 +-
 drivers/media/dvb/dvb-usb/lmedm04.c         |    2 +-
 drivers/media/dvb/dvb-usb/m920x.c           |    2 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c     |    2 +-
 drivers/media/dvb/dvb-usb/opera1.c          |    2 +-
 drivers/media/dvb/dvb-usb/technisat-usb2.c  |    2 +-
 drivers/media/dvb/dvb-usb/ttusb2.c          |    2 +-
 drivers/media/dvb/dvb-usb/umt-010.c         |    2 +-
 drivers/media/dvb/dvb-usb/vp702x.c          |    2 +-
 drivers/media/dvb/dvb-usb/vp7045.c          |    2 +-
 30 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 0cf875c..986beea 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -111,7 +111,7 @@ static int a800_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id a800_table[] = {
+static const struct usb_device_id a800_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_AVERMEDIA,     USB_PID_AVERMEDIA_DVBT_USB2_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_AVERMEDIA,     USB_PID_AVERMEDIA_DVBT_USB2_WARM) },
 			{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
index 51f6439..77ffe18 100644
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -977,7 +977,7 @@ static int af9005_usb_probe(struct usb_interface *intf,
 				   THIS_MODULE, NULL, adapter_nr);
 }
 
-static struct usb_device_id af9005_usb_table[] = {
+static const struct usb_device_id af9005_usb_table[] = {
 	{USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9005)},
 	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_USB_XE)},
 	{USB_DEVICE(USB_VID_ANSONIC, USB_PID_ANSONIC_DVBT_USB)},
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 100ebc3..37b2b22 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1268,7 +1268,7 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	return ret;
 }
 
-static struct usb_device_id af9015_usb_table[] = {
+static const struct usb_device_id af9015_usb_table[] = {
 /*  0 */{USB_DEVICE(USB_VID_AFATECH,   USB_PID_AFATECH_AF9015_9015)},
 	{USB_DEVICE(USB_VID_AFATECH,   USB_PID_AFATECH_AF9015_9016)},
 	{USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_GOLD)},
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 4dc1ca3..bd7ea87 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -863,7 +863,7 @@ static int anysee_probe(struct usb_interface *intf,
 	return anysee_init(d);
 }
 
-static struct usb_device_id anysee_table[] = {
+static const struct usb_device_id anysee_table[] = {
 	{ USB_DEVICE(USB_VID_CYPRESS, USB_PID_ANYSEE) },
 	{ USB_DEVICE(USB_VID_AMT,     USB_PID_ANYSEE) },
 	{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index e41f52b..6f55dd8 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -188,7 +188,7 @@ static int au6610_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id au6610_table[] = {
+static const struct usb_device_id au6610_table[] = {
 	{ USB_DEVICE(USB_VID_ALCOR_MICRO, USB_PID_SIGMATEK_DVB_110) },
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 57e2444..ff53d82 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -1083,7 +1083,7 @@ int az6027_identify_state(struct usb_device *udev,
 }
 
 
-static struct usb_device_id az6027_usb_table[] = {
+static const struct usb_device_id az6027_usb_table[] = {
 	{ USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_AZ6027) },
 	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V1) },
 	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V2) },
diff --git a/drivers/media/dvb/dvb-usb/ce6230.c b/drivers/media/dvb/dvb-usb/ce6230.c
index 6d1a304..1917328 100644
--- a/drivers/media/dvb/dvb-usb/ce6230.c
+++ b/drivers/media/dvb/dvb-usb/ce6230.c
@@ -255,7 +255,7 @@ static int ce6230_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id ce6230_table[] = {
+static const struct usb_device_id ce6230_table[] = {
 	{ USB_DEVICE(USB_VID_INTEL, USB_PID_INTEL_CE9500) },
 	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A310) },
 	{ } /* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-core.c b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
index 16f2ce2..eb51c84 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-core.c
@@ -186,7 +186,7 @@ static int cinergyt2_usb_probe(struct usb_interface *intf,
 }
 
 
-static struct usb_device_id cinergyt2_usb_table[] = {
+static const struct usb_device_id cinergyt2_usb_table[] = {
 	{ USB_DEVICE(USB_VID_TERRATEC, 0x0038) },
 	{ 0 }
 };
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 6385409..fc56d57 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1348,7 +1348,7 @@ static int cxusb_probe(struct usb_interface *intf,
 	return -EINVAL;
 }
 
-static struct usb_device_id cxusb_table[] = {
+static const struct usb_device_id cxusb_table[] = {
 	{ USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_COLD) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_WARM) },
diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index 9bd6d51..66d83d5 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -68,6 +68,6 @@ extern int dib0700_set_i2c_speed(struct dvb_usb_device *d, u16 scl_kHz);
 extern int dib0700_device_count;
 extern int dvb_usb_dib0700_ir_proto;
 extern struct dvb_usb_device_properties dib0700_devices[];
-extern struct usb_device_id dib0700_usb_id_table[];
+extern const struct usb_device_id dib0700_usb_id_table[];
 
 #endif
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index c519ad5..beee619 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -2722,7 +2722,7 @@ static int mxl5007t_tuner_attach(struct dvb_usb_adapter *adap)
 
 
 /* DVB-USB and USB stuff follows */
-struct usb_device_id dib0700_usb_id_table[] = {
+const struct usb_device_id dib0700_usb_id_table[] = {
 /* 0 */	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7700P) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK7700P_PC) },
 	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500) },
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index d807309..2e9c850 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -123,7 +123,7 @@ static int dibusb_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id dibusb_dib3000mb_table[] = {
+static const struct usb_device_id dibusb_dib3000mb_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WARM) },
 /* 02 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_COLD) },
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/dvb/dvb-usb/dibusb-mc.c
index 8deec01..4b3e60d 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mc.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mc.c
@@ -27,7 +27,7 @@ static int dibusb_mc_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id dibusb_dib3000mc_table[] = {
+static const struct usb_device_id dibusb_dib3000mc_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3001_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3001_WARM) },
 /* 02 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_USB2_COLD) },
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index f4554dc..b57325f 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -275,7 +275,7 @@ static int digitv_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id digitv_table[] = {
+static const struct usb_device_id digitv_table[] = {
 		{ USB_DEVICE(USB_VID_ANCHOR, USB_PID_NEBULA_DIGITV) },
 		{ }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index b4d54fb..ca4f39d 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -118,7 +118,7 @@ static int dtt200u_usb_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
-static struct usb_device_id dtt200u_usb_table[] = {
+static const struct usb_device_id dtt200u_usb_table[] = {
 	{ USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_DTT200U_COLD) },
 	{ USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_DTT200U_WARM) },
 	{ USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_WT220U_COLD)  },
diff --git a/drivers/media/dvb/dvb-usb/dtv5100.c b/drivers/media/dvb/dvb-usb/dtv5100.c
index 078ce92..b7b136c 100644
--- a/drivers/media/dvb/dvb-usb/dtv5100.c
+++ b/drivers/media/dvb/dvb-usb/dtv5100.c
@@ -166,7 +166,7 @@ static int dtv5100_probe(struct usb_interface *intf,
 	return 0;
 }
 
-static struct usb_device_id dtv5100_table[] = {
+static const struct usb_device_id dtv5100_table[] = {
 	{ USB_DEVICE(0x06be, 0xa232) },
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 058b231..14f4eb0 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -1435,7 +1435,7 @@ static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	return 0;
 }
 
-static struct usb_device_id dw2102_table[] = {
+static const struct usb_device_id dw2102_table[] = {
 	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2102)},
 	{USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
 	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2104)},
diff --git a/drivers/media/dvb/dvb-usb/ec168.c b/drivers/media/dvb/dvb-usb/ec168.c
index 1ba3e5d..dfdc0382 100644
--- a/drivers/media/dvb/dvb-usb/ec168.c
+++ b/drivers/media/dvb/dvb-usb/ec168.c
@@ -353,7 +353,7 @@ error:
 #define E3C_EC168_1001                          3
 #define E3C_EC168_1002                          4
 
-static struct usb_device_id ec168_id[] = {
+static const struct usb_device_id ec168_id[] = {
 	[E3C_EC168_1689] =
 		{USB_DEVICE(USB_VID_E3C, USB_PID_E3C_EC168)},
 	[E3C_EC168_FFFA] =
diff --git a/drivers/media/dvb/dvb-usb/friio.c b/drivers/media/dvb/dvb-usb/friio.c
index 76159ae..b73b16b 100644
--- a/drivers/media/dvb/dvb-usb/friio.c
+++ b/drivers/media/dvb/dvb-usb/friio.c
@@ -455,7 +455,7 @@ static struct i2c_algorithm gl861_i2c_algo = {
 	.functionality = gl861_i2c_func,
 };
 
-static struct usb_device_id friio_table[] = {
+static const struct usb_device_id friio_table[] = {
 	{ USB_DEVICE(USB_VID_774, USB_PID_FRIIO_WHITE) },
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/dvb/dvb-usb/gl861.c
index b158458..ab5b606 100644
--- a/drivers/media/dvb/dvb-usb/gl861.c
+++ b/drivers/media/dvb/dvb-usb/gl861.c
@@ -152,7 +152,7 @@ static int gl861_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id gl861_table[] = {
+static const struct usb_device_id gl861_table[] = {
 		{ USB_DEVICE(USB_VID_MSI, USB_PID_MSI_MEGASKY580_55801) },
 		{ USB_DEVICE(USB_VID_ALINK, USB_VID_ALINK_DTU) },
 		{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 6185a1b..2e0c700 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -250,7 +250,7 @@ static int gp8psk_usb_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id gp8psk_usb_table[] = {
+static const struct usb_device_id gp8psk_usb_table[] = {
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_COLD) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index f36f471..83ee70a 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -1167,7 +1167,7 @@ static int lme2510_probe(struct usb_interface *intf,
 
 }
 
-static struct usb_device_id lme2510_table[] = {
+static const struct usb_device_id lme2510_table[] = {
 	{ USB_DEVICE(0x3344, 0x1122) },  /* LME2510 */
 	{ USB_DEVICE(0x3344, 0x1120) },  /* LME2510C */
 	{}		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index ec89671..64f5349 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -773,7 +773,7 @@ static int m920x_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id m920x_table[] = {
+static const struct usb_device_id m920x_table[] = {
 		{ USB_DEVICE(USB_VID_MSI, USB_PID_MSI_MEGASKY580) },
 		{ USB_DEVICE(USB_VID_ANUBIS_ELECTRONIC,
 			     USB_PID_MSI_DIGI_VOX_MINI_II) },
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
index acfc1cd..d26b4b2 100644
--- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -150,7 +150,7 @@ static int nova_t_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id nova_t_table[] = {
+static const struct usb_device_id nova_t_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_HAUPPAUGE,     USB_PID_WINTV_NOVA_T_USB2_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_HAUPPAUGE,     USB_PID_WINTV_NOVA_T_USB2_WARM) },
 			{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index 2e4fab7..fffa96d 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -427,7 +427,7 @@ static int opera1_rc_query(struct dvb_usb_device *dev, u32 * event, int *state)
 	return 0;
 }
 
-static struct usb_device_id opera1_table[] = {
+static const struct usb_device_id opera1_table[] = {
 	{USB_DEVICE(USB_VID_CYPRESS, USB_PID_OPERA1_COLD)},
 	{USB_DEVICE(USB_VID_OPERA1, USB_PID_OPERA1_WARM)},
 	{}
diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
index 08f8842..bd9decb 100644
--- a/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -673,7 +673,7 @@ static int technisat_usb2_rc_query(struct dvb_usb_device *d)
 }
 
 /* DVB-USB and USB stuff follows */
-static struct usb_device_id technisat_usb2_id_table[] = {
+static const struct usb_device_id technisat_usb2_id_table[] = {
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_DVB_S2) },
 	{ 0 }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index 90ca450..90ae8a8 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -255,7 +255,7 @@ static int ttusb2_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
-static struct usb_device_id ttusb2_table[] = {
+static const struct usb_device_id ttusb2_table[] = {
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_400E) },
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
 	{ USB_DEVICE(USB_VID_TECHNOTREND,
diff --git a/drivers/media/dvb/dvb-usb/umt-010.c b/drivers/media/dvb/dvb-usb/umt-010.c
index 4c98067..1b4f03c 100644
--- a/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/drivers/media/dvb/dvb-usb/umt-010.c
@@ -84,7 +84,7 @@ static int umt_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id umt_table[] = {
+static const struct usb_device_id umt_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_HANFTEK, USB_PID_HANFTEK_UMT_010_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_HANFTEK, USB_PID_HANFTEK_UMT_010_WARM) },
 			{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 291b4fa..bcb1e30 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -365,7 +365,7 @@ static void vp702x_usb_disconnect(struct usb_interface *intf)
 	dvb_usb_device_exit(intf);
 }
 
-static struct usb_device_id vp702x_usb_table[] = {
+static const struct usb_device_id vp702x_usb_table[] = {
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7021_COLD) },
 //	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7020_COLD) },
 //	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7020_WARM) },
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index a3d7248..697342b 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -246,7 +246,7 @@ static void vp7045_usb_disconnect(struct usb_interface *intf)
 	dvb_usb_device_exit(intf);
 }
 
-static struct usb_device_id vp7045_usb_table[] = {
+static const struct usb_device_id vp7045_usb_table[] = {
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7045_COLD) },
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7045_WARM) },
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_DNTV_TINYUSB2_COLD) },
-- 
1.7.5.2.365.g5cfe4

