Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab1E0FbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:31:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2099 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1E0FbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:31:08 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] treewide: Make usb_device_id declarations const where possible
Date: Thu, 26 May 2011 22:30:57 -0700
Message-Id: <0e345d88ad74e484a72dd5b7e335a6b9d4054e33.1306473713.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.2.365.g5cfe4
In-Reply-To: <cover.1306473713.git.joe@perches.com>
References: <cover.1306473713.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Const is good.  Reduce data, increase text.

Standardize the declarations that have a space after
the variable name and array brackets too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/bluetooth/ath3k.c                         |    4 ++--
 drivers/bluetooth/bfusb.c                         |    2 +-
 drivers/bluetooth/bpa10x.c                        |    2 +-
 drivers/bluetooth/btusb.c                         |    4 ++--
 drivers/hid/usbhid/usbkbd.c                       |    2 +-
 drivers/hid/usbhid/usbmouse.c                     |    2 +-
 drivers/input/joystick/iforce/iforce-usb.c        |    2 +-
 drivers/input/joystick/xpad.c                     |    2 +-
 drivers/input/misc/ati_remote.c                   |    2 +-
 drivers/input/misc/ati_remote2.c                  |    2 +-
 drivers/input/misc/keyspan_remote.c               |    2 +-
 drivers/input/misc/powermate.c                    |    2 +-
 drivers/input/mouse/appletouch.c                  |    2 +-
 drivers/input/tablet/acecad.c                     |    2 +-
 drivers/input/tablet/kbtab.c                      |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h             |    2 +-
 drivers/isdn/hisax/hfc_usb.c                      |    2 +-
 drivers/isdn/hisax/st5481_init.c                  |    2 +-
 drivers/media/dvb/b2c2/flexcop-usb.c              |    2 +-
 drivers/media/dvb/dvb-usb/a800.c                  |    2 +-
 drivers/media/dvb/dvb-usb/au6610.c                |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c             |    2 +-
 drivers/media/dvb/dvb-usb/dibusb-mc.c             |    2 +-
 drivers/media/dvb/dvb-usb/digitv.c                |    2 +-
 drivers/media/dvb/dvb-usb/dtt200u.c               |    2 +-
 drivers/media/dvb/dvb-usb/gl861.c                 |    2 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                |    2 +-
 drivers/media/dvb/dvb-usb/m920x.c                 |    2 +-
 drivers/media/dvb/dvb-usb/nova-t-usb2.c           |    2 +-
 drivers/media/dvb/dvb-usb/ttusb2.c                |    2 +-
 drivers/media/dvb/dvb-usb/umt-010.c               |    2 +-
 drivers/media/dvb/dvb-usb/vp702x.c                |    2 +-
 drivers/media/dvb/dvb-usb/vp7045.c                |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    2 +-
 drivers/media/radio/dsbr100.c                     |    2 +-
 drivers/media/radio/radio-mr800.c                 |    2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c     |    2 +-
 drivers/media/rc/imon.c                           |    2 +-
 drivers/media/rc/mceusb.c                         |    2 +-
 drivers/media/rc/redrat3.c                        |    2 +-
 drivers/media/rc/streamzap.c                      |    2 +-
 drivers/media/video/au0828/au0828-cards.c         |    2 +-
 drivers/media/video/au0828/au0828.h               |    2 +-
 drivers/media/video/cpia2/cpia2_usb.c             |    2 +-
 drivers/media/video/cx231xx/cx231xx-cards.c       |    2 +-
 drivers/media/video/cx231xx/cx231xx.h             |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c         |    2 +-
 drivers/media/video/em28xx/em28xx.h               |    2 +-
 drivers/media/video/hdpvr/hdpvr-core.c            |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c     |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.h     |    2 +-
 drivers/media/video/s2255drv.c                    |    2 +-
 drivers/media/video/stk-webcam.c                  |    2 +-
 drivers/media/video/tlg2300/pd-main.c             |    2 +-
 drivers/media/video/usbvision/usbvision-cards.c   |    2 +-
 drivers/media/video/usbvision/usbvision.h         |    2 +-
 drivers/media/video/uvc/uvc_driver.c              |    2 +-
 drivers/media/video/zr364xx.c                     |    2 +-
 drivers/mmc/host/ushc.c                           |    2 +-
 drivers/mmc/host/vub300.c                         |    2 +-
 drivers/net/can/usb/ems_usb.c                     |    2 +-
 drivers/net/can/usb/esd_usb2.c                    |    2 +-
 drivers/net/irda/irda-usb.c                       |    2 +-
 drivers/net/irda/kingsun-sir.c                    |    2 +-
 drivers/net/irda/ks959-sir.c                      |    2 +-
 drivers/net/irda/ksdazzle-sir.c                   |    2 +-
 drivers/net/irda/mcs7780.c                        |    2 +-
 drivers/net/irda/stir4200.c                       |    2 +-
 drivers/net/usb/catc.c                            |    2 +-
 drivers/net/usb/cdc-phonet.c                      |    2 +-
 drivers/net/usb/ipheth.c                          |    2 +-
 drivers/net/usb/kaweth.c                          |    2 +-
 drivers/net/usb/rtl8150.c                         |    2 +-
 drivers/net/wimax/i2400m/usb.c                    |    3 +--
 drivers/net/wireless/at76c50x-usb.c               |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c          |    2 +-
 drivers/net/wireless/ath/carl9170/usb.c           |    2 +-
 drivers/net/wireless/libertas/if_usb.c            |    2 +-
 drivers/net/wireless/libertas_tf/if_usb.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c        |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c           |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c           |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c             |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |    2 +-
 drivers/net/wireless/zd1201.c                     |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.c            |    2 +-
 drivers/usb/atm/speedtch.c                        |    2 +-
 drivers/usb/core/otg_whitelist.h                  |    4 ++--
 drivers/usb/host/hwa-hc.c                         |    2 +-
 drivers/usb/misc/yurex.c                          |    2 +-
 drivers/usb/serial/ftdi_sio.c                     |    2 +-
 drivers/usb/serial/ipaq.c                         |    2 +-
 drivers/usb/serial/qcaux.c                        |    2 +-
 drivers/usb/serial/visor.c                        |   10 +++++-----
 drivers/usb/serial/vivopay-serial.c               |    2 +-
 drivers/usb/storage/alauda.c                      |    2 +-
 drivers/usb/storage/cypress_atacb.c               |    2 +-
 drivers/usb/storage/datafab.c                     |    2 +-
 drivers/usb/storage/ene_ub6250.c                  |    2 +-
 drivers/usb/storage/freecom.c                     |    2 +-
 drivers/usb/storage/isd200.c                      |    2 +-
 drivers/usb/storage/jumpshot.c                    |    2 +-
 drivers/usb/storage/karma.c                       |    2 +-
 drivers/usb/storage/onetouch.c                    |    2 +-
 drivers/usb/storage/sddr09.c                      |    2 +-
 drivers/usb/storage/sddr55.c                      |    2 +-
 drivers/usb/storage/shuttle_usbat.c               |    2 +-
 drivers/usb/storage/uas.c                         |    2 +-
 drivers/usb/storage/usual-tables.c                |    2 +-
 drivers/video/udlfb.c                             |    2 +-
 drivers/w1/masters/ds2490.c                       |    2 +-
 drivers/watchdog/pcwd_usb.c                       |    2 +-
 include/linux/usb_usual.h                         |    2 +-
 sound/usb/6fire/chip.c                            |    2 +-
 sound/usb/caiaq/device.c                          |    2 +-
 sound/usb/misc/ua101.c                            |    2 +-
 sound/usb/usx2y/us122l.c                          |    2 +-
 sound/usb/usx2y/usbusx2y.c                        |    2 +-
 120 files changed, 127 insertions(+), 128 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 6bacef3..660458e 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -56,7 +56,7 @@ struct ath3k_version {
 	unsigned char	reserved[0x07];
 };
 
-static struct usb_device_id ath3k_table[] = {
+static const struct usb_device_id ath3k_table[] = {
 	/* Atheros AR3011 */
 	{ USB_DEVICE(0x0CF3, 0x3000) },
 
@@ -81,7 +81,7 @@ MODULE_DEVICE_TABLE(usb, ath3k_table);
 #define BTUSB_ATH3012		0x80
 /* This table is to load patch and sysconfig files
  * for AR3012 */
-static struct usb_device_id ath3k_blist_tbl[] = {
+static const struct usb_device_id ath3k_blist_tbl[] = {
 
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 005919a..0856ddd 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -42,7 +42,7 @@
 
 static struct usb_driver bfusb_driver;
 
-static struct usb_device_id bfusb_table[] = {
+static const struct usb_device_id bfusb_table[] = {
 	/* AVM BlueFRITZ! USB */
 	{ USB_DEVICE(0x057c, 0x2200) },
 
diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 751b338..27cfc02 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -37,7 +37,7 @@
 
 #define VERSION "0.10"
 
-static struct usb_device_id bpa10x_table[] = {
+static const struct usb_device_id bpa10x_table[] = {
 	/* Tektronix BPA 100/105 (Digianswer) */
 	{ USB_DEVICE(0x08fd, 0x0002) },
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c2de895..723f313 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -55,7 +55,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_BROKEN_ISOC	0x20
 #define BTUSB_WRONG_SCO_MTU	0x40
 
-static struct usb_device_id btusb_table[] = {
+static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
@@ -95,7 +95,7 @@ static struct usb_device_id btusb_table[] = {
 
 MODULE_DEVICE_TABLE(usb, btusb_table);
 
-static struct usb_device_id blacklist_table[] = {
+static const struct usb_device_id blacklist_table[] = {
 	/* CSR BlueCore devices */
 	{ USB_DEVICE(0x0a12, 0x0001), .driver_info = BTUSB_CSR },
 
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index 0658173..f73fd86 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -339,7 +339,7 @@ static void usb_kbd_disconnect(struct usb_interface *intf)
 	}
 }
 
-static struct usb_device_id usb_kbd_id_table [] = {
+static const struct usb_device_id usb_kbd_id_table[] = {
 	{ USB_INTERFACE_INFO(USB_INTERFACE_CLASS_HID, USB_INTERFACE_SUBCLASS_BOOT,
 		USB_INTERFACE_PROTOCOL_KEYBOARD) },
 	{ }						/* Terminating entry */
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index 79b2bf8..7f3508f 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -226,7 +226,7 @@ static void usb_mouse_disconnect(struct usb_interface *intf)
 	}
 }
 
-static struct usb_device_id usb_mouse_id_table [] = {
+static const struct usb_device_id usb_mouse_id_table[] = {
 	{ USB_INTERFACE_INFO(USB_INTERFACE_CLASS_HID, USB_INTERFACE_SUBCLASS_BOOT,
 		USB_INTERFACE_PROTOCOL_MOUSE) },
 	{ }	/* Terminating entry */
diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index 6c96631..1316c3a 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -202,7 +202,7 @@ static void iforce_usb_disconnect(struct usb_interface *intf)
 	kfree(iforce);
 }
 
-static struct usb_device_id iforce_usb_ids [] = {
+static const struct usb_device_id iforce_usb_ids[] = {
 	{ USB_DEVICE(0x044f, 0xa01c) },		/* Thrustmaster Motor Sport GT */
 	{ USB_DEVICE(0x046d, 0xc281) },		/* Logitech WingMan Force */
 	{ USB_DEVICE(0x046d, 0xc291) },		/* Logitech WingMan Formula Force */
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 56abf3d..bf4d914 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -230,7 +230,7 @@ static const signed short xpad_abs_triggers[] = {
 	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,1) }, \
 	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,129) }
 
-static struct usb_device_id xpad_table [] = {
+static const struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
index bce5712..d0f10c2 100644
--- a/drivers/input/misc/ati_remote.c
+++ b/drivers/input/misc/ati_remote.c
@@ -143,7 +143,7 @@ MODULE_PARM_DESC(repeat_delay, "Delay before sending repeats, default = 500 msec
 #undef err
 #define err(format, arg...) printk(KERN_ERR format , ## arg)
 
-static struct usb_device_id ati_remote_table[] = {
+static const struct usb_device_id ati_remote_table[] = {
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID) },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID) },
 	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID) },
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 1de58e8..91e0269 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -109,7 +109,7 @@ static struct kernel_param_ops param_ops_mode_mask = {
 module_param(mode_mask, mode_mask, 0644);
 MODULE_PARM_DESC(mode_mask, "Bitmask of modes to accept <4:PC><3:AUX4><2:AUX3><1:AUX2><0:AUX1>");
 
-static struct usb_device_id ati_remote2_id_table[] = {
+static const struct usb_device_id ati_remote2_id_table[] = {
 	{ USB_DEVICE(0x0471, 0x0602) },	/* ATI Remote Wonder II */
 	{ }
 };
diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
index fc62256..389d9f0 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -86,7 +86,7 @@ static const unsigned short keyspan_key_table[] = {
 };
 
 /* table of devices that work with this driver */
-static struct usb_device_id keyspan_table[] = {
+static const struct usb_device_id keyspan_table[] = {
 	{ USB_DEVICE(USB_KEYSPAN_VENDOR_ID, USB_KEYSPAN_PRODUCT_UIA11) },
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/input/misc/powermate.c b/drivers/input/misc/powermate.c
index f459471..bf24a0a 100644
--- a/drivers/input/misc/powermate.c
+++ b/drivers/input/misc/powermate.c
@@ -425,7 +425,7 @@ static void powermate_disconnect(struct usb_interface *intf)
 	}
 }
 
-static struct usb_device_id powermate_devices [] = {
+static const struct usb_device_id powermate_devices[] = {
 	{ USB_DEVICE(POWERMATE_VENDOR, POWERMATE_PRODUCT_NEW) },
 	{ USB_DEVICE(POWERMATE_VENDOR, POWERMATE_PRODUCT_OLD) },
 	{ USB_DEVICE(CONTOUR_VENDOR, CONTOUR_JOG) },
diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index b77f999..a313f65 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -120,7 +120,7 @@ static const struct atp_info geyser4_info = {
  *  According to Info.plist Geyser IV is the same as Geyser III.)
  */
 
-static struct usb_device_id atp_table[] = {
+static const struct usb_device_id atp_table[] = {
 	/* PowerBooks Feb 2005, iBooks G4 */
 	ATP_DEVICE(0x020e, fountain_info),	/* FOUNTAIN ANSI */
 	ATP_DEVICE(0x020f, fountain_info),	/* FOUNTAIN ISO */
diff --git a/drivers/input/tablet/acecad.c b/drivers/input/tablet/acecad.c
index d94f7e9..ed6c009 100644
--- a/drivers/input/tablet/acecad.c
+++ b/drivers/input/tablet/acecad.c
@@ -254,7 +254,7 @@ static void usb_acecad_disconnect(struct usb_interface *intf)
 	kfree(acecad);
 }
 
-static struct usb_device_id usb_acecad_id_table [] = {
+static const struct usb_device_id usb_acecad_id_table[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_ACECAD, USB_DEVICE_ID_FLAIR), .driver_info = 0 },
 	{ USB_DEVICE(USB_VENDOR_ID_ACECAD, USB_DEVICE_ID_302),	 .driver_info = 1 },
 	{ }
diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 290f4e5..120f175 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -84,7 +84,7 @@ static void kbtab_irq(struct urb *urb)
 		     __func__, retval);
 }
 
-static struct usb_device_id kbtab_ids[] = {
+static const struct usb_device_id kbtab_ids[] = {
 	{ USB_DEVICE(USB_VENDOR_ID_KBGEAR, 0x1001), .driver_info = 0 },
 	{ }
 };
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.h b/drivers/isdn/hardware/mISDN/hfcsusb.h
index 369196a..4349b5c 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.h
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.h
@@ -337,7 +337,7 @@ static const char *HFC_NT_LAYER1_STATES[HFC_MAX_NT_LAYER1_STATE + 1] = {
 };
 
 /* supported devices */
-static struct usb_device_id hfcsusb_idtab[] = {
+static const struct usb_device_id hfcsusb_idtab[] = {
 	{
 	 USB_DEVICE(0x0959, 0x2bd0),
 	 .driver_info = (unsigned long) &((struct hfcsusb_vdata)
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index f407de0e..5cc8ee8 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -65,7 +65,7 @@ typedef struct {
 } hfcsusb_vdata;
 
 /* VID/PID device list */
-static struct usb_device_id hfcusb_idtab[] = {
+static const struct usb_device_id hfcusb_idtab[] = {
 	{
 	 USB_DEVICE(0x0959, 0x2bd0),
 	 .driver_info = (unsigned long) &((hfcsusb_vdata)
diff --git a/drivers/isdn/hisax/st5481_init.c b/drivers/isdn/hisax/st5481_init.c
index 9f7fd18..659d6a6 100644
--- a/drivers/isdn/hisax/st5481_init.c
+++ b/drivers/isdn/hisax/st5481_init.c
@@ -156,7 +156,7 @@ static void disconnect_st5481(struct usb_interface *intf)
 /*
  * The last 4 bits in the Product Id is set with 4 pins on the chip.
  */
-static struct usb_device_id st5481_ids[] = {
+static const struct usb_device_id st5481_ids[] = {
 	{ USB_DEVICE(ST_VENDOR_ID, ST5481_PRODUCT_ID+0x0) },
 	{ USB_DEVICE(ST_VENDOR_ID, ST5481_PRODUCT_ID+0x1) },
 	{ USB_DEVICE(ST_VENDOR_ID, ST5481_PRODUCT_ID+0x2) },
diff --git a/drivers/media/dvb/b2c2/flexcop-usb.c b/drivers/media/dvb/b2c2/flexcop-usb.c
index bedcfb6..aac70a8 100644
--- a/drivers/media/dvb/b2c2/flexcop-usb.c
+++ b/drivers/media/dvb/b2c2/flexcop-usb.c
@@ -569,7 +569,7 @@ static void flexcop_usb_disconnect(struct usb_interface *intf)
 	info("%s successfully deinitialized and disconnected.", DRIVER_NAME);
 }
 
-static struct usb_device_id flexcop_usb_table [] = {
+static const struct usb_device_id flexcop_usb_table[] = {
 	{ USB_DEVICE(0x0af7, 0x0101) },
 	{ }
 };
diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index b95a95e..0cf875c 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -111,7 +111,7 @@ static int a800_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id a800_table [] = {
+static struct usb_device_id a800_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_AVERMEDIA,     USB_PID_AVERMEDIA_DVBT_USB2_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_AVERMEDIA,     USB_PID_AVERMEDIA_DVBT_USB2_WARM) },
 			{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index 2351077..e41f52b 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -188,7 +188,7 @@ static int au6610_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id au6610_table [] = {
+static struct usb_device_id au6610_table[] = {
 	{ USB_DEVICE(USB_VID_ALCOR_MICRO, USB_PID_SIGMATEK_DVB_110) },
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index acb5fb2..6385409 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1348,7 +1348,7 @@ static int cxusb_probe(struct usb_interface *intf,
 	return -EINVAL;
 }
 
-static struct usb_device_id cxusb_table [] = {
+static struct usb_device_id cxusb_table[] = {
 	{ USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_COLD) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_WARM) },
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index 04d91bd..d807309 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -123,7 +123,7 @@ static int dibusb_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id dibusb_dib3000mb_table [] = {
+static struct usb_device_id dibusb_dib3000mb_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WARM) },
 /* 02 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_COLD) },
diff --git a/drivers/media/dvb/dvb-usb/dibusb-mc.c b/drivers/media/dvb/dvb-usb/dibusb-mc.c
index c1d9094..8deec01 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mc.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mc.c
@@ -27,7 +27,7 @@ static int dibusb_mc_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id dibusb_dib3000mc_table [] = {
+static struct usb_device_id dibusb_dib3000mc_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3001_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3001_WARM) },
 /* 02 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_USB2_COLD) },
diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index f6344cd..f4554dc 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -275,7 +275,7 @@ static int digitv_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id digitv_table [] = {
+static struct usb_device_id digitv_table[] = {
 		{ USB_DEVICE(USB_VID_ANCHOR, USB_PID_NEBULA_DIGITV) },
 		{ }		/* Terminating entry */
 };
diff --git a/drivers/media/dvb/dvb-usb/dtt200u.c b/drivers/media/dvb/dvb-usb/dtt200u.c
index ecd86ec..b4d54fb 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u.c
@@ -118,7 +118,7 @@ static int dtt200u_usb_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
-static struct usb_device_id dtt200u_usb_table [] = {
+static struct usb_device_id dtt200u_usb_table[] = {
 	{ USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_DTT200U_COLD) },
 	{ USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_DTT200U_WARM) },
 	{ USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_WT220U_COLD)  },
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/dvb/dvb-usb/gl861.c
index 6f596ed..b158458 100644
--- a/drivers/media/dvb/dvb-usb/gl861.c
+++ b/drivers/media/dvb/dvb-usb/gl861.c
@@ -152,7 +152,7 @@ static int gl861_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id gl861_table [] = {
+static struct usb_device_id gl861_table[] = {
 		{ USB_DEVICE(USB_VID_MSI, USB_PID_MSI_MEGASKY580_55801) },
 		{ USB_DEVICE(USB_VID_ALINK, USB_VID_ALINK_DTU) },
 		{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 1cb3d9a..6185a1b 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -250,7 +250,7 @@ static int gp8psk_usb_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id gp8psk_usb_table [] = {
+static struct usb_device_id gp8psk_usb_table[] = {
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_COLD) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
 	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index 9456792..ec89671 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -773,7 +773,7 @@ static int m920x_probe(struct usb_interface *intf,
 	return ret;
 }
 
-static struct usb_device_id m920x_table [] = {
+static struct usb_device_id m920x_table[] = {
 		{ USB_DEVICE(USB_VID_MSI, USB_PID_MSI_MEGASKY580) },
 		{ USB_DEVICE(USB_VID_ANUBIS_ELECTRONIC,
 			     USB_PID_MSI_DIGI_VOX_MINI_II) },
diff --git a/drivers/media/dvb/dvb-usb/nova-t-usb2.c b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
index bc350e9..acfc1cd 100644
--- a/drivers/media/dvb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/dvb/dvb-usb/nova-t-usb2.c
@@ -150,7 +150,7 @@ static int nova_t_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id nova_t_table [] = {
+static struct usb_device_id nova_t_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_HAUPPAUGE,     USB_PID_WINTV_NOVA_T_USB2_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_HAUPPAUGE,     USB_PID_WINTV_NOVA_T_USB2_WARM) },
 			{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index 0d4709f..90ca450 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -255,7 +255,7 @@ static int ttusb2_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
-static struct usb_device_id ttusb2_table [] = {
+static struct usb_device_id ttusb2_table[] = {
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_400E) },
 	{ USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_450E) },
 	{ USB_DEVICE(USB_VID_TECHNOTREND,
diff --git a/drivers/media/dvb/dvb-usb/umt-010.c b/drivers/media/dvb/dvb-usb/umt-010.c
index 118aab1..4c98067 100644
--- a/drivers/media/dvb/dvb-usb/umt-010.c
+++ b/drivers/media/dvb/dvb-usb/umt-010.c
@@ -84,7 +84,7 @@ static int umt_probe(struct usb_interface *intf,
 }
 
 /* do not change the order of the ID table */
-static struct usb_device_id umt_table [] = {
+static struct usb_device_id umt_table[] = {
 /* 00 */	{ USB_DEVICE(USB_VID_HANFTEK, USB_PID_HANFTEK_UMT_010_COLD) },
 /* 01 */	{ USB_DEVICE(USB_VID_HANFTEK, USB_PID_HANFTEK_UMT_010_WARM) },
 			{ }		/* Terminating entry */
diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 54355f8..291b4fa 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -365,7 +365,7 @@ static void vp702x_usb_disconnect(struct usb_interface *intf)
 	dvb_usb_device_exit(intf);
 }
 
-static struct usb_device_id vp702x_usb_table [] = {
+static struct usb_device_id vp702x_usb_table[] = {
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7021_COLD) },
 //	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7020_COLD) },
 //	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7020_WARM) },
diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index 3db89e3..a3d7248 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -246,7 +246,7 @@ static void vp7045_usb_disconnect(struct usb_interface *intf)
 	dvb_usb_device_exit(intf);
 }
 
-static struct usb_device_id vp7045_usb_table [] = {
+static struct usb_device_id vp7045_usb_table[] = {
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7045_COLD) },
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_TWINHAN_VP7045_WARM) },
 	    { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_DNTV_TINYUSB2_COLD) },
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 420bb42..dcdb1b4 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1778,7 +1778,7 @@ static void ttusb_disconnect(struct usb_interface *intf)
 	dprintk("%s: TTUSB DVB disconnected\n", __func__);
 }
 
-static struct usb_device_id ttusb_table[] = {
+static const struct usb_device_id ttusb_table[] = {
 	{USB_DEVICE(0xb48, 0x1003)},
 	{USB_DEVICE(0xb48, 0x1004)},
 	{USB_DEVICE(0xb48, 0x1005)},
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index f893bff..db6ce93 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1741,7 +1741,7 @@ static void ttusb_dec_set_model(struct ttusb_dec *dec,
 	}
 }
 
-static struct usb_device_id ttusb_dec_table[] = {
+static const struct usb_device_id ttusb_dec_table[] = {
 	{USB_DEVICE(0x0b48, 0x1006)},	/* DEC3000-s */
 	/*{USB_DEVICE(0x0b48, 0x1007)},	   Unconfirmed */
 	{USB_DEVICE(0x0b48, 0x1008)},	/* DEC2000-t */
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 3d8cc42..f4c988d 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -154,7 +154,7 @@ struct dsbr100_device {
 	int status;
 };
 
-static struct usb_device_id usb_dsbr100_device_table [] = {
+static const struct usb_device_id usb_dsbr100_device_table[] = {
 	{ USB_DEVICE(DSB100_VENDOR, DSB100_PRODUCT) },
 	{ }						/* Terminating entry */
 };
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index b3a635b..4571b2f 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -149,7 +149,7 @@ static inline struct amradio_device *to_amradio_dev(struct v4l2_device *v4l2_dev
 }
 
 /* USB Device ID List */
-static struct usb_device_id usb_amradio_device_table[] = {
+static const struct usb_device_id usb_amradio_device_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB_AMRADIO_VENDOR, USB_AMRADIO_PRODUCT,
 							USB_CLASS_HID, 0, 0) },
 	{ }						/* Terminating entry */
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 392e84f..5088551 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -43,7 +43,7 @@
 
 
 /* USB Device ID List */
-static struct usb_device_id si470x_usb_driver_id_table[] = {
+static const struct usb_device_id si470x_usb_driver_id_table[] = {
 	/* Silicon Labs USB FM Radio Reference Design */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a, USB_CLASS_HID, 0, 0) },
 	/* ADS/Tech FM Radio Receiver (formerly Instant FM Music) */
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 3f3c707..1d05ec2 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -195,7 +195,7 @@ enum {
  * devices use the SoundGraph vendor ID (0x15c2). This driver only supports
  * the ffdc and later devices, which do onboard decoding.
  */
-static struct usb_device_id imon_usb_id_table[] = {
+static const struct usb_device_id imon_usb_id_table[] = {
 	/*
 	 * Several devices with this same device ID, all use iMON_PAD.inf
 	 * SoundGraph iMON PAD (IR & VFD)
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index ad927fc..d840a2d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -209,7 +209,7 @@ static const struct mceusb_model mceusb_model[] = {
 	},
 };
 
-static struct usb_device_id mceusb_dev_table[] = {
+static const struct usb_device_id mceusb_dev_table[] = {
 	/* Original Microsoft MCE IR Transceiver (often HP-branded) */
 	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d),
 	  .driver_info = MCE_GEN1 },
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 5147767..ae89a27 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -160,7 +160,7 @@ static int debug;
 #define USB_RR3IIUSB_PRODUCT_ID	0x0005
 
 /* table of devices that work with this driver */
-static struct usb_device_id redrat3_dev_table[] = {
+static const struct usb_device_id redrat3_dev_table[] = {
 	/* Original version of the RedRat3 */
 	{USB_DEVICE(USB_RR3USB_VENDOR_ID, USB_RR3USB_PRODUCT_ID)},
 	/* Second Version/release of the RedRat3 - RetRat3-II */
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index e435d94..7cfbd18 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -52,7 +52,7 @@ static int debug;
 #define USB_STREAMZAP_PRODUCT_ID	0x0000
 
 /* table of devices that work with this driver */
-static struct usb_device_id streamzap_table[] = {
+static const struct usb_device_id streamzap_table[] = {
 	/* Streamzap Remote Control */
 	{ USB_DEVICE(USB_STREAMZAP_VENDOR_ID, USB_STREAMZAP_PRODUCT_ID) },
 	/* Terminating entry */
diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 39fc923..0869968 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -295,7 +295,7 @@ void au0828_gpio_setup(struct au0828_dev *dev)
 }
 
 /* table of devices that work with this driver */
-struct usb_device_id au0828_usb_id_table[] = {
+const struct usb_device_id au0828_usb_id_table[] = {
 	{ USB_DEVICE(0x2040, 0x7200),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q },
 	{ USB_DEVICE(0x2040, 0x7240),
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/video/au0828/au0828.h
index 9cde353..966df25 100644
--- a/drivers/media/video/au0828/au0828.h
+++ b/drivers/media/video/au0828/au0828.h
@@ -270,7 +270,7 @@ extern int au0828_debug;
 /* ----------------------------------------------------------- */
 /* au0828-cards.c */
 extern struct au0828_board au0828_boards[];
-extern struct usb_device_id au0828_usb_id_table[];
+extern const struct usb_device_id au0828_usb_id_table[];
 extern void au0828_gpio_setup(struct au0828_dev *dev);
 extern int au0828_tuner_callback(void *priv, int component,
 				 int command, int arg);
diff --git a/drivers/media/video/cpia2/cpia2_usb.c b/drivers/media/video/cpia2/cpia2_usb.c
index dc5b07a..e73c6a2 100644
--- a/drivers/media/video/cpia2/cpia2_usb.c
+++ b/drivers/media/video/cpia2/cpia2_usb.c
@@ -61,7 +61,7 @@ static int submit_urbs(struct camera_data *cam);
 static int set_alternate(struct camera_data *cam, unsigned int alt);
 static int configure_transfer_mode(struct camera_data *cam, unsigned int alt);
 
-static struct usb_device_id cpia2_id_table[] = {
+static const struct usb_device_id cpia2_id_table[] = {
 	{USB_DEVICE(0x0553, 0x0100)},
 	{USB_DEVICE(0x0553, 0x0140)},
 	{USB_DEVICE(0x0553, 0x0151)},  /* STV0676 */
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2270381..13c3910 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -536,7 +536,7 @@ struct cx231xx_board cx231xx_boards[] = {
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
 /* table of devices that work with this driver */
-struct usb_device_id cx231xx_id_table[] = {
+const struct usb_device_id cx231xx_id_table[] = {
 	{USB_DEVICE(0x0572, 0x5A3C),
 	 .driver_info = CX231XX_BOARD_UNKNOWN},
 	{USB_DEVICE(0x0572, 0x58A2),
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 46dd840..8c5d106 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -960,7 +960,7 @@ void cx231xx_close_extension(struct cx231xx *dev);
 extern void cx231xx_pre_card_setup(struct cx231xx *dev);
 extern void cx231xx_card_setup(struct cx231xx *dev);
 extern struct cx231xx_board cx231xx_boards[];
-extern struct usb_device_id cx231xx_id_table[];
+extern const struct usb_device_id cx231xx_id_table[];
 extern const unsigned int cx231xx_bcount;
 int cx231xx_tuner_callback(void *ptr, int component, int command, int arg);
 
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 4e37375..8da4b09 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1785,7 +1785,7 @@ struct em28xx_board em28xx_boards[] = {
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
 /* table of devices that work with this driver */
-struct usb_device_id em28xx_id_table[] = {
+const struct usb_device_id em28xx_id_table[] = {
 	{ USB_DEVICE(0xeb1a, 0x2750),
 			.driver_info = EM2750_BOARD_UNKNOWN },
 	{ USB_DEVICE(0xeb1a, 0x2751),
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 3cca331..5523cae 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -690,7 +690,7 @@ extern int em2800_variant_detect(struct usb_device *udev, int model);
 extern void em28xx_pre_card_setup(struct em28xx *dev);
 extern void em28xx_card_setup(struct em28xx *dev);
 extern struct em28xx_board em28xx_boards[];
-extern struct usb_device_id em28xx_id_table[];
+extern const struct usb_device_id em28xx_id_table[];
 extern const unsigned int em28xx_bcount;
 void em28xx_register_i2c_ir(struct em28xx *dev);
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index a27d93b..6cc3db1 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -55,7 +55,7 @@ MODULE_PARM_DESC(boost_audio, "boost the audio signal");
 
 
 /* table of devices that work with this driver */
-static struct usb_device_id hdpvr_table[] = {
+static const struct usb_device_id hdpvr_table[] = {
 	{ USB_DEVICE(HD_PVR_VENDOR_ID, HD_PVR_PRODUCT_ID) },
 	{ USB_DEVICE(HD_PVR_VENDOR_ID, HD_PVR_PRODUCT_ID1) },
 	{ USB_DEVICE(HD_PVR_VENDOR_ID, HD_PVR_PRODUCT_ID2) },
diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
index e799331..b775929 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.c
@@ -518,7 +518,7 @@ static const struct pvr2_device_desc pvr2_device_751xx = {
 
 /*------------------------------------------------------------------------*/
 
-struct usb_device_id pvr2_device_table[] = {
+const struct usb_device_id pvr2_device_table[] = {
 	{ USB_DEVICE(0x2040, 0x2900),
 	  .driver_info = (kernel_ulong_t)&pvr2_device_29xxx},
 	{ USB_DEVICE(0x2040, 0x2950), /* Logically identical to 2900 */
diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.h b/drivers/media/video/pvrusb2/pvrusb2-devattr.h
index 273c8d4..610b07d 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.h
@@ -184,7 +184,7 @@ struct pvr2_device_desc {
 	unsigned int flag_is_experimental:1;
 };
 
-extern struct usb_device_id pvr2_device_table[];
+extern const struct usb_device_id pvr2_device_table[];
 
 #endif /* __PVRUSB2_HDW_INTERNAL_H */
 
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 5b9dce8..57a67b8 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -408,7 +408,7 @@ MODULE_PARM_DESC(jpeg_enable, "Jpeg enable(1-on 0-off) default 1");
 
 /* USB device table */
 #define USB_SENSORAY_VID	0x1943
-static struct usb_device_id s2255_table[] = {
+static const struct usb_device_id s2255_table[] = {
 	{USB_DEVICE(USB_SENSORAY_VID, 0x2255)},
 	{USB_DEVICE(USB_SENSORAY_VID, 0x2257)}, /*same family as 2255*/
 	{ }			/* Terminating entry */
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index d1a2cef..1567205 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -57,7 +57,7 @@ MODULE_DESCRIPTION("Syntek DC1125 webcam driver");
 
 
 /* Some cameras have audio interfaces, we aren't interested in those */
-static struct usb_device_id stkwebcam_table[] = {
+static const struct usb_device_id stkwebcam_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x174f, 0xa311, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x05e1, 0x0501, 0xff, 0xff, 0xff) },
 	{ }
diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index 99c81a9..d228d0a 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -42,7 +42,7 @@
 
 #define VENDOR_ID	0x1B24
 #define PRODUCT_ID	0x4001
-static struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID, PRODUCT_ID, 255, 1, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID, PRODUCT_ID, 255, 1, 1) },
 	{ },
diff --git a/drivers/media/video/usbvision/usbvision-cards.c b/drivers/media/video/usbvision/usbvision-cards.c
index 8f52661..ef9ada2 100644
--- a/drivers/media/video/usbvision/usbvision-cards.c
+++ b/drivers/media/video/usbvision/usbvision-cards.c
@@ -1058,7 +1058,7 @@ const int usbvision_device_data_size = ARRAY_SIZE(usbvision_device_data);
 
 /* Supported Devices */
 
-struct usb_device_id usbvision_table[] = {
+const struct usb_device_id usbvision_table[] = {
 	{ USB_DEVICE(0x0a6f, 0x0400), .driver_info = XANBOO },
 	{ USB_DEVICE(0x050d, 0x0106), .driver_info = BELKIN_VIDEOBUS_II },
 	{ USB_DEVICE(0x050d, 0x0207), .driver_info = BELKIN_VIDEOBUS },
diff --git a/drivers/media/video/usbvision/usbvision.h b/drivers/media/video/usbvision/usbvision.h
index 43cf61f..b132a24 100644
--- a/drivers/media/video/usbvision/usbvision.h
+++ b/drivers/media/video/usbvision/usbvision.h
@@ -361,7 +361,7 @@ struct usbvision_device_data_st {
 
 /* Declared on usbvision-cards.c */
 extern struct usbvision_device_data_st usbvision_device_data[];
-extern struct usb_device_id usbvision_table[];
+extern const struct usb_device_id usbvision_table[];
 
 struct usb_usbvision {
 	struct v4l2_device v4l2_dev;
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b6eae48..c9b5803 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2026,7 +2026,7 @@ MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
  * VENDOR_SPEC because they don't announce themselves as UVC devices, even
  * though they are compliant.
  */
-static struct usb_device_id uvc_ids[] = {
+static const struct usb_device_id uvc_ids[] = {
 	/* Genius eFace 2025 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 7dfb01e..1a4ab2b 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -95,7 +95,7 @@ MODULE_PARM_DESC(mode, "0 = 320x240, 1 = 160x120, 2 = 640x480");
 
 /* Devices supported by this driver
  * .driver_info contains the init method used by the camera */
-static struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x08ca, 0x0109), .driver_info = METHOD0 },
 	{USB_DEVICE(0x041e, 0x4024), .driver_info = METHOD0 },
 	{USB_DEVICE(0x0d64, 0x0108), .driver_info = METHOD0 },
diff --git a/drivers/mmc/host/ushc.c b/drivers/mmc/host/ushc.c
index f08f944..d127407 100644
--- a/drivers/mmc/host/ushc.c
+++ b/drivers/mmc/host/ushc.c
@@ -548,7 +548,7 @@ static void ushc_disconnect(struct usb_interface *intf)
 	ushc_clean_up(ushc);
 }
 
-static struct usb_device_id ushc_id_table[] = {
+static const struct usb_device_id ushc_id_table[] = {
 	/* CSR USB SD Host Controller */
 	{ USB_DEVICE(0x0a12, 0x5d10) },
 	{ },
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index cbb0330..b44c573 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -266,7 +266,7 @@ MODULE_PARM_DESC(firmware_rom_wait_states,
 #define ELAN_VENDOR_ID		0x2201
 #define VUB300_VENDOR_ID	0x0424
 #define VUB300_PRODUCT_ID	0x012C
-static struct usb_device_id vub300_table[] = {
+static const struct usb_device_id vub300_table[] = {
 	{USB_DEVICE(ELAN_VENDOR_ID, VUB300_PRODUCT_ID)},
 	{USB_DEVICE(VUB300_VENDOR_ID, VUB300_PRODUCT_ID)},
 	{} /* Terminating entry */
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index a72c7bf..1902acf 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -220,7 +220,7 @@ struct __packed ems_cpc_msg {
  * Table of devices that work with this driver
  * NOTE: This driver supports only CPC-USB/ARM7 (LPC2119) yet.
  */
-static struct usb_device_id ems_usb_table[] = {
+static const struct usb_device_id ems_usb_table[] = {
 	{USB_DEVICE(USB_CPCUSB_VENDOR_ID, USB_CPCUSB_ARM7_PRODUCT_ID)},
 	{} /* Terminating entry */
 };
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index eb8b0e6..ba5d816 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -181,7 +181,7 @@ struct __attribute__ ((packed)) esd_usb2_msg {
 	} msg;
 };
 
-static struct usb_device_id esd_usb2_table[] = {
+static const struct usb_device_id esd_usb2_table[] = {
 	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
 	{}
 };
diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index d9267cb..f2aae55 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -73,7 +73,7 @@
 static int qos_mtt_bits = 0;
 
 /* These are the currently known IrDA USB dongles. Add new dongles here */
-static struct usb_device_id dongles[] = {
+static const struct usb_device_id dongles[] = {
 	/* ACTiSYS Corp.,  ACT-IR2000U FIR-USB Adapter */
 	{ USB_DEVICE(0x9c4, 0x011), .driver_info = IUC_SPEED_BUG | IUC_NO_WINDOW },
 	/* Look like ACTiSYS, Report : IBM Corp., IBM UltraPort IrDA */
diff --git a/drivers/net/irda/kingsun-sir.c b/drivers/net/irda/kingsun-sir.c
index cb90d64..389936e 100644
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -86,7 +86,7 @@
 #define KING_PRODUCT_ID 0x4200
 
 /* These are the currently known USB ids */
-static struct usb_device_id dongles[] = {
+static const struct usb_device_id dongles[] = {
     /* KingSun Co,Ltd  IrDA/USB Bridge */
     { USB_DEVICE(KING_VENDOR_ID, KING_PRODUCT_ID) },
     { }
diff --git a/drivers/net/irda/ks959-sir.c b/drivers/net/irda/ks959-sir.c
index 1046014..40bffb8 100644
--- a/drivers/net/irda/ks959-sir.c
+++ b/drivers/net/irda/ks959-sir.c
@@ -134,7 +134,7 @@
 #define KS959_PRODUCT_ID 0x4959
 
 /* These are the currently known USB ids */
-static struct usb_device_id dongles[] = {
+static const struct usb_device_id dongles[] = {
 	/* KingSun Co,Ltd  IrDA/USB Bridge */
 	{USB_DEVICE(KS959_VENDOR_ID, KS959_PRODUCT_ID)},
 	{}
diff --git a/drivers/net/irda/ksdazzle-sir.c b/drivers/net/irda/ksdazzle-sir.c
index 9cc142f..06e07c6 100644
--- a/drivers/net/irda/ksdazzle-sir.c
+++ b/drivers/net/irda/ksdazzle-sir.c
@@ -98,7 +98,7 @@
 #define KSDAZZLE_PRODUCT_ID 0x4100
 
 /* These are the currently known USB ids */
-static struct usb_device_id dongles[] = {
+static const struct usb_device_id dongles[] = {
 	/* KingSun Co,Ltd  IrDA/USB Bridge */
 	{USB_DEVICE(KSDAZZLE_VENDOR_ID, KSDAZZLE_PRODUCT_ID)},
 	{}
diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
index be52bfe..6032dff 100644
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -67,7 +67,7 @@
 #define MCS_VENDOR_ID 0x9710
 #define MCS_PRODUCT_ID 0x7780
 
-static struct usb_device_id mcs_table[] = {
+static const struct usb_device_id mcs_table[] = {
 	/* MosChip Corp.,  MCS7780 FIR-USB Adapter */
 	{USB_DEVICE(MCS_VENDOR_ID, MCS_PRODUCT_ID)},
 	{},
diff --git a/drivers/net/irda/stir4200.c b/drivers/net/irda/stir4200.c
index 41c96b3..8d3ba2b 100644
--- a/drivers/net/irda/stir4200.c
+++ b/drivers/net/irda/stir4200.c
@@ -182,7 +182,7 @@ struct stir_cb {
 
 
 /* These are the currently known USB ids */
-static struct usb_device_id dongles[] = {
+static const struct usb_device_id dongles[] = {
     /* SigmaTel, Inc,  STIr4200 IrDA/USB Bridge */
     { USB_DEVICE(0x066f, 0x4200) },
     { }
diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index d7221c4..f5aa3d6 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -933,7 +933,7 @@ static void catc_disconnect(struct usb_interface *intf)
  * Module functions and tables.
  */
 
-static struct usb_device_id catc_id_table [] = {
+static const struct usb_device_id catc_id_table[] = {
 	{ USB_DEVICE(0x0423, 0xa) },	/* CATC Netmate, Belkin F5U011 */
 	{ USB_DEVICE(0x0423, 0xc) },	/* CATC Netmate II, Belkin F5U111 */
 	{ USB_DEVICE(0x08d1, 0x1) },	/* smartBridges smartNIC */
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index f967913..cdb5fd94 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -308,7 +308,7 @@ static void usbpn_setup(struct net_device *dev)
 /*
  * USB driver callbacks
  */
-static struct usb_device_id usbpn_ids[] = {
+static const struct usb_device_id usbpn_ids[] = {
 	{
 		.match_flags = USB_DEVICE_ID_MATCH_VENDOR
 			| USB_DEVICE_ID_MATCH_INT_CLASS
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 81126ff..019cb84 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -81,7 +81,7 @@
 #define IPHETH_CARRIER_CHECK_TIMEOUT round_jiffies_relative(1 * HZ)
 #define IPHETH_CARRIER_ON       0x04
 
-static struct usb_device_id ipheth_table[] = {
+static const struct usb_device_id ipheth_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(
 		USB_VENDOR_APPLE, USB_PRODUCT_IPHONE,
 		IPHETH_USBINTF_CLASS, IPHETH_USBINTF_SUBCLASS,
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index ad0298f..ae3fa3b 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -127,7 +127,7 @@ static int kaweth_resume(struct usb_interface *intf);
 /****************************************************************
  *     usb_device_id
  ****************************************************************/
-static struct usb_device_id usb_klsi_table[] = {
+static const struct usb_device_id usb_klsi_table[] = {
 	{ USB_DEVICE(0x03e8, 0x0008) }, /* AOX Endpoints USB Ethernet */
 	{ USB_DEVICE(0x04bb, 0x0901) }, /* I-O DATA USB-ET/T */
 	{ USB_DEVICE(0x0506, 0x03e8) }, /* 3Com 3C19250 */
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 041fb7d..01b07c7 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -139,7 +139,7 @@
 #undef	EEPROM_WRITE
 
 /* table of devices that work with this driver */
-static struct usb_device_id rtl8150_table[] = {
+static const struct usb_device_id rtl8150_table[] = {
 	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8150)},
 	{USB_DEVICE(VENDOR_ID_MELCO, PRODUCT_ID_LUAKTX)},
 	{USB_DEVICE(VENDOR_ID_MICRONET, PRODUCT_ID_SP128AR)},
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 298f2b0..d656a06 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -736,8 +736,7 @@ int i2400mu_post_reset(struct usb_interface *iface)
 }
 
 
-static
-struct usb_device_id i2400mu_id_table[] = {
+static const struct usb_device_id i2400mu_id_table[] = {
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6050_2) },
 	{ USB_DEVICE(0x8086, USB_DEVICE_ID_I6250) },
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 2986014..c5df78d 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -130,7 +130,7 @@ MODULE_FIRMWARE("atmel_at76c505amx-rfmd.bin");
 
 #define USB_DEVICE_DATA(__ops)	.driver_info = (kernel_ulong_t)(__ops)
 
-static struct usb_device_id dev_table[] = {
+static const struct usb_device_id dev_table[] = {
 	/*
 	 * at76c503-i3861
 	 */
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 260f1f3..9195e23 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -23,7 +23,7 @@
 MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
 MODULE_FIRMWARE(FIRMWARE_AR9271);
 
-static struct usb_device_id ath9k_hif_usb_ids[] = {
+static const struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
 	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
 	{ USB_DEVICE(0x0846, 0x9030) }, /* Netgear N150 */
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 2fb53d0..0391692 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -64,7 +64,7 @@ MODULE_ALIAS("arusb_lnx");
  * http://wireless.kernel.org/en/users/Drivers/ar9170/devices ),
  * whenever you add a new device.
  */
-static struct usb_device_id carl9170_usb_ids[] = {
+static const struct usb_device_id carl9170_usb_ids[] = {
 	/* Atheros 9170 */
 	{ USB_DEVICE(0x0cf3, 0x9170) },
 	/* Atheros TG121N */
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index b5acc39..2171e70 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -44,7 +44,7 @@ enum {
 	MODEL_8682 = 0x2
 };
 
-static struct usb_device_id if_usb_table[] = {
+static const struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
 	{ USB_DEVICE(0x1286, 0x2001), .driver_info = MODEL_8388 },
 	{ USB_DEVICE(0x05a3, 0x8388), .driver_info = MODEL_8388 },
diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index ba7d965..caa359a 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -31,7 +31,7 @@ module_param_named(fw_name, lbtf_fw_name, charp, 0644);
 
 MODULE_FIRMWARE("lbtf_usb.bin");
 
-static struct usb_device_id if_usb_table[] = {
+static const struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
 	{ USB_DEVICE(0x1286, 0x2001) },
 	{ USB_DEVICE(0x05a3, 0x8388) },
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index b9aedf1..da039d5 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -224,7 +224,7 @@ struct ezusb_packet {
 } __packed;
 
 /* Table of devices that work or may work with this driver */
-static struct usb_device_id ezusb_table[] = {
+static const struct usb_device_id ezusb_table[] = {
 	{USB_DEVICE(USB_COMPAQ_VENDOR_ID, USB_COMPAQ_WL215_ID)},
 	{USB_DEVICE(USB_COMPAQ_VENDOR_ID, USB_HP_WL215_ID)},
 	{USB_DEVICE(USB_COMPAQ_VENDOR_ID, USB_COMPAQ_W200_ID)},
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 15237c2..8d55c1a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1906,7 +1906,7 @@ static const struct rt2x00_ops rt2500usb_ops = {
 /*
  * rt2500usb module information.
  */
-static struct usb_device_id rt2500usb_device_table[] = {
+static const struct usb_device_id rt2500usb_device_table[] = {
 	/* ASUS */
 	{ USB_DEVICE(0x0b05, 0x1706) },
 	{ USB_DEVICE(0x0b05, 0x1707) },
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ba82c97..edb3cdf 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -769,7 +769,7 @@ static const struct rt2x00_ops rt2800usb_ops = {
 /*
  * rt2800usb module information.
  */
-static struct usb_device_id rt2800usb_device_table[] = {
+static const struct usb_device_id rt2800usb_device_table[] = {
 	/* Abocom */
 	{ USB_DEVICE(0x07b8, 0x2870) },
 	{ USB_DEVICE(0x07b8, 0x2770) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ad20953..68890d4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2390,7 +2390,7 @@ static const struct rt2x00_ops rt73usb_ops = {
 /*
  * rt73usb module information.
  */
-static struct usb_device_id rt73usb_device_table[] = {
+static const struct usb_device_id rt73usb_device_table[] = {
 	/* AboCom */
 	{ USB_DEVICE(0x07b8, 0xb21b) },
 	{ USB_DEVICE(0x07b8, 0xb21c) },
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index bee7c14..07464f8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -240,7 +240,7 @@ static struct rtl_hal_cfg rtl92cu_hal_cfg = {
 #define USB_VENDER_ID_REALTEK		0x0bda
 
 /* 2010-10-19 DID_USB_V3.4 */
-static struct usb_device_id rtl8192c_usb_ids[] = {
+static const struct usb_device_id rtl8192c_usb_ids[] = {
 
 	/*=== Realtek demoboard ===*/
 	/* Default ID */
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 415eec4..a250fd0 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -25,7 +25,7 @@
 #include <linux/firmware.h>
 #include "zd1201.h"
 
-static struct usb_device_id zd1201_table[] = {
+static const struct usb_device_id zd1201_table[] = {
 	{USB_DEVICE(0x0586, 0x3400)}, /* Peabird Wireless USB Adapter */
 	{USB_DEVICE(0x0ace, 0x1201)}, /* ZyDAS ZD1201 Wireless USB Adapter */
 	{USB_DEVICE(0x050d, 0x6051)}, /* Belkin F5D6051 usb  adapter */
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 0e81994..6ccf981 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -35,7 +35,7 @@
 #include "zd_mac.h"
 #include "zd_usb.h"
 
-static struct usb_device_id usb_ids[] = {
+static const struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
 	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 0842cfb..9d64535 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -736,7 +736,7 @@ static int speedtch_post_reset(struct usb_interface *intf)
 **  USB  **
 **********/
 
-static struct usb_device_id speedtch_usb_ids[] = {
+static const struct usb_device_id speedtch_usb_ids[] = {
 	{USB_DEVICE(0x06b9, 0x4061)},
 	{}
 };
diff --git a/drivers/usb/core/otg_whitelist.h b/drivers/usb/core/otg_whitelist.h
index e8cdce5..7e37426 100644
--- a/drivers/usb/core/otg_whitelist.h
+++ b/drivers/usb/core/otg_whitelist.h
@@ -16,7 +16,7 @@
  * YOU _SHOULD_ CHANGE THIS LIST TO MATCH YOUR PRODUCT AND ITS TESTING!
  */
 
-static struct usb_device_id whitelist_table [] = {
+static const struct usb_device_id whitelist_table[] = {
 
 /* hubs are optional in OTG, but very handy ... */
 { USB_DEVICE_INFO(USB_CLASS_HUB, 0, 0), },
@@ -48,7 +48,7 @@ static struct usb_device_id whitelist_table [] = {
 
 static int is_targeted(struct usb_device *dev)
 {
-	struct usb_device_id	*id = whitelist_table;
+	const struct usb_device_id *id;
 
 	/* possible in developer configs only! */
 	if (!dev->bus->otg_port)
diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index 9bfac65..c8bc83a 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -823,7 +823,7 @@ static void hwahc_disconnect(struct usb_interface *usb_iface)
 	usb_put_hcd(usb_hcd);
 }
 
-static struct usb_device_id hwahc_id_table[] = {
+static const struct usb_device_id hwahc_id_table[] = {
 	/* FIXME: use class labels for this */
 	{ USB_INTERFACE_INFO(0xe0, 0x02, 0x01), },
 	{},
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index ac5bfd6..e033ea0 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -40,7 +40,7 @@
 #define YUREX_WRITE_TIMEOUT	(HZ*2)
 
 /* table of devices that work with this driver */
-static struct usb_device_id yurex_table[] = {
+static const struct usb_device_id yurex_table[] = {
 	{ USB_DEVICE(YUREX_VENDOR_ID, YUREX_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e8dbde5..f4159a6 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -150,7 +150,7 @@ static struct ftdi_sio_quirk ftdi_stmclite_quirk = {
  * Device ID not listed? Test via module params product/vendor or
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
-static struct usb_device_id id_table_combined [] = {
+static struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index 4735931..c5309a9 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -78,7 +78,7 @@ static int  ipaq_open(struct tty_struct *tty,
 static int  ipaq_calc_num_ports(struct usb_serial *serial);
 static int  ipaq_startup(struct usb_serial *serial);
 
-static struct usb_device_id ipaq_id_table [] = {
+static struct usb_device_id ipaq_id_table[] = {
 	/* The first entry is a placeholder for the insmod-specified device */
 	{ USB_DEVICE(0x049F, 0x0003) },
 	{ USB_DEVICE(0x0104, 0x00BE) }, /* Socket USB Sync */
diff --git a/drivers/usb/serial/qcaux.c b/drivers/usb/serial/qcaux.c
index 30b73e6..2c1df45 100644
--- a/drivers/usb/serial/qcaux.c
+++ b/drivers/usb/serial/qcaux.c
@@ -55,7 +55,7 @@
 #define SAMSUNG_VENDOR_ID			0x04e8
 #define SAMSUNG_PRODUCT_U520			0x6640 /* SCH-U520 */
 
-static struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, UTSTARCOM_PRODUCT_PC5740, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, UTSTARCOM_PRODUCT_PC5750, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(UTSTARCOM_VENDOR_ID, UTSTARCOM_PRODUCT_UM150, 0xff, 0x00, 0x00) },
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 1c11959..3a0ded6 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -56,7 +56,7 @@ static int debug;
 static __u16 vendor;
 static __u16 product;
 
-static struct usb_device_id id_table [] = {
+static struct usb_device_id id_table[] = {
 	{ USB_DEVICE(HANDSPRING_VENDOR_ID, HANDSPRING_VISOR_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_3_probe },
 	{ USB_DEVICE(HANDSPRING_VENDOR_ID, HANDSPRING_TREO_ID),
@@ -119,19 +119,19 @@ static struct usb_device_id id_table [] = {
 	{ }					/* Terminating entry */
 };
 
-static struct usb_device_id clie_id_5_table [] = {
+static struct usb_device_id clie_id_5_table[] = {
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_CLIE_UX50_ID),
 		.driver_info = (kernel_ulong_t)&palm_os_4_probe },
 	{ },					/* optional parameter entry */
 	{ }					/* Terminating entry */
 };
 
-static struct usb_device_id clie_id_3_5_table [] = {
+static const struct usb_device_id clie_id_3_5_table[] = {
 	{ USB_DEVICE(SONY_VENDOR_ID, SONY_CLIE_3_5_ID) },
 	{ }					/* Terminating entry */
 };
 
-static struct usb_device_id id_table_combined [] = {
+static struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(HANDSPRING_VENDOR_ID, HANDSPRING_VISOR_ID) },
 	{ USB_DEVICE(HANDSPRING_VENDOR_ID, HANDSPRING_TREO_ID) },
 	{ USB_DEVICE(HANDSPRING_VENDOR_ID, HANDSPRING_TREO600_ID) },
@@ -653,7 +653,7 @@ static int __init visor_init(void)
 	int i, retval;
 	/* Only if parameters were passed to us */
 	if (vendor > 0 && product > 0) {
-		struct usb_device_id usb_dev_temp[] = {
+		const struct usb_device_id usb_dev_temp[] = {
 			{
 				USB_DEVICE(vendor, product),
 				.driver_info =
diff --git a/drivers/usb/serial/vivopay-serial.c b/drivers/usb/serial/vivopay-serial.c
index f719d00..c466a5d 100644
--- a/drivers/usb/serial/vivopay-serial.c
+++ b/drivers/usb/serial/vivopay-serial.c
@@ -17,7 +17,7 @@
 #define VIVOPAY_VENDOR_ID 0x1d5f
 
 
-static struct usb_device_id id_table [] = {
+static const struct usb_device_id id_table[] = {
 	/* ViVOpay 8800 */
 	{ USB_DEVICE(VIVOPAY_VENDOR_ID, 0x1004) },
 	{ },
diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 42d0eae..3bb4f4c 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -139,7 +139,7 @@ static int init_alauda(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id alauda_usb_ids[] = {
+static const struct usb_device_id alauda_usb_ids[] = {
 #	include "unusual_alauda.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index c844718..6753983 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -43,7 +43,7 @@ MODULE_LICENSE("GPL");
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id cypress_usb_ids[] = {
+static const struct usb_device_id cypress_usb_ids[] = {
 #	include "unusual_cypress.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index ded836b..841e8dc 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -88,7 +88,7 @@ static int datafab_determine_lun(struct us_data *us,
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id datafab_usb_ids[] = {
+static const struct usb_device_id datafab_usb_ids[] = {
 #	include "unusual_datafab.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 31645af..b4e1b24 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -42,7 +42,7 @@ MODULE_LICENSE("GPL");
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
 	.driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id ene_ub6250_usb_ids[] = {
+static const struct usb_device_id ene_ub6250_usb_ids[] = {
 #	include "unusual_ene_ub6250.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index 6542ca4..83716ab 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -119,7 +119,7 @@ static int init_freecom(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id freecom_usb_ids[] = {
+static const struct usb_device_id freecom_usb_ids[] = {
 #	include "unusual_freecom.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index ffc4193..2baf503 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -76,7 +76,7 @@ static int isd200_Initialization(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id isd200_usb_ids[] = {
+static const struct usb_device_id isd200_usb_ids[] = {
 #	include "unusual_isd200.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 6168596..0aa7715 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -71,7 +71,7 @@ MODULE_LICENSE("GPL");
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id jumpshot_usb_ids[] = {
+static const struct usb_device_id jumpshot_usb_ids[] = {
 #	include "unusual_jumpshot.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index ba1b789..51163f9 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -59,7 +59,7 @@ static int rio_karma_init(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id karma_usb_ids[] = {
+static const struct usb_device_id karma_usb_ids[] = {
 #	include "unusual_karma.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index 1943be5..f2ad4f7 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -69,7 +69,7 @@ struct usb_onetouch {
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id onetouch_usb_ids[] = {
+static const struct usb_device_id onetouch_usb_ids[] = {
 #	include "unusual_onetouch.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index bcb9a70..3c76f26 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -71,7 +71,7 @@ static int usb_stor_sddr09_init(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id sddr09_usb_ids[] = {
+static const struct usb_device_id sddr09_usb_ids[] = {
 #	include "unusual_sddr09.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index 44dfed7..abcd052 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -48,7 +48,7 @@ MODULE_LICENSE("GPL");
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id sddr55_usb_ids[] = {
+static const struct usb_device_id sddr55_usb_ids[] = {
 #	include "unusual_sddr55.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 0b00091..01a670f 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -170,7 +170,7 @@ static int init_usbat_flash(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id usbat_usb_ids[] = {
+static const struct usb_device_id usbat_usb_ids[] = {
 #	include "unusual_usbat.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 23f0dd9..87b4e1f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -572,7 +572,7 @@ static struct scsi_host_template uas_host_template = {
 	.ordered_tag = 1,
 };
 
-static struct usb_device_id uas_usb_ids[] = {
+static const struct usb_device_id uas_usb_ids[] = {
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },
 	/* 0xaa is a prototype device I happen to have access to */
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index b969279..57a701a 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -46,7 +46,7 @@
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans), \
   .driver_info = ((useType)<<24) }
 
-struct usb_device_id usb_storage_usb_ids[] = {
+const struct usb_device_id usb_storage_usb_ids[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 52b0f3e..b5f74db 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -54,7 +54,7 @@ static const u32 udlfb_info_flags = FBINFO_DEFAULT | FBINFO_READS_FAST |
  * globally on VID. TODO: Probe() needs to detect when we might be running
  * "future" chips, and bail on those, so a compatible driver can match.
  */
-static struct usb_device_id id_table[] = {
+static const struct usb_device_id id_table[] = {
 	{.idVendor = 0x17e9, .match_flags = USB_DEVICE_ID_MATCH_VENDOR,},
 	{},
 };
diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 02bf7bf..a205638 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -171,7 +171,7 @@ struct ds_status
 
 };
 
-static struct usb_device_id ds_id_table [] = {
+static const struct usb_device_id ds_id_table[] = {
 	{ USB_DEVICE(0x04fa, 0x2490) },
 	{ },
 };
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 748a74b..006095c 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -90,7 +90,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 #define USB_PCWD_PRODUCT_ID	0x1140
 
 /* table of devices that work with this driver */
-static struct usb_device_id usb_pcwd_table[] = {
+static const struct usb_device_id usb_pcwd_table[] = {
 	{ USB_DEVICE(USB_PCWD_VENDOR_ID, USB_PCWD_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 71693d4..882ff1e 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -83,7 +83,7 @@ enum { US_DO_ALL_FLAGS };
 /*
  */
 extern int usb_usual_ignore_device(struct usb_interface *intf);
-extern struct usb_device_id usb_storage_usb_ids[];
+extern const struct usb_device_id usb_storage_usb_ids[];
 
 #ifdef CONFIG_USB_LIBUSUAL
 
diff --git a/sound/usb/6fire/chip.c b/sound/usb/6fire/chip.c
index c7dca7b..79a2980 100644
--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -200,7 +200,7 @@ static void usb6fire_chip_disconnect(struct usb_interface *intf)
 	}
 }
 
-static struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] = {
 	{
 		.match_flags = USB_DEVICE_ID_MATCH_DEVICE,
 		.idVendor = 0x0ccd,
diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 45bc4a2..552bfe1 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -80,7 +80,7 @@ enum {
 	DEPTH_32	= 3
 };
 
-static struct usb_device_id snd_usb_id_table[] = {
+static const struct usb_device_id snd_usb_id_table[] = {
 	{
 		.match_flags =	USB_DEVICE_ID_MATCH_DEVICE,
 		.idVendor =	USB_VID_NATIVEINSTRUMENTS,
diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index fb5d68f..fd206c0 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1354,7 +1354,7 @@ static void ua101_disconnect(struct usb_interface *interface)
 	mutex_unlock(&devices_mutex);
 }
 
-static struct usb_device_id ua101_ids[] = {
+static const struct usb_device_id ua101_ids[] = {
 	{ USB_DEVICE(0x0582, 0x0044) }, /* UA-1000 high speed */
 	{ USB_DEVICE(0x0582, 0x007d) }, /* UA-101 high speed */
 	{ USB_DEVICE(0x0582, 0x008d) }, /* UA-101 full speed */
diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 084e6fc..f94aa91 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -735,7 +735,7 @@ unlock:
 	return err;
 }
 
-static struct usb_device_id snd_us122l_usb_id_table[] = {
+static const struct usb_device_id snd_us122l_usb_id_table[] = {
 	{
 		.match_flags =	USB_DEVICE_ID_MATCH_DEVICE,
 		.idVendor =	0x0644,
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index cbd37f2..ae6dc7d 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -315,7 +315,7 @@ static void usX2Y_unlinkSeq(struct snd_usX2Y_AsyncSeq *S)
 }
 
 
-static struct usb_device_id snd_usX2Y_usb_id_table[] = {
+static const struct usb_device_id snd_usX2Y_usb_id_table[] = {
 	{
 		.match_flags =	USB_DEVICE_ID_MATCH_DEVICE,
 		.idVendor =	0x1604,
-- 
1.7.5.2.365.g5cfe4

