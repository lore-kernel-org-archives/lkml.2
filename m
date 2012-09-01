Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2IAQv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 12:51:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41667 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2IAQvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 12:51:53 -0400
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 00:51:51 +0800
Message-ID: <CA+HMz3h748VTK3ovWC_cuT1MLrG4Fx3nmTcj=o56VjnF1iejow@mail.gmail.com>
Subject: [PATCH]Documentation: Chinese translation of Documentation/video4linux/v4l2-framework.txt
From: Ninja Tekkaman <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel@vger.linux-kernel.cn
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q81Gqsuh001476

This is a Chinese translated version of
Documentation/video4linux/v4l2-framework.txt

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
---
 Documentation/zh_CN/video4linux/v4l2-framework.txt |  983 ++++++++++++++++++++
 1 file changed, 983 insertions(+)
 create mode 100644 Documentation/zh_CN/video4linux/v4l2-framework.txt

diff --git a/Documentation/zh_CN/video4linux/v4l2-framework.txt
b/Documentation/zh_CN/video4linux/v4l2-framework.txt
new file mode 100644
index 0000000..3e74f13
--- /dev/null
+++ b/Documentation/zh_CN/video4linux/v4l2-framework.txt
@@ -0,0 +1,983 @@
+Chinese translated version of Documentation/video4linux/v4l2-framework.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Maintainer: Mauro Carvalho Chehab <mchehab@infradead.org>
+Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+---------------------------------------------------------------------
+Documentation/video4linux/v4l2-framework.txt µÄÖĞÎÄ·­Òë
+
+Èç¹ûÏëÆÀÂÛ»ò¸üĞÂ±¾ÎÄµÄÄÚÈİ£¬ÇëÖ±½ÓÁªÏµÔ­ÎÄµµµÄÎ¬»¤Õß¡£Èç¹ûÄãÊ¹ÓÃÓ¢ÎÄ
+½»Á÷ÓĞÀ§ÄÑµÄ»°£¬Ò²¿ÉÒÔÏòÖĞÎÄ°æÎ¬»¤ÕßÇóÖú¡£Èç¹û±¾·­Òë¸üĞÂ²»¼°Ê±»òÕß·­
+Òë´æÔÚÎÊÌâ£¬ÇëÁªÏµÖĞÎÄ°æÎ¬»¤Õß¡£
+Ó¢ÎÄ°æÎ¬»¤Õß£º Mauro Carvalho Chehab <mchehab@infradead.org>
+ÖĞÎÄ°æÎ¬»¤Õß£º ¸µì¿ Fu Wei <tekkamanninja@gmail.com>
+ÖĞÎÄ°æ·­ÒëÕß£º ¸µì¿ Fu Wei <tekkamanninja@gmail.com>
+ÖĞÎÄ°æĞ£ÒëÕß£º ¸µì¿ Fu Wei <tekkamanninja@gmail.com>
+
+
+ÒÔÏÂÎªÕıÎÄ
+---------------------------------------------------------------------
+V4L2 Çı¶¯¿ò¼Ü¸ÅÀÀ
+==============
+
+±¾ÎÄµµÃèÊö V4L2 ¿ò¼ÜËùÌá¹©µÄ¸÷ÖÖ½á¹¹ºÍËüÃÇÖ®¼äµÄ¹ØÏµ¡£
+
+
+½éÉÜ
+----
+
+´ó²¿·ÖÏÖ´ú V4L2 Éè±¸ÓÉ¶à¸ö IC ×é³É£¬ÔÚ /dev ÏÂµ¼³ö¶à¸öÉè±¸½Úµã£¬
+²¢Í¬Ê±´´½¨·Ç V4L2 Éè±¸£¨Èç DVB¡¢ALSA¡¢FB¡¢I2C ºÍºìÍâÊäÈëÉè±¸£©¡£
+ÓÉÓÚÕâÖÖÓ²¼şµÄ¸´ÔÓĞÔ£¬V4L2 Çı¶¯Ò²±äµÃ·Ç³£¸´ÔÓ¡£
+
+ÓÈÆäÊÇ V4L2 ±ØĞëÖ§³Ö IC ÊµÏÖÒôÊÓÆµµÄ¶àÂ·¸´ÓÃºÍ±à½âÂë£¬Õâ¾Í¸üÔö¼ÓÁËÆä
+¸´ÔÓĞÔ¡£Í¨³£ÕâĞ© IC Í¨¹ıÒ»¸ö»ò¶à¸ö I2C ×ÜÏßÁ¬½Óµ½Ö÷ÇÅÇı¶¯Æ÷£¬µ«Ò²¿É
+Ê¹ÓÃÆäËû×ÜÏß¡£ÕâĞ©Éè±¸³ÆÎª¡°×ÓÉè±¸¡±¡£
+
+³¤ÆÚÒÔÀ´£¬Õâ¸ö¿ò¼Ü½öÏŞÓÚÍ¨¹ı video_device ½á¹¹Ìå´´½¨ V4L Éè±¸½Úµã£¬
+²¢Ê¹ÓÃ video_buf ´¦ÀíÊÓÆµ»º³å£¨×¢£º±¾ÎÄ²»ÌÖÂÛ video_buf ¿ò¼Ü£©¡£
+
+ÕâÒâÎ¶×ÅËùÓĞÇı¶¯±ØĞë×Ô¼ºÉèÖÃÉè±¸ÊµÀı²¢Á¬½Óµ½×ÓÉè±¸¡£ÆäÖĞÒ»²¿·ÖÒªÕıÈ·µØ
+Íê³ÉÊÇ±È½Ï¸´ÔÓµÄ£¬Ê¹µÃĞí¶àÇı¶¯¶¼Ã»ÓĞÕıÈ·µØÊµÏÖ¡£
+
+ÓÉÓÚ¿ò¼ÜµÄÈ±Ê§£¬ÓĞºÜ¶àÍ¨ÓÃ´úÂë¶¼²»¿ÉÖØ¸´ÀûÓÃ¡£
+
+Òò´Ë£¬Õâ¸ö¿ò¼Ü¹¹½¨ËùÓĞÇı¶¯¶¼ĞèÒªµÄ»ù±¾½á¹¹¿é£¬¶øÍ³Ò»µÄ¿ò¼Ü½«Ê¹Í¨ÓÃ´úÂë
+´´½¨³ÉÊµÓÃº¯Êı²¢ÔÚËùÓĞÇı¶¯ÖĞ¹²Ïí±äµÃ¸ü¼ÓÈİÒ×¡£
+
+
+Çı¶¯½á¹¹
+-------
+
+ËùÓĞ V4L2 Çı¶¯¶¼ÓĞÈçÏÂ½á¹¹£º
+
+1) Ã¿¸öÉè±¸ÊµÀıµÄ½á¹¹Ìå--°üº¬ÆäÉè±¸×´Ì¬¡£
+
+2) ³õÊ¼»¯ºÍ¿ØÖÆ×ÓÉè±¸µÄ·½·¨£¨Èç¹ûÓĞ£©¡£
+
+3) ´´½¨ V4L2 Éè±¸½Úµã (/dev/videoX¡¢/dev/vbiX ºÍ /dev/radioX)
+   ²¢¸ú×ÙÉè±¸½ÚµãµÄÌØ¶¨Êı¾İ¡£
+
+4) ÌØ¶¨ÎÄ¼ş¾ä±ú½á¹¹Ìå--°üº¬Ã¿¸öÎÄ¼ş¾ä±úµÄÊı¾İ¡£
+
+5) ÊÓÆµ»º³å´¦Àí¡£
+
+ÒÔÏÂÊÇËüÃÇµÄ³õÂÔ¹ØÏµÍ¼£º
+
+    device instances£¨Éè±¸ÊµÀı£©
+      |
+      +-sub-device instances£¨×ÓÉè±¸ÊµÀı£©
+      |
+      \-V4L2 device nodes£¨V4L2 Éè±¸½Úµã£©
+	  |
+	  \-filehandle instances£¨ÎÄ¼ş¾ä±úÊµÀı£©
+
+
+¿ò¼Ü½á¹¹
+-------
+
+¸Ã¿ò¼Ü·Ç³£ÀàËÆÇı¶¯½á¹¹£ºËüÓĞÒ»¸ö v4l2_device ½á¹¹ÓÃÓÚ±£´æÉè±¸
+ÊµÀıµÄÊı¾İ£»Ò»¸ö v4l2_subdev ½á¹¹Ìå´ú±í×ÓÉè±¸ÊµÀı£»video_device
+½á¹¹Ìå±£´æ V4L2 Éè±¸½ÚµãµÄÊı¾İ£»½«À´ v4l2_fh ½á¹¹Ìå½«¸ú×ÙÎÄ¼ş¾ä±ú
+ÊµÀı£¨ÔİÎ´ÉĞÎ´ÊµÏÖ£©¡£
+
+V4L2 ¿ò¼ÜÒ²¿ÉÓëÃ½Ìå¿ò¼ÜÕûºÏ£¨¿ÉÑ¡µÄ£©¡£Èç¹ûÇı¶¯ÉèÖÃÁË v4l2_device
+½á¹¹ÌåµÄ mdev Óò£¬×ÓÉè±¸ºÍÊÓÆµ½ÚµãµÄÈë¿Ú½«×Ô¶¯³öÏÖÔÚÃ½Ìå¿ò¼ÜÖĞ¡£
+
+
+v4l2_device ½á¹¹Ìå
+----------------
+
+Ã¿¸öÉè±¸ÊµÀı¶¼Í¨¹ı v4l2_device (v4l2-device.h)½á¹¹ÌåÀ´±íÊ¾¡£
+¼òµ¥Éè±¸¿ÉÒÔ½ö·ÖÅäÕâ¸ö½á¹¹Ìå£¬µ«ÔÚ´ó¶àÊıÇé¿öÏÂ£¬¶¼»á½«Õâ¸ö½á¹¹Ìå
+Ç¶Èëµ½Ò»¸ö¸ü´óµÄ½á¹¹ÌåÖĞ¡£
+
+Äã±ØĞë×¢²áÕâ¸öÉè±¸ÊµÀı£º
+
+	v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev);
+
+×¢²á²Ù×÷½«»á³õÊ¼»¯ v4l2_device ½á¹¹Ìå¡£Èç¹û dev->driver_data Óò
+Îª NULL£¬¾Í½«ÆäÖ¸Ïò v4l2_dev¡£
+
+ĞèÒªÓëÃ½Ìå¿ò¼ÜÕûºÏµÄÇı¶¯±ØĞëÊÖ¶¯ÉèÖÃ dev->driver_data£¬Ö¸Ïò°üº¬
+v4l2_device ½á¹¹ÌåÊµÀıµÄÇı¶¯ÌØ¶¨Éè±¸½á¹¹Ìå¡£Õâ¿ÉÒÔÔÚ×¢²á V4L2 Éè±¸
+ÊµÀıÇ°Í¨¹ı dev_set_drvdata() º¯ÊıÍê³É¡£Í¬Ê±±ØĞëÉèÖÃ v4l2_device
+½á¹¹ÌåµÄ mdev Óò£¬Ö¸ÏòÊÊµ±µÄ³õÊ¼»¯²¢×¢²á¹ıµÄ media_device ÊµÀı¡£
+
+Èç¹û v4l2_dev->name Îª¿Õ£¬ÔòËü½«±»ÉèÖÃÎª´Ó dev ÖĞÑÜÉú³öµÄÖµ£¨ÎªÁË
+¸ü¼Ó¾«È·£¬ĞÎÊ½ÎªÇı¶¯Ãûºó¸ú bus_id£©¡£Èç¹ûÄãÔÚµ÷ÓÃ v4l2_device_register
+Ç°ÒÑ¾­ÉèÖÃºÃÁË£¬Ôò²»»á±»ĞŞ¸Ä¡£Èç¹û dev Îª NULL£¬ÔòÄã*±ØĞë*ÔÚµ÷ÓÃ
+v4l2_device_register Ç°ÉèÖÃ v4l2_dev->name¡£
+
+Äã¿ÉÒÔ»ùÓÚÇı¶¯ÃûºÍÇı¶¯µÄÈ«¾Ö atomic_t ÀàĞÍµÄÊµÀı±àºÅ£¬Í¨¹ı
+v4l2_device_set_name() ÉèÖÃ name¡£ÕâÑù»áÉú³ÉÀàËÆ ivtv0¡¢ivtv1 µÈ
+Ãû×Ö¡£ÈôÇı¶¯ÃûÒÔÊı×Ö½áÎ²£¬Ôò»áÔÚ±àºÅºÍÇı¶¯Ãû¼ä²åÈëÒ»¸öÆÆÕÛºÅ£¬Èç£º
+cx18-0¡¢cx18-1 µÈ¡£´Ëº¯Êı·µ»ØÊµÀı±àºÅ¡£
+
+µÚÒ»¸ö ¡°dev¡± ²ÎÊıÍ¨³£ÊÇÒ»¸öÖ¸Ïò pci_dev¡¢usb_interface »ò
+platform_device µÄÖ¸Õë¡£ºÜÉÙÊ¹ÆäÎª NULL£¬³ı·ÇÊÇÒ»¸öISAÉè±¸»òÕß
+µ±Ò»¸öÉè±¸´´½¨ÁË¶à¸ö PCI Éè±¸£¬Ê¹µÃ v4l2_dev ÎŞ·¨ÓëÒ»¸öÌØ¶¨µÄ¸¸Éè±¸
+¹ØÁª¡£
+
+ÄãÒ²¿ÉÒÔÌá¹©Ò»¸ö notify() »Øµ÷£¬Ê¹×ÓÉè±¸¿ÉÒÔµ÷ÓÃËüÊµÏÖÊÂ¼şÍ¨Öª¡£
+µ«Õâ¸öÉèÖÃÓë×ÓÉè±¸Ïà¹Ø¡£×ÓÉè±¸Ö§³ÖµÄÈÎºÎÍ¨Öª±ØĞëÔÚ
+include/media/<subdevice>.h ÖĞ¶¨ÒåÒ»¸öÏûÏ¢Í·¡£
+
+×¢Ïú v4l2_device Ê¹ÓÃÈçÏÂº¯Êı£º
+
+	v4l2_device_unregister(struct v4l2_device *v4l2_dev);
+
+Èç¹û dev->driver_data ÓòÖ¸Ïò v4l2_dev£¬½«»á±»ÖØÖÃÎª NULL¡£×¢ÏúÍ¬Ê±
+»á×Ô¶¯´ÓÉè±¸ÖĞ×¢ÏúËùÓĞ×ÓÉè±¸¡£
+
+Èç¹ûÄãÓĞÒ»¸öÈÈ²å°ÎÉè±¸£¨ÈçUSBÉè±¸£©£¬Ôòµ±¶Ï¿ª·¢ÉúÊ±£¬¸¸Éè±¸½«ÎŞĞ§¡£
+ÓÉÓÚ v4l2_device ÓĞÒ»¸öÖ¸Ïò¸¸Éè±¸µÄÖ¸Õë±ØĞë±»Çå³ı£¬Í¬Ê±±êÖ¾¸¸Éè±¸
+ÒÑÏûÊ§£¬ËùÒÔ±ØĞëµ÷ÓÃÒÔÏÂº¯Êı£º
+
+	v4l2_device_disconnect(struct v4l2_device *v4l2_dev);
+
+Õâ¸öº¯Êı²¢*²»*×¢Ïú×ÓÉè±¸£¬Òò´ËÄãÒÀÈ»Òªµ÷ÓÃ v4l2_device_unregister()
+º¯Êı¡£Èç¹ûÄãµÄÇı¶¯Æ÷²¢·ÇÈÈ²å°ÎµÄ£¬¾ÍÃ»ÓĞ±ØÒªµ÷ÓÃ v4l2_device_disconnect()¡£
+
+ÓĞÊ±ÄãĞèÒª±éÀúËùÓĞ±»ÌØ¶¨Çı¶¯×¢²áµÄÉè±¸¡£ÕâÍ¨³£·¢ÉúÔÚ¶à¸öÉè±¸Çı¶¯Ê¹ÓÃ
+Í¬Ò»¸öÓ²¼şµÄÇé¿öÏÂ¡£Èç£ºivtvfb Çı¶¯ÊÇÒ»¸öÊ¹ÓÃ ivtv Ó²¼şµÄÖ¡»º³åÇı¶¯£¬
+Í¬Ê± alsa Çı¶¯Ò²Ê¹ÓÃ´ËÓ²¼ş¡£
+
+Äã¿ÉÒÔÊ¹ÓÃÈçÏÂÀı³Ì±éÀúËùÓĞ×¢²áµÄÉè±¸£º
+
+static int callback(struct device *dev, void *p)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+
+	/* ²âÊÔÕâ¸öÉè±¸ÊÇ·ñÒÑ¾­³õÊ¼»¯ */
+	if (v4l2_dev == NULL)
+		return 0;
+	...
+	return 0;
+}
+
+int iterate(void *p)
+{
+	struct device_driver *drv;
+	int err;
+
+	/* ÔÚPCI ×ÜÏßÉÏ²éÕÒivtvÇı¶¯¡£
+	   pci_bus_typeÊÇÈ«¾ÖµÄ. ¶ÔÓÚUSB×ÜÏßÊ¹ÓÃusb_bus_type¡£ */
+	drv = driver_find("ivtv", &pci_bus_type);
+	/* ±éÀúËùÓĞµÄivtvÉè±¸ÊµÀı */
+	err = driver_for_each_device(drv, NULL, p, callback);
+	put_driver(drv);
+	return err;
+}
+
+ÓĞÊ±ÄãĞèÒªÒ»¸öÉè±¸ÊµÀıµÄÔËĞĞ¼ÆÊı¡£Õâ¸öÍ¨³£ÓÃÓÚÓ³ÉäÒ»¸öÉè±¸ÊµÀıµ½Ò»¸ö
+Ä£¿éÑ¡ÔñÊı×éµÄË÷Òı¡£
+
+ÍÆ¼ö·½·¨ÈçÏÂ£º
+
+static atomic_t drv_instance = ATOMIC_INIT(0);
+
+static int __devinit drv_probe(struct pci_dev *pdev,
+				const struct pci_device_id *pci_id)
+{
+	...
+	state->instance = atomic_inc_return(&drv_instance) - 1;
+}
+
+Èç¹ûÄãÓĞ¶à¸öÉè±¸½Úµã£¬¶ÔÓÚÈÈ²å°ÎÉè±¸£¬ÖªµÀºÎÊ±×¢Ïú v4l2_device ½á¹¹Ìå
+¾Í±È½ÏÀ§ÄÑ¡£Îª´Ë v4l2_device ÓĞÒıÓÃ¼ÆÊıÖ§³Ö¡£µ±µ÷ÓÃ video_register_device
+Ê±Ôö¼ÓÒıÓÃ¼ÆÊı£¬¶øÉè±¸½ÚµãÊÍ·ÅÊ±¼õĞ¡ÒıÓÃ¼ÆÊı¡£µ±ÒıÓÃ¼ÆÊıÎªÁã£¬Ôò
+v4l2_device µÄrelease() »Øµ÷½«±»Ö´ĞĞ¡£Äã¾Í¿ÉÒÔÔÚ´ËÊ±×ö×îºóµÄÇåÀí¹¤×÷¡£
+
+Èç¹û´´½¨ÁËÆäËûÉè±¸½Úµã£¨±ÈÈç ALSA£©£¬ÔòÄã¿ÉÒÔÍ¨¹ıÒÔÏÂº¯ÊıÊÖ¶¯Ôö¼õ
+ÒıÓÃ¼ÆÊı£º
+
+void v4l2_device_get(struct v4l2_device *v4l2_dev);
+
+»ò:
+
+int v4l2_device_put(struct v4l2_device *v4l2_dev);
+
+ÓÉÓÚÒıÓÃ¼¼Êõ³õÊ¼»¯Îª 1 £¬ÄãÒ²ĞèÒªÔÚ disconnect() »Øµ÷£¨¶ÔÓÚ USB Éè±¸£©ÖĞ
+µ÷ÓÃ v4l2_device_put£¬»òÕß remove() »Øµ÷£¨ÀıÈç¶ÔÓÚ PCI Éè±¸£©£¬·ñÔò
+ÒıÓÃ¼ÆÊı½«ÓÀÔ¶²»»áÎª 0 ¡£
+
+v4l2_subdev½á¹¹Ìå
+------------------
+
+Ğí¶àÇı¶¯ĞèÒªÓë×ÓÉè±¸Í¨ĞÅ¡£ÕâĞ©Éè±¸¿ÉÒÔÍê³É¸÷ÖÖÈÎÎñ£¬µ«Í¨³£ËûÃÇ¸ºÔğ
+ÒôÊÓÆµ¸´ÓÃºÍ±à½âÂë¡£ÈçÍøÂçÉãÏñÍ·µÄ×ÓÉè±¸Í¨³£ÊÇ´«¸ĞÆ÷ºÍÉãÏñÍ·¿ØÖÆÆ÷¡£
+
+ÕâĞ©Ò»°ãÎª I2C ½Ó¿ÚÉè±¸£¬µ«²¢²»Ò»¶¨¶¼ÊÇ¡£ÎªÁË¸øÇı¶¯Ìá¹©µ÷ÓÃ×ÓÉè±¸µÄ
+Í³Ò»½Ó¿Ú£¬v4l2_subdev ½á¹¹Ìå£¨v4l2-subdev.h£©²úÉúÁË¡£
+
+Ã¿¸ö×ÓÉè±¸Çı¶¯¶¼±ØĞëÓĞÒ»¸ö v4l2_subdev ½á¹¹Ìå¡£Õâ¸ö½á¹¹Ìå¿ÉÒÔµ¥¶À
+´ú±íÒ»¸ö¼òµ¥µÄ×ÓÉè±¸£¬Ò²¿ÉÒÔÇ¶Èëµ½Ò»¸ö¸ü´óµÄ½á¹¹ÌåÖĞ£¬Óë¸ü¶àÉè±¸×´Ì¬
+ĞÅÏ¢±£´æÔÚÒ»Æğ¡£Í¨³£ÓĞÒ»¸öÏÂ¼¶Éè±¸½á¹¹Ìå£¨±ÈÈç£ºi2c_client£©°üº¬ÁË
+ÄÚºË´´½¨µÄÉè±¸Êı¾İ¡£½¨ÒéÊ¹ÓÃ v4l2_set_subdevdata() ½«Õâ¸ö½á¹¹ÌåµÄ
+Ö¸Õë±£´æÔÚ v4l2_subdev µÄË½ÓĞÊı¾İÓò(dev_priv)ÖĞ¡£ÕâÊ¹µÃÍ¨¹ı v4l2_subdev
+ÕÒµ½Êµ¼ÊµÄµÍ²ã×ÜÏßÌØ¶¨Éè±¸Êı¾İ±äµÃÈİÒ×¡£
+
+ÄãÍ¬Ê±ĞèÒªÒ»¸ö´ÓµÍ²ã½á¹¹Ìå»ñÈ¡ v4l2_subdev Ö¸ÕëµÄ·½·¨¡£¶ÔÓÚ³£ÓÃµÄ
+i2c_client ½á¹¹Ìå£¬i2c_set_clientdata() º¯Êı¿ÉÓÃÓÚ±£´æÒ»¸ö v4l2_subdev
+Ö¸Õë£»¶ÔÓÚÆäËû×ÜÏßÄã¿ÉÄÜĞèÒªÊ¹ÓÃÆäËûÏà¹Øº¯Êı¡£
+
+ÇÅÇı¶¯ÖĞÒ²Ó¦±£´æÃ¿¸ö×ÓÉè±¸µÄË½ÓĞÊı¾İ£¬±ÈÈçÒ»¸öÖ¸ÏòÌØ¶¨ÇÅµÄ¸÷Éè±¸Ë½ÓĞ
+Êı¾İµÄÖ¸Õë¡£Îª´Ë v4l2_subdev ½á¹¹ÌåÌá¹©Ö÷»úË½ÓĞÊı¾İÓò(host_priv)£¬
+²¢¿ÉÍ¨¹ı v4l2_get_subdev_hostdata() ºÍ v4l2_set_subdev_hostdata()
+·ÃÎÊ¡£
+
+´Ó×ÜÏßÇÅÇı¶¯µÄÊÓ½Ç£¬Çı¶¯¼ÓÔØ×ÓÉè±¸Ä£¿é²¢ÒÔÄ³ÖÖ·½Ê½»ñµÃ v4l2_subdev
+½á¹¹ÌåÖ¸Õë¡£¶ÔÓÚ i2c ×ÜÏßÉè±¸Ïà¶Ô¼òµ¥£ºµ÷ÓÃ i2c_get_clientdata()¡£
+¶ÔÓÚÆäËû×ÜÏßÒ²ĞèÒª×öÀàËÆµÄ²Ù×÷¡£Õë¶Ô I2C ×ÜÏßÉÏµÄ×ÓÉè±¸¸¨Öúº¯Êı°ïÄã
+Íê³ÉÁË´ó²¿·Ö¸´ÔÓµÄ¹¤×÷¡£
+
+Ã¿¸ö v4l2_subdev ¶¼°üº¬×ÓÉè±¸Çı¶¯ĞèÒªÊµÏÖµÄº¯ÊıÖ¸Õë£¨Èç¹û¶Ô´ËÉè±¸
+²»ÊÊÓÃ£¬¿ÉÎªNULL£©¡£ÓÉÓÚ×ÓÉè±¸¿ÉÍê³ÉĞí¶à²»Í¬µÄ¹¤×÷£¬¶øÔÚÒ»¸öÅÓ´óµÄ
+º¯ÊıÖ¸Õë½á¹¹ÌåÖĞÍ¨³£½öÓĞÉÙÊıÓĞÓÃµÄº¯ÊıÊµÏÖÆä¹¦ÄÜ¿Ï¶¨²»ºÏÊÊ¡£ËùÒÔ£¬
+º¯ÊıÖ¸Õë¸ù¾İÆäÊµÏÖµÄ¹¦ÄÜ±»·ÖÀà£¬Ã¿Ò»Àà¶¼ÓĞ×Ô¼ºµÄº¯ÊıÖ¸Õë½á¹¹Ìå¡£
+
+¶¥²ãº¯ÊıÖ¸Õë½á¹¹Ìå°üº¬ÁËÖ¸Ïò¸÷Ààº¯ÊıÖ¸Õë½á¹¹ÌåµÄÖ¸Õë£¬Èç¹û×ÓÉè±¸Çı¶¯
+²»Ö§³Ö¸ÃÀàº¯ÊıÖĞµÄÈÎºÎÒ»¸ö¹¦ÄÜ£¬ÔòÖ¸Ïò¸ÃÀà½á¹¹ÌåµÄÖ¸ÕëÎªNULL¡£
+
+ÕâĞ©½á¹¹Ìå¶¨ÒåÈçÏÂ£º
+
+struct v4l2_subdev_core_ops {
+	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
+	int (*log_status)(struct v4l2_subdev *sd);
+	int (*init)(struct v4l2_subdev *sd, u32 val);
+	...
+};
+
+struct v4l2_subdev_tuner_ops {
+	...
+};
+
+struct v4l2_subdev_audio_ops {
+	...
+};
+
+struct v4l2_subdev_video_ops {
+	...
+};
+
+struct v4l2_subdev_pad_ops {
+	...
+};
+
+struct v4l2_subdev_ops {
+	const struct v4l2_subdev_core_ops  *core;
+	const struct v4l2_subdev_tuner_ops *tuner;
+	const struct v4l2_subdev_audio_ops *audio;
+	const struct v4l2_subdev_video_ops *video;
+	const struct v4l2_subdev_pad_ops *video;
+};
+
+ÆäÖĞ core£¨ºËĞÄ£©º¯Êı¼¯Í¨³£¿ÉÓÃÓÚËùÓĞ×ÓÉè±¸£¬ÆäËûÀà±ğµÄÊµÏÖÒÀÀµÓÚ
+×ÓÉè±¸¡£ÈçÊÓÆµÉè±¸¿ÉÄÜ²»Ö§³ÖÒôÆµ²Ù×÷º¯Êı£¬·´Ö®ÒàÈ»¡£
+
+ÕâÑùµÄÉèÖÃÔÚÏŞÖÆÁËº¯ÊıÖ¸ÕëÊıÁ¿µÄÍ¬Ê±£¬»¹Ê¹Ôö¼ÓĞÂµÄ²Ù×÷º¯ÊıºÍ·ÖÀà
+±äµÃ½ÏÎªÈİÒ×¡£
+
+×ÓÉè±¸Çı¶¯¿ÉÊ¹ÓÃÈçÏÂº¯Êı³õÊ¼»¯ v4l2_subdev ½á¹¹Ìå£º
+
+	v4l2_subdev_init(sd, &ops);
+
+È»ºó£¬Äã±ØĞëÓÃÒ»¸öÎ¨Ò»µÄÃû×Ö³õÊ¼»¯ subdev->name£¬²¢³õÊ¼»¯Ä£¿éµÄ
+owner Óò¡£ÈôÊ¹ÓÃ i2c ¸¨Öúº¯Êı£¬ÕâĞ©¶¼»á°ïÄã´¦ÀíºÃ¡£
+
+ÈôĞèÍ¬Ã½Ìå¿ò¼ÜÕûºÏ£¬Äã±ØĞëµ÷ÓÃ media_entity_init() ³õÊ¼»¯ v4l2_subdev
+½á¹¹ÌåÖĞµÄ media_entity ½á¹¹Ìå£¨entity Óò£©£º
+
+	struct media_pad *pads = &my_sd->pads;
+	int err;
+
+	err = media_entity_init(&sd->entity, npads, pads, 0);
+
+pads Êı×é±ØĞëÔ¤ÏÈ³õÊ¼»¯¡£ÎŞĞëÊÖ¶¯ÉèÖÃ media_entity µÄ type ºÍ
+name Óò£¬µ«ÈçÓĞ±ØÒª£¬revision Óò±ØĞë³õÊ¼»¯¡£
+
+µ±£¨ÈÎºÎ£©×ÓÉè±¸½Úµã±»´ò¿ª/¹Ø±Õ£¬¶Ô entity µÄÒıÓÃ½«±»×Ô¶¯»ñÈ¡/ÊÍ·Å¡£
+
+ÔÚ×ÓÉè±¸±»×¢ÏúÖ®ºó£¬²»ÒªÍü¼ÇÇåÀí media_entity ½á¹¹Ìå£º
+
+	media_entity_cleanup(&sd->entity);
+
+Èç¹û×ÓÉè±¸Çı¶¯Ç÷ÏòÓÚ´¦ÀíÊÓÆµ²¢ÕûºÏ½øÁËÃ½Ìå¿ò¼Ü£¬±ØĞëÊ¹ÓÃ v4l2_subdev_pad_ops
+Ìæ´ú v4l2_subdev_video_ops ÊµÏÖ¸ñÊ½Ïà¹ØµÄ¹¦ÄÜ¡£
+
+ÕâÖÖÇé¿öÏÂ£¬×ÓÉè±¸Çı¶¯Ó¦¸ÃÉèÖÃ link_validate Óò£¬ÒÔÌá¹©Ëü×ÔÉíµÄÁ´½Ó
+ÑéÖ¤º¯Êı¡£Á´½ÓÑéÖ¤º¯ÊıÓ¦¶Ô¹ÜµÀ£¨Á½¶ËÁ´½ÓµÄ¶¼ÊÇ V4L2 ×ÓÉè±¸£©ÖĞµÄÃ¿¸ö
+Á´½Óµ÷ÓÃ¡£Çı¶¯»¹Òª¸ºÔğÑéÖ¤×ÓÉè±¸ºÍÊÓÆµ½Úµã¼ä¸ñÊ½ÅäÖÃµÄÕıÈ·ĞÔ¡£
+
+Èç¹û link_validate ²Ù×÷Ã»ÓĞÉèÖÃ£¬Ä¬ÈÏµÄ v4l2_subdev_link_validate_default()
+º¯Êı½«»á±»µ÷ÓÃ¡£Õâ¸öº¯Êı±£Ö¤¿í¡¢¸ßºÍÃ½Ìå×ÜÏßÏñËØ¸ñÊ½ÔÚÁ´½ÓµÄÊÕ·¢Á½¶Ë
+¶¼Ò»ÖÂ¡£×ÓÉè±¸Çı¶¯³ıÁËËüÃÇ×Ô¼ºµÄ¼ì²âÍâ£¬Ò²¿ÉÒÔ×ÔÓÉÊ¹ÓÃÕâ¸öº¯ÊıÒÔÖ´ĞĞ
+ÉÏÃæÌáµ½µÄ¼ì²é¡£
+
+Éè±¸£¨ÇÅ£©Çı¶¯³ÌĞò±ØĞëÏò v4l2_device ×¢²á v4l2_subdev£º
+
+	int err = v4l2_device_register_subdev(v4l2_dev, sd);
+
+Èç¹û×ÓÉè±¸Ä£¿éÔÚËü×¢²áÇ°ÏûÊ§£¬Õâ¸ö²Ù×÷¿ÉÄÜÊ§°Ü¡£ÔÚÕâ¸öº¯Êı³É¹¦·µ»Øºó£¬
+subdev->dev Óò¾ÍÖ¸ÏòÁË v4l2_device¡£
+
+Èç¹û v4l2_device ¸¸Éè±¸µÄ mdev ÓòÎª·Ç NULL Öµ£¬Ôò×ÓÉè±¸ÊµÌå½«±»×Ô¶¯
+×¢²áÎªÃ½ÌåÉè±¸¡£
+
+×¢Ïú×ÓÉè±¸Ôò¿ÉÓÃÈçÏÂº¯Êı£º
+
+	v4l2_device_unregister_subdev(sd);
+
+´Ëºó£¬×ÓÉè±¸Ä£¿é¾Í¿ÉĞ¶ÔØ£¬ÇÒ sd->dev == NULL¡£
+
+×¢²áÖ®Éè±¸ºó£¬¿ÉÍ¨¹ıÒÔÏÂ·½Ê½Ö±½Óµ÷ÓÃÆä²Ù×÷º¯Êı£º
+
+	err = sd->ops->core->g_chip_ident(sd, &chip);
+
+µ«Ê¹ÓÃÈçÏÂºê»á±È½ÏÈİÒ×ÇÒºÏÊÊ£º
+
+	err = v4l2_subdev_call(sd, core, g_chip_ident, &chip);
+
+Õâ¸öºê½«»á×ö NULL Ö¸Õë¼ì²é£¬Èç¹û subdev Îª NULL£¬Ôò·µ»Ø-ENODEV£»Èç¹û
+subdev->core »ò subdev->core->g_chip_ident Îª NULL£¬Ôò·µ»Ø -ENOIOCTLCMD£»
+·ñÔò½«·µ»Ø subdev->ops->core->g_chip_ident ops µ÷ÓÃµÄÊµ¼Ê½á¹û¡£
+
+ÓĞÊ±Ò²¿ÉÄÜÍ¬Ê±µ÷ÓÃËùÓĞ»òÒ»ÏµÁĞ×ÓÉè±¸µÄÄ³¸ö²Ù×÷º¯Êı£º
+
+	v4l2_device_call_all(v4l2_dev, 0, core, g_chip_ident, &chip);
+
+ÈÎºÎ²»Ö§³Ö´Ë²Ù×÷µÄ×ÓÉè±¸¶¼»á±»Ìø¹ı£¬²¢ºöÂÔ´íÎó·µ»ØÖµ¡£µ«Èç¹ûÄãĞèÒª
+¼ì²é³ö´íÂë£¬Ôò¿ÉÊ¹ÓÃÈçÏÂº¯Êı£º
+
+	err = v4l2_device_call_until_err(v4l2_dev, 0, core, g_chip_ident, &chip);
+
+³ı -ENOIOCTLCMD ÍâµÄÈÎºÎ´íÎó¶¼»áÌø³öÑ­»·²¢·µ»Ø´íÎóÖµ¡£Èç¹û£¨³ı -ENOIOCTLCMD
+Íâ£©Ã»ÓĞ´íÎó·¢Éú£¬Ôò·µ»Ø 0¡£
+
+¶ÔÓÚÒÔÉÏÁ½¸öº¯ÊıµÄµÚ¶ş¸ö²ÎÊıÎª×é ID¡£Èç¹ûÎª 0£¬ÔòËùÓĞ×ÓÉè±¸¶¼»áÖ´ĞĞ
+Õâ¸ö²Ù×÷¡£Èç¹ûÎª·Ç 0 Öµ£¬ÔòÖ»ÓĞÄÇĞ©×é ID Æ¥ÅäµÄ×ÓÉè±¸²Å»áÖ´ĞĞ´Ë²Ù×÷¡£
+ÔÚÇÅÇı¶¯×¢²áÒ»¸ö×ÓÉè±¸Ç°£¬¿ÉÒÔÉèÖÃ sd->grp_id ÎªÈÎºÎÆÚÍûÖµ£¨Ä¬ÈÏÖµÎª
+0£©¡£Õâ¸öÖµÊôÓÚÇÅÇı¶¯£¬ÇÒ×ÓÉè±¸Çı¶¯½«²»»áĞŞ¸ÄºÍÊ¹ÓÃËü¡£
+
+×é ID ¸³ÓèÁËÇÅÇı¶¯¸ü¶à¶ÔÓÚÈçºÎµ÷ÓÃ»Øµ÷µÄ¿ØÖÆ¡£ÀıÈç£¬µçÂ·°åÉÏÓĞ¶à¸ö
+ÒôÆµĞ¾Æ¬£¬Ã¿¸ö¶¼ÓĞ¸Ä±äÒôÁ¿µÄÄÜÁ¦¡£µ«µ±ÓÃ»§ÏëÒª¸Ä±äÒôÁ¿µÄÊ±ºò£¬Í¨³£
+Ö»ÓĞÒ»¸ö»á±»Êµ¼ÊÊ¹ÓÃ¡£Äã¿ÉÒÔ¶ÔÕâÑùµÄ×ÓÉè±¸ÉèÖÃ×é ID Îª£¨ÀıÈç AUDIO_CONTROLLER£©
+²¢ÔÚµ÷ÓÃ v4l2_device_call_all() Ê±Ö¸¶¨ËüÎª×é ID Öµ¡£Õâ¾Í±£Ö¤ÁËÖ»ÓĞ
+ĞèÒªµÄ×ÓÉè±¸²Å»áÖ´ĞĞÕâ¸ö»Øµ÷¡£
+
+Èç¹û×ÓÉè±¸ĞèÒªÍ¨ÖªËüµÄ v4l2_device ¸¸Éè±¸Ò»¸öÊÂ¼ş£¬¿ÉÒÔµ÷ÓÃ
+v4l2_subdev_notify(sd, notification, arg)¡£Õâ¸öºê¼ì²éÊÇ·ñÓĞÒ»¸ö
+notify() »Øµ÷±»×¢²á£¬Èç¹ûÃ»ÓĞ£¬·µ»Ø -ENODEV¡£·ñÔò·µ»Ø notify() µ÷ÓÃ
+½á¹û¡£
+
+Ê¹ÓÃ v4l2_subdev µÄºÃ´¦ÔÚÓÚËüÊÇÒ»¸öÍ¨ÓÃ½á¹¹Ìå£¬ÇÒ²»°üº¬ÈÎºÎµ×²ãÓ²¼ş
+ĞÅÏ¢¡£ËùÓĞÇı¶¯¿ÉÒÔ°üº¬¶à¸ö I2C ×ÜÏßµÄ×ÓÉè±¸£¬µ«Ò²ÓĞ×ÓÉè±¸ÊÇÍ¨¹ı GPIO
+¿ØÖÆ¡£Õâ¸öÇø±ğ½öÔÚÅäÖÃÉè±¸Ê±ÓĞ¹ØÏµ£¬Ò»µ©×ÓÉè±¸×¢²áÍê³É£¬¶ÔÓÚ v4l2
+×ÓÏµÍ³À´Ëµ¾ÍÍêÈ«Í¸Ã÷ÁË¡£
+
+
+V4L2 ×ÓÉè±¸ÓÃ»§¿Õ¼äAPI
+--------------------
+
+³ıÁËÍ¨¹ı v4l2_subdev_ops ½á¹¹µ¼³öµÄÄÚºË API£¬V4L2 ×ÓÉè±¸Ò²¿ÉÒÔÖ±½Ó
+Í¨¹ıÓÃ»§¿Õ¼äÓ¦ÓÃ³ÌĞòÀ´¿ØÖÆ¡£
+
+¿ÉÒÔÔÚ /dev ÖĞ´´½¨ÃûÎª v4l-subdevX Éè±¸½Úµã£¬ÒÔÍ¨¹ıÆäÖ±½Ó·ÃÎÊ×ÓÉè±¸¡£
+Èç¹û×ÓÉè±¸Ö§³ÖÓÃ»§¿Õ¼äÖ±½ÓÅäÖÃ£¬±ØĞëÔÚ×¢²áÇ°ÉèÖÃ V4L2_SUBDEV_FL_HAS_DEVNODE
+±êÖ¾¡£
+
+×¢²á×ÓÉè±¸Ö®ºó£¬ v4l2_device Çı¶¯»áÍ¨¹ıµ÷ÓÃ v4l2_device_register_subdev_nodes()
+º¯ÊıÎªËùÓĞÒÑ×¢²á²¢ÉèÖÃÁË V4L2_SUBDEV_FL_HAS_DEVNODE µÄ×ÓÉè±¸´´½¨
+Éè±¸½Úµã¡£ÕâĞ©Éè±¸½Úµã»áÔÚ×ÓÉè±¸×¢ÏúÊ±×Ô¶¯É¾³ı¡£
+
+ÕâĞ©Éè±¸½Úµã´¦Àí V4L2 API µÄÒ»¸ö×Ó¼¯¡£
+
+VIDIOC_QUERYCTRL
+VIDIOC_QUERYMENU
+VIDIOC_G_CTRL
+VIDIOC_S_CTRL
+VIDIOC_G_EXT_CTRLS
+VIDIOC_S_EXT_CTRLS
+VIDIOC_TRY_EXT_CTRLS
+
+	ÕâĞ© ioctls ¿ØÖÆÓë V4L2 ÖĞ¶¨ÒåµÄÒ»ÖÂ¡£ËûÃÇĞĞÎªÏàÍ¬£¬Î¨Ò»µÄ
+	²»Í¬ÊÇËûÃÇÖ»´¦Àí×ÓÉè±¸µÄ¿ØÖÆÊµÏÖ¡£¸ù¾İÇı¶¯³ÌĞò£¬ÕâĞ©¿ØÖÆÒ²
+	¿ÉÒÔÍ¨¹ıÒ»¸ö£¨»ò¶à¸ö£© V4L2 Éè±¸½Úµã·ÃÎÊ¡£
+
+VIDIOC_DQEVENT
+VIDIOC_SUBSCRIBE_EVENT
+VIDIOC_UNSUBSCRIBE_EVENT
+
+	ÕâĞ©  ioctls ÊÂ¼şÓë V4L2 ÖĞ¶¨ÒåµÄÒ»ÖÂ¡£ËûÃÇĞĞÎªÏàÍ¬£¬Î¨Ò»µÄ
+	²»Í¬ÊÇËûÃÇÖ»´¦Àí×ÓÉè±¸²úÉúµÄÊÂ¼ş¡£¸ù¾İÇı¶¯³ÌĞò£¬ÕâĞ©ÊÂ¼şÒ²
+	¿ÉÒÔÍ¨¹ıÒ»¸ö£¨»ò¶à¸ö£© V4L2 Éè±¸½ÚµãÉÏ±¨¡£
+
+	ÒªÊ¹ÓÃÊÂ¼şÍ¨ÖªµÄ×ÓÉè±¸Çı¶¯£¬ÔÚ×¢²á×ÓÉè±¸Ç°±ØĞëÔÚ v4l2_subdev::flags
+	ÖĞÉèÖÃ V4L2_SUBDEV_USES_EVENTS ²¢ÔÚ v4l2_subdev::nevents
+	ÖĞ³õÊ¼»¯ÊÂ¼ş¶ÓÁĞÉî¶È¡£×¢²áÍê³Éºó£¬ÊÂ¼ş»áÔÚ v4l2_subdev::devnode
+	Éè±¸½ÚµãÖĞÏñÍ¨³£Ò»Ñù±»ÅÅ¶Ó¡£
+
+	ÎªÕıÈ·Ö§³ÖÊÂ¼ş»úÖÆ£¬poll() ÎÄ¼ş²Ù×÷Ò²Ó¦±»ÊµÏÖ¡£
+
+Ë½ÓĞ ioctls
+
+	²»ÔÚÒÔÉÏÁĞ±íÖĞµÄËùÓĞ ioctls »áÍ¨¹ı core::ioctl ²Ù×÷Ö±½Ó´«µİ
+	¸ø×ÓÉè±¸Çı¶¯¡£
+
+
+I2C ×ÓÉè±¸Çı¶¯
+-------------
+
+ÓÉÓÚÕâĞ©Çı¶¯ºÜ³£¼û£¬ËùÒÔÄÚÌØÌá¹©ÁËÌØ¶¨µÄ¸¨Öúº¯Êı(v4l2-common.h)ÈÃÕâĞ©
+Éè±¸µÄÊ¹ÓÃ¸ü¼ÓÈİÒ×¡£
+
+Ìí¼Ó v4l2_subdev Ö§³ÖµÄÍÆ¼ö·½·¨ÊÇÈÃ I2C Çı¶¯½« v4l2_subdev ½á¹¹Ìå
+Ç¶Èëµ½ÎªÃ¿¸ö I2C Éè±¸ÊµÀı´´½¨µÄ×´Ì¬½á¹¹ÌåÖĞ¡£¶ø×î¼òµ¥µÄÉè±¸Ã»ÓĞ×´Ì¬
+½á¹¹Ìå£¬´ËÊ±¿ÉÒÔÖ±½Ó´´½¨Ò»¸ö v4l2_subdev ½á¹¹Ìå¡£
+
+Ò»¸öµäĞÍµÄ×´Ì¬½á¹¹ÌåÈçÏÂËùÊ¾£¨¡®chipname¡¯ÓÃĞ¾Æ¬Ãû´úÌæ£©£º
+
+struct chipname_state {
+	struct v4l2_subdev sd;
+	...  /* ¸½¼ÓµÄ×´Ì¬Óò*/
+};
+
+³õÊ¼»¯ v4l2_subdev ½á¹¹ÌåµÄ·½·¨ÈçÏÂ£º
+
+	v4l2_i2c_subdev_init(&state->sd, client, subdev_ops);
+
+Õâ¸öº¯Êı½«Ìî³ä v4l2_subdev ½á¹¹ÌåÖĞµÄËùÓĞÓò£¬²¢±£Ö¤ v4l2_subdev ºÍ
+i2c_client ¶¼Ö¸Ïò±Ë´Ë¡£
+
+Í¬Ê±£¬ÄãÒ²Ó¦¸ÃÎª´Ó v4l2_subdev Ö¸ÕëÕÒµ½ chipname_state ½á¹¹ÌåÖ¸Õë
+Ìí¼ÓÒ»¸ö¸¨ÖúÄÚÁªº¯Êı¡£
+
+static inline struct chipname_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct chipname_state, sd);
+}
+
+Ê¹ÓÃÒÔÏÂº¯Êı¿ÉÒÔÍ¨¹ı v4l2_subdev ½á¹¹ÌåÖ¸Õë»ñµÃ i2c_client ½á¹¹Ìå
+Ö¸Õë£º
+
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+¶øÒÔÏÂº¯ÊıÔòÏà·´£¬Í¨¹ı i2c_client ½á¹¹ÌåÖ¸Õë»ñµÃ v4l2_subdev ½á¹¹Ìå
+Ö¸Õë£º
+
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+µ± remove()º¯Êı±»µ÷ÓÃÇ°£¬±ØĞë±£Ö¤ÏÈµ÷ÓÃ v4l2_device_unregister_subdev(sd)¡£
+´Ë²Ù×÷½«»á´ÓÇÅÇı¶¯ÖĞ×¢Ïú×ÓÉè±¸¡£¼´Ê¹×ÓÉè±¸Ã»ÓĞ×¢²á£¬µ÷ÓÃ´Ëº¯ÊıÒ²ÊÇ
+°²È«µÄ¡£
+
+±ØĞëÕâÑù×öµÄÔ­ÒòÊÇ£ºµ±ÇÅÇı¶¯×¢Ïú i2c ÊÊÅäÆ÷Ê±£¬remove()»Øµ÷º¯Êı
+»á±»ÄÇ¸öÊÊÅäÆ÷ÉÏµÄ i2c Éè±¸µ÷ÓÃ¡£´Ëºó£¬ÏàÓ¦µÄ v4l2_subdev ½á¹¹Ìå
+¾Í²»´æÔÚÁË£¬ËùÓĞËüÃÇ±ØĞëÏÈ±»×¢Ïú¡£ÔÚ remove()»Øµ÷º¯ÊıÖĞµ÷ÓÃ
+v4l2_device_unregister_subdev(sd)£¬¿ÉÒÔ±£Ö¤Ö´ĞĞ×ÜÊÇÕıÈ·µÄ¡£
+
+
+ÇÅÇı¶¯Ò²ÓĞÒ»Ğ©¸¨×éº¯Êı¿ÉÓÃ£º
+
+struct v4l2_subdev *sd = v4l2_i2c_new_subdev(v4l2_dev, adapter,
+	       "module_foo", "chipid", 0x36, NULL);
+
+Õâ¸öº¯Êı»á¼ÓÔØ¸ø¶¨µÄÄ£¿é£¨Èç¹ûÃ»ÓĞÄ£¿éĞèÒª¼ÓÔØ£¬¿ÉÒÔÎª NULL£©£¬
+²¢ÓÃ¸ø¶¨µÄ i2c ÊÊÅäÆ÷½á¹¹ÌåÖ¸Õë£¨i2c_adapter£©ºÍ Æ÷¼şµØÖ·£¨chip/address£©
+×÷Îª²ÎÊıµ÷ÓÃ i2c_new_device()¡£Èç¹ûÒ»ÇĞË³Àû£¬Ôò¾ÍÔÚ v4l2_device
+ÖĞ×¢²áÁË×ÓÉè±¸¡£
+
+ÄãÒ²¿ÉÒÔÀûÓÃ v4l2_i2c_new_subdev()µÄ×îºóÒ»¸ö²ÎÊı£¬´«µİÒ»¸ö¿ÉÄÜµÄ
+I2C µØÖ·Êı×é£¬ÈÃº¯Êı×Ô¶¯Ì½²â¡£ÕâĞ©Ì½²âµØÖ·Ö»ÓĞÔÚÇ°Ò»¸ö²ÎÊıÎª 0 µÄ
+Çé¿öÏÂÊ¹ÓÃ¡£·ÇÁã²ÎÊıÒâÎ¶×ÅÄãÖªµÀ×¼È·µÄ i2c µØÖ·£¬ËùÒÔ´ËÊ±ÎŞĞë½øĞĞ
+Ì½²â¡£
+
+Èç¹û³ö´í£¬Á½¸öº¯Êı¶¼·µ»Ø NULL¡£
+
+×¢Òâ£º´«µİ¸ø v4l2_i2c_new_subdev()µÄ chipid Í¨³£ÓëÄ£¿éÃûÒ»ÖÂ¡£
+ËüÔÊĞíÄãÖ¸¶¨Ò»¸öĞ¾Æ¬µÄ±äÌå£¬±ÈÈç¡°saa7114¡±»ò¡°saa7115¡±¡£Ò»°ãÍ¨¹ı
+i2c Çı¶¯×Ô¶¯Ì½²â¡£chipid µÄÊ¹ÓÃÊÇÔÚ½ñºóĞèÒªÉîÈëÁË½âµÄÊÂÇé¡£Õâ¸öÓë
+i2c Çı¶¯²»Í¬£¬½ÏÈİÒ×»ìÏı¡£ÒªÖªµÀÖ§³ÖÄÄĞ©Ğ¾Æ¬±äÌå£¬Äã¿ÉÒÔ²éÔÄ i2c
+Çı¶¯´úÂëµÄ i2c_device_id ±í£¬ÉÏÃæÁĞ³öÁËËùÓĞ¿ÉÄÜÖ§³ÖµÄĞ¾Æ¬¡£
+
+»¹ÓĞÁ½¸ö¸¨Öúº¯Êı£º
+
+v4l2_i2c_new_subdev_cfg£ºÕâ¸öº¯ÊıÌí¼ÓĞÂµÄ irq ºÍ platform_data
+²ÎÊı£¬²¢ÓĞ¡®addr¡¯ºÍ¡®probed_addrs¡¯²ÎÊı£ºÈç¹û addr ·ÇÁã£¬Ôò±»Ê¹ÓÃ
+£¨²»Ì½²â±äÌå£©£¬·ñÔò probed_addrs ÖĞµÄµØÖ·½«ÓÃÓÚ×Ô¶¯Ì½²â¡£
+
+ÀıÈç£ºÒÔÏÂ´úÂë½«»áÌ½²âµØÖ·£¨0x10£©£º
+
+struct v4l2_subdev *sd = v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter,
+	       "module_foo", "chipid", 0, NULL, 0, I2C_ADDRS(0x10));
+
+v4l2_i2c_new_subdev_board Ê¹ÓÃÒ»¸ö i2c_board_info ½á¹¹Ìå£¬½«Æä
+Ìæ´ú irq¡¢platform_data ºÍ add r²ÎÊı´«µİ¸ø i2c Çı¶¯¡£
+
+Èç¹û×ÓÉè±¸Ö§³Ö s_config ºËĞÄ²Ù×÷£¬Õâ¸ö²Ù×÷»áÔÚ×ÓÉè±¸ÅäÖÃºÃÖ®ºóÒÔ irq ºÍ
+platform_data Îª²ÎÊıµ÷ÓÃ¡£ÔçÆÚµÄ v4l2_i2c_new_(probed_)subdev º¯Êı
+Í¬ÑùÒ²»áµ÷ÓÃ s_config£¬µ«½öÔÚ irq Îª 0 ÇÒ platform_data Îª NULL Ê±¡£
+
+video_device½á¹¹Ìå
+-----------------
+
+ÔÚ /dev Ä¿Â¼ÏÂµÄÊµ¼ÊÉè±¸½Úµã¸ù¾İ video_device ½á¹¹Ìå(v4l2-dev.h)
+´´½¨¡£´Ë½á¹¹Ìå¼È¿ÉÒÔ¶¯Ì¬·ÖÅäÒ²¿ÉÒÔÇ¶Èëµ½Ò»¸ö¸ü´óµÄ½á¹¹ÌåÖĞ¡£
+
+¶¯Ì¬·ÖÅä·½·¨ÈçÏÂ£º
+
+	struct video_device *vdev = video_device_alloc();
+
+	if (vdev == NULL)
+		return -ENOMEM;
+
+	vdev->release = video_device_release;
+
+Èç¹û½«ÆäÇ¶Èëµ½Ò»¸ö´ó½á¹¹ÌåÖĞ£¬Ôò±ØĞë×Ô¼ºÊµÏÖ release()»Øµ÷¡£
+
+	struct video_device *vdev = &my_vdev->vdev;
+
+	vdev->release = my_vdev_release;
+
+release()»Øµ÷±ØĞë±»ÉèÖÃ£¬ÇÒÔÚ×îºóÒ»¸ö video_device ÓÃ»§ÍË³öÖ®ºó
+±»µ÷ÓÃ¡£
+
+Ä¬ÈÏµÄ video_device_release()»Øµ÷Ö»ÊÇµ÷ÓÃ kfree À´ÊÍ·ÅÖ®Ç°·ÖÅäµÄ
+ÄÚ´æ¡£
+
+ÄãÓ¦¸ÃÉèÖÃÕâĞ©Óò£º
+
+- v4l2_dev: ÉèÖÃÎª v4l2_device ¸¸Éè±¸¡£
+
+- name: ÉèÖÃÎªÎ¨Ò»µÄÃèÊöĞÔÉè±¸Ãû¡£
+
+- fops: ÉèÖÃÎªÒÑÓĞµÄ v4l2_file_operations ½á¹¹Ìå¡£
+
+- ioctl_ops: Èç¹ûÄãÊ¹ÓÃv4l2_ioctl_ops À´¼ò»¯ ioctl µÄÎ¬»¤
+  (Ç¿ÁÒ½¨ÒéÊ¹ÓÃ£¬ÇÒ½«À´¿ÉÄÜ±äÎªÇ¿ÖÆĞÔµÄ!)£¬È»ºóÉèÖÃÄã×Ô¼ºµÄ
+  v4l2_ioctl_ops ½á¹¹Ìå.
+
+- lock: Èç¹ûÄãÒªÔÚÇı¶¯ÖĞÊµÏÖËùÓĞµÄËø²Ù×÷£¬ÔòÉèÎª NULL ¡£·ñÔò
+  ¾ÍÒªÉèÖÃÒ»¸öÖ¸Ïò struct mutex_lock ½á¹¹ÌåµÄÖ¸Õë£¬Õâ¸öËø½«
+  ÔÚ unlocked_ioctl ÎÄ¼ş²Ù×÷±»µ÷ÓÃÇ°ÓÉÄÚºË»ñµÃ£¬²¢ÔÚµ÷ÓÃ·µ»Øºó
+  ÊÍ·Å¡£Ïê¼ûÏÂÒ»½Ú¡£
+
+- prio: ±£³Ö¶ÔÓÅÏÈ¼¶µÄ¸ú×Ù¡£ÓÃÓÚÊµÏÖ VIDIOC_G/S_PRIORITY¡£Èç¹û
+  ÉèÖÃÎª NULL£¬Ôò»áÊ¹ÓÃ v4l2_device ÖĞµÄ v4l2_prio_state ½á¹¹Ìå¡£
+  Èç¹ûÒª¶ÔÃ¿¸öÉè±¸½Úµã£¨×é£©ÊµÏÖ¶ÀÁ¢µÄÓÅÏÈ¼¶£¬¿ÉÒÔ½«ÆäÖ¸Ïò×Ô¼º
+  ÊµÏÖµÄ v4l2_prio_state ½á¹¹Ìå¡£
+
+- parent: ½öÔÚÊ¹ÓÃ NULL ×÷Îª¸¸Éè±¸½á¹¹Ìå²ÎÊı×¢²á v4l2_device Ê±
+  ÉèÖÃ´Ë²ÎÊı¡£Ö»ÓĞÔÚÒ»¸öÓ²¼şÉè±¸°üº¬¶àÒ»¸ö PCI Éè±¸£¬¹²ÏíÍ¬Ò»¸ö
+  v4l2_device ºËĞÄÊ±²Å»á·¢Éú¡£
+
+  cx88 Çı¶¯¾ÍÊÇÒ»¸öÀı×Ó£ºÒ»¸ö v4l2_device ½á¹¹ÌåºËĞÄ£¬±»Ò»¸öÂãµÄ
+  ÊÓÆµ PCI Éè±¸(cx8800)ºÍÒ»¸ö MPEG PCI Éè±¸(cx8802)¹²ÓÃ¡£ÓÉÓÚ
+  v4l2_device ÎŞ·¨ÓëÌØ¶¨µÄ PCI Éè±¸¹ØÁª£¬ËùÓĞÃ»ÓĞÉèÖÃ¸¸Éè±¸¡£µ«µ±
+  video_device ÅäÖÃºó£¬¾ÍÖªµÀÊ¹ÓÃÄÄ¸ö¸¸ PCI Éè±¸ÁË¡£
+
+- flags£º¿ÉÑ¡¡£Èç¹ûÄãÒªÈÃ¿ò¼Ü´¦ÀíÉèÖÃ VIDIOC_G/S_PRIORITY ioctls£¬
+  ÇëÉèÖÃ V4L2_FL_USE_FH_PRIO¡£ÕâÒªÇóÄãÊ¹ÓÃ v4l2_fh ½á¹¹Ìå¡£
+  Ò»µ©ËùÓĞÇı¶¯Ê¹ÓÃÁËºËĞÄµÄÓÅÏÈ¼¶´¦Àí£¬×îÖÕÕâ¸ö±êÖ¾½«ÏûÊ§¡£µ«ÏÖÔÚËü
+  ±ØĞë±»ÏÔÊ½ÉèÖÃ¡£
+
+Èç¹ûÄãÊ¹ÓÃ v4l2_ioctl_ops£¬ÔòÓ¦¸ÃÔÚ v4l2_file_operations ½á¹¹ÌåÖĞ
+ÉèÖÃ .unlocked_ioctl Ö¸Ïò video_ioctl2¡£
+
+ÇëÎğÊ¹ÓÃ .ioctl£¡ËüÒÑ±»·ÏÆú£¬½ñºó½«ÏûÊ§¡£
+
+Ä³Ğ©Çé¿öÏÂÄãÒª¸æËßºËĞÄ£ºÄãÔÚ v4l2_ioctl_ops Ö¸¶¨µÄÄ³¸öº¯ÊıÓ¦±»ºöÂÔ¡£
+Äã¿ÉÒÔÔÚ video_device_register ±»µ÷ÓÃÇ°Í¨¹ıÒÔÏÂº¯Êı±ê¼ÇÕâ¸ö ioctls¡£
+
+void v4l2_disable_ioctl(struct video_device *vdev, unsigned int cmd);
+
+»ùÓÚÍâ²¿ÒòËØ£¨ÀıÈçÄ³¸ö°å¿¨ÒÑ±»Ê¹ÓÃ£©£¬ÔÚ²»´´½¨ĞÂ½á¹¹ÌåµÄÇé¿öÏÂ£¬ÄãÏë
+Òª¹Ø±Õ v4l2_ioctl_ops ÖĞÄ³¸öÌØĞÔÍùÍùĞèÒªÕâ¸ö»úÖÆ¡£
+
+v4l2_file_operations ½á¹¹ÌåÊÇ file_operations µÄÒ»¸ö×Ó¼¯¡£ÆäÖ÷Òª
+Çø±ğÔÚÓÚ£ºÒò inode ²ÎÊı´ÓÎ´±»Ê¹ÓÃ£¬Ëü½«±»ºöÂÔ¡£
+
+Èç¹ûĞèÒªÓëÃ½Ìå¿ò¼ÜÕûºÏ£¬Äã±ØĞëÍ¨¹ıµ÷ÓÃ media_entity_init() ³õÊ¼»¯
+Ç¶ÈëÔÚ video_device ½á¹¹ÌåÖĞµÄ media_entity£¨entity Óò£©½á¹¹Ìå£º
+
+	struct media_pad *pad = &my_vdev->pad;
+	int err;
+
+	err = media_entity_init(&vdev->entity, 1, pad, 0);
+
+pads Êı×é±ØĞëÔ¤ÏÈ³õÊ¼»¯¡£Ã»ÓĞ±ØÒªÊÖ¶¯ÉèÖÃ media_entity µÄ type ºÍ
+name Óò¡£
+
+µ±£¨ÈÎºÎ£©×ÓÉè±¸½Úµã±»´ò¿ª/¹Ø±Õ£¬¶Ô entity µÄÒıÓÃ½«±»×Ô¶¯»ñÈ¡/ÊÍ·Å¡£
+
+v4l2_file_operations ÓëËø
+--------------------------
+
+Äã¿ÉÒÔÔÚ video_device ½á¹¹ÌåÖĞÉèÖÃÒ»¸öÖ¸Ïò mutex_lock µÄÖ¸Õë¡£Í¨³£
+Õâ¼È¿ÉÊÇÒ»¸ö¶¥²ã»¥³âËøÒ²¿ÉÎªÉè±¸½Úµã×ÔÉíµÄ»¥³âËø¡£Ä¬ÈÏÇé¿öÏÂ£¬´ËËø
+ÓÃÓÚ unlocked_ioctl£¬µ«ÎªÁËÊ¹ÓÃ ioctls ÄãÍ¨¹ıÒÔÏÂº¯Êı¿É½ûÓÃËø¶¨£º
+
+	void v4l2_disable_ioctl_locking(struct video_device *vdev, unsigned int cmd);
+
+ÀıÈç: v4l2_disable_ioctl_locking(vdev, VIDIOC_DQBUF);
+
+Äã±ØĞëÔÚ×¢²á video_device Ç°µ÷ÓÃÕâ¸öº¯Êı¡£
+
+ÌØ±ğÊÇ¶ÔÓÚ USB Çı¶¯³ÌĞò£¬Ä³Ğ©ÃüÁî£¨ÈçÉèÖÃ¿ØÖÆ£©ĞèÒªºÜ³¤µÄÊ±¼ä£¬¿ÉÄÜ
+ĞèÒª×ÔĞĞÎª»º³åÇø¶ÓÁĞµÄ ioctls ÊµÏÖËø¶¨¡£
+
+Èç¹ûÄãĞèÒª¸üÏ¸Á£¶ÈµÄËø£¬Äã±ØĞëÉèÖÃ mutex_lock Îª NULL£¬²¢ÍêÈ«×Ô¼ºÊµÏÖ
+Ëø»úÖÆ¡£
+
+ÕâÍêÈ«ÓÉÇı¶¯¿ª·¢Õß¾ö¶¨Ê¹ÓÃºÎÖÖ·½·¨¡£È»¶ø£¬Èç¹ûÄãµÄÇı¶¯´æÔÚ³¤ÑÓÊ±²Ù×÷
+£¨ÀıÈç£¬¸Ä±ä USB ÉãÏñÍ·µÄÆØ¹âÊ±¼ä¿ÉÄÜĞèÒª½Ï³¤Ê±¼ä£©£¬¶øÄãÓÖÏëÈÃÓÃ»§
+ÔÚµÈ´ı³¤ÑÓÊ±²Ù×÷Íê³ÉÆÚ¼ä×öÆäËûµÄÊÂ£¬ÔòÄã×îºÃ×Ô¼ºÊµÏÖËø»úÖÆ¡£
+
+Èç¹ûÖ¸¶¨Ò»¸öËø£¬ÔòËùÓĞ ioctl ²Ù×÷½«ÔÚÕâ¸öËøµÄ×÷ÓÃÏÂ´®ĞĞÖ´ĞĞ¡£Èç¹ûÄã
+Ê¹ÓÃ videobuf£¬Ôò±ØĞë½«Í¬Ò»¸öËø´«µİ¸ø videobuf ¶ÓÁĞ³õÊ¼»¯º¯Êı£»Èç
+videobuf ±ØĞëµÈ´ıÒ»Ö¡µÄµ½´ï£¬Ôò¿ÉÁÙÊ±½âËø²¢ÔÚÕâÖ®ºóÖØĞÂÉÏËø¡£Èç¹ûÇı¶¯
+Ò²ÔÚ´úÂëÖ´ĞĞÆÚ¼äµÈ´ı£¬Ôò¿É×öÍ¬ÑùµÄ¹¤×÷£¨ÁÙÊ±½âËø£¬ÔÙÉÏËø£©ÈÃÆäËû½ø³Ì
+¿ÉÒÔÔÚµÚÒ»¸ö½ø³Ì×èÈûÊ±·ÃÎÊÉè±¸½Úµã¡£
+
+ÔÚÊ¹ÓÃ videobuf2 µÄÇé¿öÏÂ£¬±ØĞëÊµÏÖ wait_prepare ºÍ wait_finish »Øµ÷
+ÔÚÊÊµ±µÄÊ±ºò½âËø/¼ÓËø¡£½øÒ»²½À´Ëµ£¬Èç¹ûÄãÔÚ video_device ½á¹¹ÌåÖĞÊ¹ÓÃ
+Ëø£¬Ôò±ØĞëÔÚ wait_prepare ºÍ wait_finish ÖĞ¶ÔÕâ¸ö»¥³âËø½øĞĞ½âËø/¼ÓËø¡£
+
+ÈÈ²å°ÎµÄ¶Ï¿ªÊµÏÖÒ²±ØĞëÔÚµ÷ÓÃ v4l2_device_disconnect Ç°»ñµÃËø¡£
+
+video_device×¢²á
+---------------
+
+½ÓÏÂÀ´ÄãĞèÒª×¢²áÊÓÆµÉè±¸£ºÕâ»áÎªÄã´´½¨Ò»¸ö×Ö·ûÉè±¸¡£
+
+	err = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (err) {
+		video_device_release(vdev); /* or kfree(my_vdev); */
+		return err;
+	}
+
+Èç¹û v4l2_device ¸¸Éè±¸µÄ mdev ÓòÎª·Ç NULL Öµ£¬ÊÓÆµÉè±¸ÊµÌå½«×Ô¶¯
+×¢²áÎªÃ½ÌåÉè±¸¡£
+
+×¢²áÄÄÖÖÉè±¸ÊÇ¸ù¾İÀàĞÍ£¨type£©²ÎÊı¡£´æÔÚÒÔÏÂÀàĞÍ£º
+
+VFL_TYPE_GRABBER: ÓÃÓÚÊÓÆµÊäÈë/Êä³öÉè±¸µÄ videoX
+VFL_TYPE_VBI: ÓÃÓÚ´¹Ö±ÏûÒşÊı¾İµÄ vbiX (ÀıÈç£¬Òş²ØÊ½×ÖÄ»£¬Í¼ÎÄµçÊÓ)
+VFL_TYPE_RADIO: ÓÃÓÚ¹ã²¥µ÷Ğ³Æ÷µÄ radioX
+
+×îºóÒ»¸ö²ÎÊıÈÃÄãÈ·¶¨Ò»¸öËù¿ØÖÆÉè±¸µÄÉè±¸½ÚµãºÅÊıÁ¿(ÀıÈç videoX ÖĞµÄ X)¡£
+Í¨³£Äã¿ÉÒÔ´«Èë-1£¬ÈÃ v4l2 ¿ò¼Ü×Ô¼ºÑ¡ÔñµÚÒ»¸ö¿ÕÏĞµÄ±àºÅ¡£µ«ÊÇÓĞÊ±ÓÃ»§
+ĞèÒªÑ¡ÔñÒ»¸öÌØ¶¨µÄ½ÚµãºÅ¡£Çı¶¯ÔÊĞíÓÃ»§Í¨¹ıÇı¶¯Ä£¿é²ÎÊıÑ¡ÔñÒ»¸öÌØ¶¨µÄ
+Éè±¸½ÚµãºÅÊÇºÜÆÕ±éµÄ¡£Õâ¸ö±àºÅ½«»á´«µİ¸øÕâ¸öº¯Êı£¬ÇÒ video_register_device
+½«»áÊÔÍ¼Ñ¡ÔñÕâ¸öÉè±¸½ÚµãºÅ¡£Èç¹ûÕâ¸ö±àºÅ±»Õ¼ÓÃ£¬ÏÂÒ»¸ö¿ÕÏĞµÄÉè±¸½Úµã
+±àºÅ½«±»Ñ¡ÖĞ£¬²¢ÏòÄÚºËÈÕÖ¾ÖĞ·¢ËÍÒ»¸ö¾¯¸æĞÅÏ¢¡£
+
+ÁíÒ»¸öÊ¹ÓÃ³¡¾°ÊÇµ±Çı¶¯´´½¨¶à¸öÉè±¸Ê±¡£ÕâÖÖÇé¿öÏÂ£¬¶Ô²»Í¬µÄÊÓÆµÉè±¸ÔÚ
+±àºÅÉÏÊ¹ÓÃ²»Í¬µÄ·¶Î§ÊÇºÜÓĞÓÃµÄ¡£ÀıÈç£¬ÊÓÆµ²¶»ñÉè±¸´Ó 0 ¿ªÊ¼£¬ÊÓÆµ
+Êä³öÉè±¸´Ó 16 ¿ªÊ¼¡£ËùÒÔÄã¿ÉÒÔÊ¹ÓÃ×îºóÒ»¸ö²ÎÊıÀ´Ö¸¶¨Éè±¸½ÚµãºÅ×îĞ¡Öµ£¬
+¶ø v4l2 ¿ò¼Ü»áÊÔÍ¼Ñ¡ÔñµÚÒ»¸öµÄ¿ÕÏĞ±àºÅ£¨µÈÓÚ»ò´óÓÚÄãÌá¹©µÄ±àºÅ£©¡£
+Èç¹ûÊ§°Ü£¬ÔòËü»á¾ÍÑ¡ÔñµÚÒ»¸ö¿ÕÏĞµÄ±àºÅ¡£
+
+ÓÉÓÚÕâÖÖÇé¿öÏÂ£¬Äã»áºöÂÔÎŞ·¨Ñ¡ÔñÌØ¶¨Éè±¸½ÚµãºÅµÄ¾¯¸æ£¬Ôò¿Éµ÷ÓÃ
+video_register_device_no_warn() º¯Êı±ÜÃâ¾¯¸æĞÅÏ¢µÄ²úÉú¡£
+
+Ö»ÒªÉè±¸½Úµã±»´´½¨£¬Ò»Ğ©ÊôĞÔÒ²»áÍ¬Ê±´´½¨¡£ÔÚ /sys/class/video4linux
+Ä¿Â¼ÖĞÄã»áÕÒµ½ÕâĞ©Éè±¸¡£ÀıÈç½øÈëÆäÖĞµÄ video0 Ä¿Â¼£¬Äã»á¿´µ½¡®name¡¯ºÍ
+¡®index¡¯ÊôĞÔ¡£¡®name¡¯ÊôĞÔÖµ¾ÍÊÇ video_device ½á¹¹ÌåÖĞµÄ¡®name¡¯Óò¡£
+
+¡®index¡¯ÊôĞÔÖµ¾ÍÊÇÉè±¸½ÚµãµÄË÷ÒıÖµ£ºÃ¿´Îµ÷ÓÃ video_register_device()£¬
+Ë÷ÒıÖµ¶¼µİÔö 1 ¡£µÚÒ»¸öÊÓÆµÉè±¸½Úµã×ÜÊÇ´ÓË÷ÒıÖµ 0 ¿ªÊ¼¡£
+
+ÓÃ»§¿ÉÒÔÉèÖÃ udev ¹æÔò£¬ÀûÓÃË÷ÒıÊôĞÔÉú³É»¨ÉÚµÄÉè±¸Ãû£¨ÀıÈç£ºÓÃ¡®mpegX¡¯
+´ú±í MPEG ÊÓÆµ²¶»ñÉè±¸½Úµã£©¡£
+
+ÔÚÉè±¸³É¹¦×¢²áºó£¬¾Í¿ÉÒÔÊ¹ÓÃÕâĞ©Óò£º
+
+- vfl_type: ´«µİ¸ø video_register_device µÄÉè±¸ÀàĞÍ¡£
+- minor: ÒÑÖ¸ÅÉµÄ´ÎÉè±¸ºÅ¡£
+- num: Éè±¸½Úµã±àºÅ (ÀıÈç videoX ÖĞµÄ X)¡£
+- index: Éè±¸Ë÷ÒıºÅ¡£
+
+Èç¹û×¢²áÊ§°Ü£¬Äã±ØĞëµ÷ÓÃ video_device_release() À´ÊÍ·ÅÒÑ·ÖÅäµÄ
+video_device ½á¹¹Ìå£»Èç¹û video_device ÊÇÇ¶ÈëÔÚ×Ô¼º´´½¨µÄ½á¹¹ÌåÖĞ£¬
+ÄãÒ²±ØĞëÊÍ·ÅËü¡£vdev->release() »Øµ÷²»»áÔÚ×¢²áÊ§°ÜÖ®ºó±»µ÷ÓÃ£¬
+ÄãÒ²²»Ó¦ÊÔÍ¼ÔÚ×¢²áÊ§°Üºó×¢ÏúÉè±¸¡£
+
+
+video_device ×¢Ïú
+----------------
+
+µ±ÊÓÆµÉè±¸½ÚµãÒÑ±»ÒÆ³ı£¬²»ÂÛÊÇĞ¶ÔØÇı¶¯»¹ÊÇUSBÉè±¸¶Ï¿ª£¬Äã¶¼Ó¦×¢Ïú
+ËüÃÇ£º
+
+	video_unregister_device(vdev);
+
+Õâ¸ö²Ù×÷½«´Ó sysfs ÖĞÒÆ³ıÉè±¸½Úµã£¨µ¼ÖÂ udev ½«Æä´Ó /dev ÖĞÒÆ³ı£©¡£
+
+video_unregister_device() ·µ»ØÖ®ºó£¬¾ÍÎŞ·¨Íê³É´ò¿ª²Ù×÷¡£¾¡¹ÜÈç´Ë£¬
+USB Éè±¸µÄÇé¿öÔò²»Í¬£¬Ä³Ğ©Ó¦ÓÃ³ÌĞò¿ÉÄÜÒÀÈ»´ò¿ª×ÅÆäÖĞÒ»¸öÒÑ×¢ÏúÉè±¸
+½Úµã¡£ËùÒÔÔÚ×¢ÏúÖ®ºó£¬ËùÓĞÎÄ¼ş²Ù×÷£¨µ±È»³ıÁË release £©Ò²Ó¦·µ»Ø´íÎóÖµ¡£
+
+µ±×îºóÒ»¸öÊÓÆµÉè±¸½ÚµãµÄÓÃ»§ÍË³ö£¬Ôò vdev->release() »Øµ÷»á±»µ÷ÓÃ£¬
+²¢ÇÒÄã¿ÉÒÔ×ö×îºóµÄÇåÀí²Ù×÷¡£
+
+²»ÒªÍü¼ÇÇåÀíÓëÊÓÆµÉè±¸Ïà¹ØµÄÃ½ÌåÈë¿Ú£¨Èç¹û±»³õÊ¼»¯¹ı£©£º
+
+	media_entity_cleanup(&vdev->entity);
+
+Õâ¿ÉÒÔÔÚ release »Øµ÷ÖĞÍê³É¡£
+
+
+video_device ¸¨Öúº¯Êı
+---------------------
+
+Ò»Ğ©ÓĞÓÃµÄ¸¨Öúº¯ÊıÈçÏÂ£º
+
+- file/video_device Ë½ÓĞÊı¾İ
+
+Äã¿ÉÒÔÓÃÒÔÏÂº¯ÊıÔÚ video_device ½á¹¹ÌåÖĞÉèÖÃ/»ñÈ¡Çı¶¯Ë½ÓĞÊı¾İ£º
+
+void *video_get_drvdata(struct video_device *vdev);
+void video_set_drvdata(struct video_device *vdev, void *data);
+
+×¢Òâ£ºÔÚµ÷ÓÃ video_register_device() Ç°Ö´ĞĞ video_set_drvdata()
+ÊÇ°²È«µÄ¡£
+
+¶øÒÔÏÂº¯Êı£º
+
+struct video_device *video_devdata(struct file *file);
+
+·µ»Ø file ½á¹¹ÌåÖĞÓµÓĞµÄµÄ video_device Ö¸Õë¡£
+
+video_drvdata ¸¨Öúº¯Êı½áºÏÁË video_get_drvdata ºÍ video_devdata
+µÄ¹¦ÄÜ£º
+
+void *video_drvdata(struct file *file);
+
+Äã¿ÉÒÔÊ¹ÓÃÈçÏÂ´úÂë´Ó video_device ½á¹¹ÌåÖĞ»ñÈ¡ v4l2_device ½á¹¹Ìå
+Ö¸Õë£º
+
+struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
+
+- Éè±¸½ÚµãÃû
+
+video_device Éè±¸½ÚµãÔÚÄÚºËÖĞµÄÃû³Æ¿ÉÒÔÍ¨¹ıÒÔÏÂº¯Êı»ñµÃ
+
+const char *video_device_node_name(struct video_device *vdev);
+
+Õâ¸öÃû×Ö±»ÓÃ»§¿Õ¼ä¹¤¾ß£¨ÀıÈç udev£©×÷ÎªÌáÊ¾ĞÅÏ¢Ê¹ÓÃ¡£Ó¦¾¡¿ÉÄÜÊ¹ÓÃ
+´Ë¹¦ÄÜ£¬¶ø·Ç·ÃÎÊ video_device::num ºÍ video_device::minor Óò¡£
+
+
+ÊÓÆµ»º³å¸¨Öúº¯Êı
+---------------
+
+v4l2 ºËĞÄ API Ìá¹©ÁËÒ»¸ö´¦ÀíÊÓÆµ»º³åµÄ±ê×¼·½·¨(³ÆÎª¡°videobuf¡±)¡£
+ÕâĞ©·½·¨Ê¹Çı¶¯¿ÉÒÔÍ¨¹ıÍ³Ò»µÄ·½Ê½ÊµÏÖ read()¡¢mmap() ºÍ overlay()¡£
+Ä¿Ç°ÔÚÉè±¸ÉÏÖ§³ÖÊÓÆµ»º³åµÄ·½·¨ÓĞ·ÖÉ¢/¾Û¼¯ DMA(videobuf-dma-sg)¡¢
+ÏßĞÔ DMA(videobuf-dma-contig)ÒÔ¼°´ó¶àÓÃÓÚ USB Éè±¸µÄÓÃ vmalloc
+·ÖÅäµÄ»º³å(videobuf-vmalloc)¡£
+
+Çë²ÎÔÄ Documentation/video4linux/videobuf£¬ÒÔ»ñµÃ¸ü¶à¹ØÓÚ videobuf
+²ãµÄÊ¹ÓÃĞÅÏ¢¡£
+
+v4l2_fh ½á¹¹Ìå
+-------------
+
+v4l2_fh ½á¹¹ÌåÌá¹©Ò»¸ö±£´æÓÃÓÚ V4L2 ¿ò¼ÜµÄÎÄ¼ş¾ä±úÌØ¶¨Êı¾İµÄ¼òµ¥·½·¨¡£
+Èç¹û video_device µÄ flag ÉèÖÃÁË V4L2_FL_USE_FH_PRIO ±êÖ¾£¬ĞÂÇı¶¯
+±ØĞëÊ¹ÓÃ v4l2_fh ½á¹¹Ìå£¬ÒòÎªËüÒ²ÓÃÓÚÊµÏÖÓÅÏÈ¼¶´¦Àí£¨VIDIOC_G/S_PRIORITY£©¡£
+
+v4l2_fh µÄÓÃ»§£¨Î»ÓÚ V4l2 ¿ò¼ÜÖĞ£¬²¢·ÇÇı¶¯£©¿ÉÍ¨¹ı²âÊÔ
+video_device->flags ÖĞµÄ V4L2_FL_USES_V4L2_FH Î»µÃÖªÇı¶¯ÊÇ·ñÊ¹ÓÃ
+v4l2_fh ×÷ÎªËûµÄ file->private_data Ö¸Õë¡£Õâ¸öÎ»»áÔÚµ÷ÓÃ v4l2_fh_init()
+Ê±±»ÉèÖÃ¡£
+
+v4l2_fh ½á¹¹Ìå×÷ÎªÇı¶¯×ÔÉíÎÄ¼ş¾ä±ú½á¹¹ÌåµÄÒ»²¿·Ö±»·ÖÅä£¬ÇÒÇı¶¯ÔÚ
+Æä´ò¿ªº¯ÊıÖĞ½« file->private_data Ö¸ÏòËü¡£
+
+ÔÚĞí¶àÇé¿öÏÂ£¬v4l2_fh ½á¹¹Ìå»áÇ¶Èëµ½Ò»¸ö¸ü´óµÄ½á¹¹ÌåÖĞ¡£ÕâÖÓÇé¿öÏÂ£¬
+Ó¦¸ÃÔÚ open() ÖĞµ÷ÓÃ v4l2_fh_init+v4l2_fh_add£¬²¢ÔÚ release() ÖĞ
+µ÷ÓÃ v4l2_fh_del+v4l2_fh_exit¡£
+
+Çı¶¯¿ÉÒÔÍ¨¹ıÊ¹ÓÃ container_of ºêÌáÈ¡ËûÃÇ×Ô¼ºµÄÎÄ¼ş¾ä±ú½á¹¹Ìå¡£ÀıÈç£º
+
+struct my_fh {
+	int blah;
+	struct v4l2_fh fh;
+};
+
+...
+
+int my_open(struct file *file)
+{
+	struct my_fh *my_fh;
+	struct video_device *vfd;
+	int ret;
+
+	...
+
+	my_fh = kzalloc(sizeof(*my_fh), GFP_KERNEL);
+
+	...
+
+	v4l2_fh_init(&my_fh->fh, vfd);
+
+	...
+
+	file->private_data = &my_fh->fh;
+	v4l2_fh_add(&my_fh->fh);
+	return 0;
+}
+
+int my_release(struct file *file)
+{
+	struct v4l2_fh *fh = file->private_data;
+	struct my_fh *my_fh = container_of(fh, struct my_fh, fh);
+
+	...
+	v4l2_fh_del(&my_fh->fh);
+	v4l2_fh_exit(&my_fh->fh);
+	kfree(my_fh);
+	return 0;
+}
+
+ÒÔÏÂÊÇ v4l2_fh º¯ÊıÊ¹ÓÃµÄ¼ò½é£º
+
+void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
+
+  ³õÊ¼»¯ÎÄ¼ş¾ä±ú¡£Õâ*±ØĞë*ÔÚÇı¶¯µÄ v4l2_file_operations->open()
+  º¯ÊıÖĞÖ´ĞĞ¡£
+
+void v4l2_fh_add(struct v4l2_fh *fh)
+
+  Ìí¼ÓÒ»¸ö v4l2_fh µ½ video_device ÎÄ¼ş¾ä±úÁĞ±í¡£Ò»µ©ÎÄ¼ş¾ä±ú
+  ³õÊ¼»¯Íê³É¾Í±ØĞëµ÷ÓÃ¡£
+
+void v4l2_fh_del(struct v4l2_fh *fh)
+
+  ´Ó video_device() ÖĞ½â³ıÎÄ¼ş¾ä±úµÄ¹ØÁª¡£ÎÄ¼ş¾ä±úµÄÍË³öº¯ÊıÒ²
+  ½«±»µ÷ÓÃ¡£
+
+void v4l2_fh_exit(struct v4l2_fh *fh)
+
+  ÇåÀíÎÄ¼ş¾ä±ú¡£ÔÚÇåÀíÍê v4l2_fh ºó£¬Ïà¹ØÄÚ´æ»á±»ÊÍ·Å¡£
+
+
+Èç¹û v4l2_fh ²»ÊÇÇ¶ÈëÔÚÆäËû½á¹¹ÌåÖĞµÄ£¬Ôò¿ÉÒÔÓÃÕâĞ©¸¨Öúº¯Êı£º
+
+int v4l2_fh_open(struct file *filp)
+
+  ·ÖÅäÒ»¸ö v4l2_fh ½á¹¹Ìå¿Õ¼ä£¬³õÊ¼»¯²¢½«ÆäÌí¼Óµ½ file ½á¹¹ÌåÏà¹ØµÄ
+  video_device ½á¹¹ÌåÖĞ¡£
+
+int v4l2_fh_release(struct file *filp)
+
+  ´Ó file ½á¹¹ÌåÏà¹ØµÄ video_device ½á¹¹ÌåÖĞÉ¾³ı v4l2_fh £¬ÇåÀí
+  v4l2_fh ²¢ÊÍ·Å¿Õ¼ä¡£
+
+ÕâÁ½¸öº¯Êı¿ÉÒÔ²åÈëµ½ v4l2_file_operation µÄ open() ºÍ release()
+²Ù×÷ÖĞ¡£
+
+
+Ä³Ğ©Çı¶¯ĞèÒªÔÚµÚÒ»¸öÎÄ¼ş¾ä±ú´ò¿ªºÍ×îºóÒ»¸öÎÄ¼ş¾ä±ú¹Ø±ÕµÄÊ±ºò×öĞ©
+¹¤×÷¡£ËùÒÔ¼ÓÈëÁËÁ½¸ö¸¨Öúº¯ÊıÒÔ¼ì²é v4l2_fh ½á¹¹ÌåÊÇ·ñÊÇÏà¹ØÉè±¸
+½Úµã´ò¿ªµÄÎ¨Ò»ÎÄ¼ş¾ä±ú¡£
+
+int v4l2_fh_is_singular(struct v4l2_fh *fh)
+
+  Èç¹û´ËÎÄ¼ş¾ä±úÊÇÎ¨Ò»´ò¿ªµÄÎÄ¼ş¾ä±ú£¬Ôò·µ»Ø 1 £¬·ñÔò·µ»Ø 0 ¡£
+
+int v4l2_fh_is_singular_file(struct file *filp)
+
+  ¹¦ÄÜÏàÍ¬£¬µ«Í¨¹ı filp->private_data µ÷ÓÃ v4l2_fh_is_singular¡£
+
+
+V4L2 ÊÂ¼ş»úÖÆ
+-----------
+
+V4L2 ÊÂ¼ş»úÖÆÌá¹©ÁËÒ»¸öÍ¨ÓÃµÄ·½·¨½«ÊÂ¼ş´«µİµ½ÓÃ»§¿Õ¼ä¡£Çı¶¯±ØĞëÊ¹ÓÃ
+v4l2_fh ²ÅÄÜÖ§³Ö V4L2 ÊÂ¼ş»úÖÆ¡£
+
+
+ÊÂ¼şÍ¨¹ıÒ»¸öÀàĞÍºÍÑ¡Ôñ ID À´¶¨Òå¡£ID ¶ÔÓ¦Ò»¸ö V4L2 ¶ÔÏó£¬ÀıÈç
+Ò»¸ö¿ØÖÆ ID¡£Èç¹ûÎ´Ê¹ÓÃ£¬Ôò ID Îª 0¡£
+
+µ±ÓÃ»§¶©ÔÄÒ»¸öÊÂ¼ş£¬Çı¶¯»áÎª´Ë·ÖÅäÒ»Ğ© kevent ½á¹¹Ìå¡£ËùÒÔÃ¿¸ö
+ÊÂ¼ş×é£¨ÀàĞÍ¡¢ID£©¶¼»áÓĞ×Ô¼ºµÄÒ»Ì× kevent ½á¹¹Ìå¡£Õâ±£Ö¤ÁËÈç¹û
+Ò»¸öÇı¶¯¶ÌÊ±¼äÄÚ²úÉúÁËĞí¶àÍ¬ÀàÊÂ¼ş£¬²»»á¸²¸ÇÆäËûÀàĞÍµÄÊÂ¼ş¡£
+
+µ«Èç¹ûÄãÊÕµ½µÄÊÂ¼şÊıÁ¿´óÓÚÍ¬ÀàÊÂ¼ş kevent µÄ±£´æÊıÁ¿£¬Ôò×îÔçµÄ
+ÊÂ¼ş½«±»¶ªÆú£¬²¢¼ÓÈëĞÂÊÂ¼ş¡£
+
+´ËÍâ£¬v4l2_subscribed_event ½á¹¹ÌåÄÚ²¿ÓĞ¿É¹©Çı¶¯ÉèÖÃµÄ merge() ºÍ
+replace() »Øµ÷£¬ÕâĞ©»Øµ÷»áÔÚĞÂÊÂ¼ş²úÉúÇÒÃ»ÓĞ¶àÓà¿Õ¼äµÄÊ±ºò±»µ÷ÓÃ¡£
+replace() »Øµ÷ÈÃÄã¿ÉÒÔ½«ÔçÆÚÊÂ¼şµÄ¾»ºÉÌæ»»ÎªĞÂÊÂ¼şµÄ¾»ºÉ£¬½«ÔçÆÚ
+¾»ºÉµÄÏà¹ØÊı¾İºÏ²¢µ½Ìæ»»½øÀ´µÄĞÂ¾»ºÉÖĞ¡£µ±¸ÃÀàĞÍµÄÊÂ¼ş½ö·ÖÅäÁËÒ»¸ö
+kevent ½á¹¹ÌåÊ±£¬Ëü½«±»µ÷ÓÃ¡£merge() »Øµ÷ÈÃÄã¿ÉÒÔºÏ²¢×îÔçµÄÊÂ¼ş¾»ºÉ
+µ½ÔÚËüÖ®ºóµÄÄÇ¸öÊÂ¼ş¾»ºÉÖĞ¡£µ±¸ÃÀàĞÍµÄÊÂ¼ş·ÖÅäÁËÁ½¸ö»ò¸ü¶à kevent
+½á¹¹ÌåÊ±£¬Ëü½«±»µ÷ÓÃ¡£
+
+ÕâÖÖ·½·¨²»»áÓĞ×´Ì¬ĞÅÏ¢¶ªÊ§£¬Ö»»áµ¼ÖÂÖĞ¼ä²½ÖèĞÅÏ¢¶ªÊ§¡£
+
+
+¹ØÓÚ replace/merge »Øµ÷µÄÒ»¸ö²»´íµÄÀı×ÓÔÚ v4l2-event.c ÖĞ£ºÓÃÓÚ
+¿ØÖÆÊÂ¼şµÄ ctrls_replace() ºÍ ctrls_merge() »Øµ÷¡£
+
+×¢Òâ£ºÕâĞ©»Øµ÷¿ÉÒÔÔÚÖĞ¶ÏÉÏÏÂÎÄÖĞµ÷ÓÃ£¬ËùÒÔËüÃÇ±ØĞë¾¡¿ìÍê³É²¢ÍË³ö¡£
+
+ÓĞÓÃµÄº¯Êı£º
+
+void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
+
+  ½«ÊÂ¼ş¼ÓÈëÊÓÆµÉè±¸µÄ¶ÓÁĞ¡£Çı¶¯½ö¸ºÔğÌî³ä type ºÍ data Óò¡£
+  ÆäËûÓòÓÉ V4L2 Ìî³ä¡£
+
+int v4l2_event_subscribe(struct v4l2_fh *fh,
+			 struct v4l2_event_subscription *sub, unsigned elems,
+			 const struct v4l2_subscribed_event_ops *ops)
+
+  video_device->ioctl_ops->vidioc_subscribe_event ±ØĞë¼ì²âÇı¶¯ÄÜ
+  ²úÉúÌØ¶¨ id µÄÊÂ¼ş¡£È»ºóµ÷ÓÃ v4l2_event_subscribe() À´¶©ÔÄ¸ÃÊÂ¼ş¡£
+
+  elems ²ÎÊıÊÇ¸ÃÊÂ¼şµÄ¶ÓÁĞ´óĞ¡¡£ÈôÎª 0£¬V4L2 ¿ò¼Ü½«»á£¨¸ù¾İÊÂ¼şÀàĞÍ£©
+  Ìî³äÄ¬ÈÏÖµ¡£
+
+  ops ²ÎÊıÔÊĞíÇı¶¯Ö¸¶¨Ò»ÏµÁĞ»Øµ÷£º
+  * add:     µ±Ìí¼ÓÒ»¸öĞÂ¼àÌıÕßÊ±µ÷ÓÃ£¨ÖØ¸´¶©ÔÄÍ¬Ò»¸öÊÂ¼ş£¬´Ë»Øµ÷
+             ½ö±»Ö´ĞĞÒ»´Î£©¡£
+  * del:     µ±Ò»¸ö¼àÌıÕßÍ£Ö¹¼àÌıÊ±µ÷ÓÃ¡£
+  * replace: ÓÃ¡®ĞÂ¡¯ÊÂ¼şÌæ»»¡®ÔçÆÚ¡®ÊÂ¼ş¡£
+  * merge:   ½«¡®ÔçÆÚ¡®ÊÂ¼şºÏ²¢µ½¡®ĞÂ¡¯ÊÂ¼şÖĞ¡£
+  ÕâËÄ¸öµ÷ÓÃ¶¼ÊÇ¿ÉÑ¡µÄ£¬Èç¹û²»ÏëÖ¸¶¨ÈÎºÎ»Øµ÷£¬Ôò ops ¿ÉÎª NULL¡£
+
+int v4l2_event_unsubscribe(struct v4l2_fh *fh,
+			   struct v4l2_event_subscription *sub)
+
+  v4l2_ioctl_ops ½á¹¹ÌåÖĞµÄ vidioc_unsubscribe_event »Øµ÷º¯Êı¡£
+  Çı¶¯³ÌĞò¿ÉÒÔÖ±½ÓÊ¹ÓÃ v4l2_event_unsubscribe() ÊµÏÖÍË¶©ÊÂ¼ş¹ı³Ì¡£
+
+  ÌØÊâµÄ V4L2_EVENT_ALL ÀàĞÍ£¬¿ÉÓÃÓÚÍË¶©ËùÓĞÊÂ¼ş¡£Çı¶¯¿ÉÄÜÔÚÌØÊâ
+  Çé¿öÏÂĞèÒª×ö´Ë²Ù×÷¡£
+
+int v4l2_event_pending(struct v4l2_fh *fh)
+
+  ·µ»ØÎ´¾öÊÂ¼şµÄÊıÁ¿¡£ÓĞÖúÓÚÊµÏÖÂÖÑ¯£¨poll£©²Ù×÷¡£
+
+ÊÂ¼şÍ¨¹ı poll ÏµÍ³µ÷ÓÃ´«µİµ½ÓÃ»§¿Õ¼ä¡£Çı¶¯¿ÉÓÃ
+v4l2_fh->wait (wait_queue_head_t ÀàĞÍ)×÷Îª²ÎÊıµ÷ÓÃ poll_wait()¡£
+
+ÊÂ¼ş·ÖÎª±ê×¼ÊÂ¼şºÍË½ÓĞÊÂ¼ş¡£ĞÂµÄ±ê×¼ÊÂ¼ş±ØĞëÊ¹ÓÃ¿ÉÓÃµÄ×îĞ¡ÊÂ¼şÀàĞÍ
+±àºÅ¡£Çı¶¯±ØĞë´ÓËûÃÇ±¾ÀàĞÍµÄ±àºÅÆğÊ¼´¦·ÖÅäÊÂ¼ş¡£ÀàĞÍµÄ±àºÅÆğÊ¼Îª
+V4L2_EVENT_PRIVATE_START + n * 1000 £¬ÆäÖĞ n Îª¿ÉÓÃ×îĞ¡±àºÅ¡£Ã¿¸ö
+ÀàĞÍÖĞµÄµÚÒ»¸öÊÂ¼şÀàĞÍ±àºÅÊÇÎªÒÔºóµÄÊ¹ÓÃ±£ÁôµÄ£¬ËùÒÔµÚÒ»¸ö¿ÉÓÃÊÂ¼ş
+ÀàĞÍ±àºÅÊÇ¡®class base + 1¡¯¡£
+
+V4L2 ÊÂ¼ş»úÖÆµÄÊ¹ÓÃÊµÀı¿ÉÒÔÔÚ OMAP3 ISP µÄÇı¶¯
+(drivers/media/video/omap3isp)ÖĞÕÒµ½¡£
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
