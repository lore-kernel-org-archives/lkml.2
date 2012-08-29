Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2H2Eyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:54:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38320 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2H2Eyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:54:43 -0400
MIME-Version: 1.0
Date: Wed, 29 Aug 2012 12:54:41 +0800
Message-ID: <CA+HMz3hAh9x4Co8MsZ5YfnGsd3=wSxioPjmnE1oDuJr2usjqRw@mail.gmail.com>
Subject: [PATCH]Documentation: Chinese translation of Documentation/filesystems/sysfs.txt
From: Ninja Tekkaman <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Patrick Mochel <mochel@osdl.org>, Mike Murphy <mamurph@cs.clemson.edu>,
        kernel@vger.linux-kernel.cn
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7T4sohW020387

This is a Chinese translated version of Documentation/filesystems/sysfs.txt

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
---
 Documentation/zh_CN/filesystems/sysfs.txt |  372 +++++++++++++++++++++++++++++
 1 file changed, 372 insertions(+)
 create mode 100644 Documentation/zh_CN/filesystems/sysfs.txt

diff --git a/Documentation/zh_CN/filesystems/sysfs.txt
b/Documentation/zh_CN/filesystems/sysfs.txt
new file mode 100644
index 0000000..b4bee3a
--- /dev/null
+++ b/Documentation/zh_CN/filesystems/sysfs.txt
@@ -0,0 +1,372 @@
+Chinese translated version of Documentation/filesystems/sysfs.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Maintainer: Patrick Mochel	<mochel@osdl.org>
+		Mike Murphy <mamurph@cs.clemson.edu>
+Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+---------------------------------------------------------------------
+Documentation/filesystems/sysfs.txt µÄÖĞÎÄ·­Òë
+
+Èç¹ûÏëÆÀÂÛ»ò¸üĞÂ±¾ÎÄµÄÄÚÈİ£¬ÇëÖ±½ÓÁªÏµÔ­ÎÄµµµÄÎ¬»¤Õß¡£Èç¹ûÄãÊ¹ÓÃÓ¢ÎÄ
+½»Á÷ÓĞÀ§ÄÑµÄ»°£¬Ò²¿ÉÒÔÏòÖĞÎÄ°æÎ¬»¤ÕßÇóÖú¡£Èç¹û±¾·­Òë¸üĞÂ²»¼°Ê±»òÕß·­
+Òë´æÔÚÎÊÌâ£¬ÇëÁªÏµÖĞÎÄ°æÎ¬»¤Õß¡£
+Ó¢ÎÄ°æÎ¬»¤Õß£º Patrick Mochel	<mochel@osdl.org>
+		Mike Murphy <mamurph@cs.clemson.edu>
+ÖĞÎÄ°æÎ¬»¤Õß£º ¸µì¿ Fu Wei <tekkamanninja@gmail.com>
+ÖĞÎÄ°æ·­ÒëÕß£º ¸µì¿ Fu Wei <tekkamanninja@gmail.com>
+ÖĞÎÄ°æĞ£ÒëÕß£º ¸µì¿ Fu Wei <tekkamanninja@gmail.com>
+
+
+ÒÔÏÂÎªÕıÎÄ
+---------------------------------------------------------------------
+sysfs - ÓÃÓÚµ¼³öÄÚºË¶ÔÏó(kobject)µÄÎÄ¼şÏµÍ³
+
+Patrick Mochel	<mochel@osdl.org>
+Mike Murphy <mamurph@cs.clemson.edu>
+
+ĞŞ¶©:    16 August 2011
+Ô­Ê¼°æ±¾:   10 January 2003
+
+
+sysfs ¼ò½é:
+~~~~~~~~~~
+
+sysfs ÊÇÒ»¸ö×î³õ»ùÓÚ ramfs ÇÒÎ»ÓÚÄÚ´æµÄÎÄ¼şÏµÍ³¡£ËüÌá¹©µ¼³öÄÚºË
+Êı¾İ½á¹¹¼°ÆäÊôĞÔ£¬ÒÔ¼°ËüÃÇÖ®¼äµÄ¹ØÁªµ½ÓÃ»§¿Õ¼äµÄ·½·¨¡£
+
+sysfs Ê¼ÖÕÓë kobject µÄµ×²ã½á¹¹½ôÃÜÏà¹Ø¡£ÇëÔÄ¶Á
+Documentation/kobject.txt ÎÄµµÒÔ»ñµÃ¸ü¶à¹ØÓÚ kobject ½Ó¿ÚµÄ
+ĞÅÏ¢¡£
+
+
+Ê¹ÓÃ sysfs
+~~~~~~~~~~~
+
+Ö»ÒªÄÚºËÅäÖÃÖĞ¶¨ÒåÁË CONFIG_SYSFS £¬sysfs ×ÜÊÇ±»±àÒë½øÄÚºË¡£Äã¿É
+Í¨¹ıÒÔÏÂÃüÁî¹ÒÔØËü:
+
+    mount -t sysfs sysfs /sys
+
+
+´´½¨Ä¿Â¼
+~~~~~~~~
+
+ÈÎºÎ kobject ÔÚÏµÍ³ÖĞ×¢²á£¬¾Í»áÓĞÒ»¸öÄ¿Â¼ÔÚ sysfs ÖĞ±»´´½¨¡£Õâ¸ö
+Ä¿Â¼ÊÇ×÷Îª¸Ã kobject µÄ¸¸¶ÔÏóËùÔÚÄ¿Â¼µÄ×ÓÄ¿Â¼´´½¨µÄ£¬ÒÔ×¼È·µØ´«µİ
+ÄÚºËµÄ¶ÔÏó²ã´Îµ½ÓÃ»§¿Õ¼ä¡£sysfs ÖĞµÄ¶¥²ãÄ¿Â¼´ú±í×ÅÄÚºË¶ÔÏó²ã´ÎµÄ
+¹²Í¬×æÏÈ£»ÀıÈç£ºÄ³Ğ©¶ÔÏóÊôÓÚÄ³¸ö×ÓÏµÍ³¡£
+
+Sysfs ÔÚÓëÆäÄ¿Â¼¹ØÁªµÄ sysfs_dirent ¶ÔÏóÖĞÄÚ²¿±£´æÒ»¸öÖ¸ÏòÊµÏÖ
+Ä¿Â¼µÄ kobject µÄÖ¸Õë¡£ÒÔÇ°£¬Õâ¸ö kobject Ö¸Õë±» sysfs Ö±½ÓÓÃÓÚ
+kobject ÎÄ¼ş´ò¿ªºÍ¹Ø±ÕµÄÒıÓÃ¼ÆÊı¡£¶øÏÖÔÚµÄ sysfs ÊµÏÖÖĞ£¬kobject
+ÒıÓÃ¼ÆÊıÖ»ÄÜÍ¨¹ı sysfs_schedule_callback() º¯ÊıÖ±½ÓĞŞ¸Ä¡£
+
+
+ÊôĞÔ
+~~~~
+
+kobject µÄÊôĞÔ¿ÉÔÚÎÄ¼şÏµÍ³ÖĞÒÔÆÕÍ¨ÎÄ¼şµÄĞÎÊ½µ¼³ö¡£Sysfs ÎªÊôĞÔ¶¨Òå
+ÁËÃæÏòÎÄ¼ş I/O ²Ù×÷µÄ·½·¨£¬ÒÔÌá¹©¶ÔÄÚºËÊôĞÔµÄ¶ÁĞ´¡£
+
+
+ÊôĞÔÓ¦Îª ASCII ÂëÎÄ±¾ÎÄ¼ş¡£ÒÔÒ»¸öÎÄ¼şÖ»´æ´¢Ò»¸öÊôĞÔÖµÎªÒË¡£µ«Ò»¸ö
+ÎÄ¼şÖ»°üº¬Ò»¸öÊôĞÔÖµ¿ÉÄÜÓ°ÏìĞ§ÂÊ£¬ËùÒÔÒ»¸ö°üº¬ÏàÍ¬Êı¾İÀàĞÍµÄÊôĞÔÖµ
+Êı×éÒ²±»¹ã·ºµØ½ÓÊÜ¡£
+
+»ìºÏÀàĞÍ¡¢±í´ï¶àĞĞÊı¾İÒÔ¼°Ò»Ğ©¹ÖÒìµÄÊı¾İ¸ñÊ½»áÔâµ½Ç¿ÁÒ·´¶Ô¡£ÕâÑù×öÊÇ
+ºÜ¶ªÁ³µÄ,¶øÇÒÆä´úÂë»áÔÚÎ´Í¨Öª×÷ÕßµÄÇé¿öÏÂ±»ÖØĞ´¡£
+
+
+Ò»¸ö¼òµ¥µÄÊôĞÔ½á¹¹¶¨ÒåÈçÏÂ:
+
+struct attribute {
+        char                    * name;
+        struct module		*owner;
+        umode_t                 mode;
+};
+
+
+int sysfs_create_file(struct kobject * kobj, const struct attribute * attr);
+void sysfs_remove_file(struct kobject * kobj, const struct attribute * attr);
+
+
+Ò»¸öµ¥¶ÀµÄÊôĞÔ½á¹¹²¢²»°üº¬¶ÁĞ´ÆäÊôĞÔÖµµÄ·½·¨¡£×ÓÏµÍ³×îºÃÎªÔöÉ¾ÌØ¶¨
+¶ÔÏóÀàĞÍµÄÊôĞÔ¶¨Òå×Ô¼ºµÄÊôĞÔ½á¹¹ÌåºÍ·â×°º¯Êı¡£
+
+ÀıÈç:Çı¶¯³ÌĞòÄ£ĞÍ¶¨ÒåµÄ device_attribute ½á¹¹ÌåÈçÏÂ:
+
+struct device_attribute {
+	struct attribute	attr;
+	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count);
+};
+
+int device_create_file(struct device *, const struct device_attribute *);
+void device_remove_file(struct device *, const struct device_attribute *);
+
+ÎªÁË¶¨ÒåÉè±¸ÊôĞÔ£¬Í¬Ê±¶¨ÒåÁËÒ»ÏÂ¸¨Öúºê:
+
+#define DEVICE_ATTR(_name, _mode, _show, _store) \
+struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
+
+ÀıÈç:ÉùÃ÷
+
+static DEVICE_ATTR(foo, S_IWUSR | S_IRUGO, show_foo, store_foo);
+
+µÈÍ¬ÓÚÈçÏÂ´úÂë£º
+
+static struct device_attribute dev_attr_foo = {
+       .attr	= {
+		.name = "foo",
+		.mode = S_IWUSR | S_IRUGO,
+		.show = show_foo,
+		.store = store_foo,
+	},
+};
+
+
+×ÓÏµÍ³ÌØÓĞµÄ»Øµ÷º¯Êı
+~~~~~~~~~~~~~~~~~~~
+
+µ±Ò»¸ö×ÓÏµÍ³¶¨ÒåÒ»¸öĞÂµÄÊôĞÔÀàĞÍÊ±£¬±ØĞëÊµÏÖÒ»ÏµÁĞµÄ sysfs ²Ù×÷£¬
+ÒÔ°ïÖú¶ÁĞ´µ÷ÓÃÊµÏÖÊôĞÔËùÓĞÕßµÄÏÔÊ¾ºÍ´¢´æ·½·¨¡£
+
+struct sysfs_ops {
+        ssize_t (*show)(struct kobject *, struct attribute *, char *);
+        ssize_t (*store)(struct kobject *, struct attribute *, const
char *, size_t);
+};
+
+[×ÓÏµÍ³Ó¦ÒÑ¾­¶¨ÒåÁËÒ»¸ö struct kobj_type ½á¹¹Ìå×÷ÎªÕâ¸öÀàĞÍµÄ
+ÃèÊö·û£¬²¢ÔÚ´Ë±£´æ sysfs_ops µÄÖ¸Õë¡£¸ü¶àµÄĞÅÏ¢²Î¼û kobject µÄ
+ÎÄµµ]
+
+sysfs »áÎªÕâ¸öÀàĞÍµ÷ÓÃÊÊµ±µÄ·½·¨¡£µ±Ò»¸öÎÄ¼ş±»¶ÁĞ´Ê±£¬Õâ¸ö·½·¨»á
+½«Ò»°ãµÄkobject ºÍ attribute ½á¹¹ÌåÖ¸Õë×ª»»ÎªÊÊµ±µÄÖ¸ÕëÀàĞÍºó
+µ÷ÓÃÏà¹ØÁªµÄº¯Êı¡£
+
+
+Ê¾Àı:
+
+#define to_dev(obj) container_of(obj, struct device, kobj)
+#define to_dev_attr(_attr) container_of(_attr, struct device_attribute, attr)
+
+static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
+                             char *buf)
+{
+        struct device_attribute *dev_attr = to_dev_attr(attr);
+        struct device *dev = to_dev(kobj);
+        ssize_t ret = -EIO;
+
+        if (dev_attr->show)
+                ret = dev_attr->show(dev, dev_attr, buf);
+        if (ret >= (ssize_t)PAGE_SIZE) {
+                print_symbol("dev_attr_show: %s returned bad count\n",
+                                (unsigned long)dev_attr->show);
+        }
+        return ret;
+}
+
+
+
+¶ÁĞ´ÊôĞÔÊı¾İ
+~~~~~~~~~~~~
+
+ÔÚÉùÃ÷ÊôĞÔÊ±£¬±ØĞëÖ¸¶¨ show() »ò store() ·½·¨£¬ÒÔÊµÏÖÊôĞÔµÄ
+¶Á»òĞ´¡£ÕâĞ©·½·¨µÄÀàĞÍÓ¦¸ÃºÍÒÔÏÂµÄÉè±¸ÊôĞÔ¶¨ÒåÒ»Ñù¼òµ¥¡£
+
+ssize_t (*show)(struct device *dev, struct device_attribute *attr, char *buf);
+ssize_t (*store)(struct device *dev, struct device_attribute *attr,
+                 const char *buf, size_t count);
+
+Ò²¾ÍÊÇËµ,ËûÃÇÓ¦Ö»ÒÔÒ»¸ö´¦Àí¶ÔÏó¡¢Ò»¸öÊôĞÔºÍÒ»¸ö»º³åÖ¸Õë×÷Îª²ÎÊı¡£
+
+sysfs »á·ÖÅäÒ»¸ö´óĞ¡Îª (PAGE_SIZE) µÄ»º³åÇø²¢´«µİ¸øÕâ¸ö·½·¨¡£
+Sysfs ½«»áÎªÃ¿´Î¶ÁĞ´²Ù×÷µ÷ÓÃÒ»´ÎÕâ¸ö·½·¨¡£ÕâÊ¹µÃÕâĞ©·½·¨ÔÚÖ´ĞĞÊ±
+»á³öÏÖÒÔÏÂµÄĞĞÎª:
+
+- ÔÚ¶Á·½Ãæ£¨read(2)£©£¬show() ·½·¨Ó¦¸ÃÌî³äÕû¸ö»º³åÇø¡£»ØÏëÊôĞÔ
+  Ó¦Ö»µ¼³öÁËÒ»¸öÊôĞÔÖµ»òÊÇÒ»¸öÍ¬ÀàĞÍÊôĞÔÖµµÄÊı×é£¬ËùÒÔÕâ¸ö´ú¼Û½«
+  ²»»á²»Ì«¸ß¡£
+
+  ÕâÊ¹µÃÓÃ»§¿Õ¼ä¿ÉÒÔ¾Ö²¿µØ¶ÁºÍÈÎÒâµÄÏòÇ°ËÑË÷Õû¸öÎÄ¼ş¡£Èç¹ûÓÃ»§¿Õ¼ä
+  ÏòºóËÑË÷µ½Áã»òÊ¹ÓÃ¡®0¡¯Æ«ÒÆÖ´ĞĞÒ»¸öpread(2)²Ù×÷£¬show()·½·¨½«
+  ÔÙ´Î±»µ÷ÓÃ£¬ÒÔÖØĞÂÌî³ä»º´æ¡£
+
+- ÔÚĞ´·½Ãæ£¨write(2)£©£¬sysfs Ï£ÍûÔÚµÚÒ»´ÎĞ´²Ù×÷Ê±µÃµ½Õû¸ö»º³åÇø¡£
+  Ö®ºó Sysfs ´«µİÕû¸ö»º³åÇø¸ø store() ·½·¨¡£
+
+  µ±ÒªĞ´ sysfs ÎÄ¼şÊ±£¬ÓÃ»§¿Õ¼ä½ø³ÌÓ¦Ê×ÏÈ¶ÁÈ¡Õû¸öÎÄ¼ş£¬ĞŞ¸ÃÏëÒª
+  ¸Ä±äµÄÖµ£¬È»ºó»ØĞ´Õû¸ö»º³åÇø¡£
+
+  ÔÚ¶ÁĞ´ÊôĞÔÖµÊ±£¬ÊôĞÔ·½·¨µÄÖ´ĞĞÓ¦²Ù×÷ÏàÍ¬µÄ»º³åÇø¡£
+
+×¢¼Ç:
+
+- Ğ´²Ù×÷µ¼ÖÂµÄ show() ·½·¨ÖØÔØ£¬»áºöÂÔµ±Ç°ÎÄ¼şÎ»ÖÃ¡£
+
+- »º³åÇøÓ¦×ÜÊÇ PAGE_SIZE ´óĞ¡¡£¶ÔÓÚi386£¬Õâ¸öÖµÎª4096¡£
+
+- show() ·½·¨Ó¦¸Ã·µ»ØĞ´Èë»º³åÇøµÄ×Ö½ÚÊı£¬Ò²¾ÍÊÇ snprintf()µÄ
+  ·µ»ØÖµ¡£
+
+- show() Ó¦Ê¼ÖÕÊ¹ÓÃ snprintf()¡£
+
+- store() Ó¦·µ»Ø»º³åÇøµÄÒÑÓÃ×Ö½ÚÊı¡£Èç¹ûÕû¸ö»º´æ¶¼ÒÑÌîÂú£¬Ö»Ğè·µ»Ø
+  count ²ÎÊı¡£
+
+- show() »ò store() ¿ÉÒÔ·µ»Ø´íÎóÖµ¡£µ±µÃµ½Ò»¸ö·Ç·¨Öµ£¬±ØĞë·µ»ØÒ»¸ö
+  ´íÎóÖµ¡£
+
+- Ò»¸ö´«µİ¸ø·½·¨µÄ¶ÔÏó½«»áÍ¨¹ı sysfs µ÷ÓÃ¶ÔÏóÄÚÇ¶µÄÒıÓÃ¼ÆÊı¹Ì¶¨ÔÚ
+  ÄÚ´æÖĞ¡£¾¡¹ÜÈç´Ë£¬¶ÔÏó´ú±íµÄÎïÀíÊµÌå(ÈçÉè±¸)¿ÉÄÜÒÑ²»´æÔÚ¡£ÈçÓĞ±ØÒª£¬
+  Ó¦¸ÃÊµÏÖÒ»¸ö¼ì²â»úÖÆ¡£
+
+Ò»¸ö¼òµ¥µÄ(Î´¾­ÊµÑéÖ¤ÊµµÄ)Éè±¸ÊôĞÔÊµÏÖÈçÏÂ£º
+
+static ssize_t show_name(struct device *dev, struct device_attribute *attr,
+                         char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%s\n", dev->name);
+}
+
+static ssize_t store_name(struct device *dev, struct device_attribute *attr,
+                          const char *buf, size_t count)
+{
+        snprintf(dev->name, sizeof(dev->name), "%.*s",
+                 (int)min(count, sizeof(dev->name) - 1), buf);
+	return count;
+}
+
+static DEVICE_ATTR(name, S_IRUGO, show_name, store_name);
+
+
+£¨×¢Òâ£ºÕæÕıµÄÊµÏÖ²»ÔÊĞíÓÃ»§¿Õ¼äÉèÖÃÉè±¸Ãû¡££©
+
+¶¥²ãÄ¿Â¼²¼¾Ö
+~~~~~~~~~~~~
+
+sysfs Ä¿Â¼µÄ°²ÅÅÏÔÊ¾ÁËÄÚºËÊı¾İ½á¹¹Ö®¼äµÄ¹ØÏµ¡£
+
+¶¥²ã sysfs Ä¿Â¼ÈçÏÂ:
+
+block/
+bus/
+class/
+dev/
+devices/
+firmware/
+net/
+fs/
+
+devices/ °üº¬ÁËÒ»¸öÉè±¸Ê÷µÄÎÄ¼şÏµÍ³±íÊ¾¡£ËûÖ±½ÓÓ³ÉäÁËÄÚ²¿µÄÄÚºË
+Éè±¸Ê÷£¬·´Ó³ÁËÉè±¸µÄ²ã´Î½á¹¹¡£
+
+bus/ °üº¬ÁËÄÚºËÖĞ¸÷ÖÖ×ÜÏßÀàĞÍµÄÆ½ÃæÄ¿Â¼²¼¾Ö¡£Ã¿¸ö×ÜÏßÄ¿Â¼°üº¬Á½¸ö
+×ÓÄ¿Â¼:
+
+	devices/
+	drivers/
+
+devices/ °üº¬ÁËÏµÍ³ÖĞ³öÏÖµÄÃ¿¸öÉè±¸µÄ·ûºÅÁ´½Ó£¬ËûÃÇÖ¸Ïò root/ ÏÂµÄ
+Éè±¸Ä¿Â¼¡£
+
+drivers/ °üº¬ÁËÃ¿¸öÒÑÎªÌØ¶¨×ÜÏßÉÏµÄÉè±¸¶ø¹ÒÔØµÄÇı¶¯³ÌĞòµÄÄ¿Â¼(ÕâÀï
+¼Ù¶¨Çı¶¯Ã»ÓĞ¿çÔ½¶à¸ö×ÜÏßÀàĞÍ)¡£
+
+fs/ °üº¬ÁËÒ»¸öÎªÎÄ¼şÏµÍ³ÉèÁ¢µÄÄ¿Â¼¡£ÏÖÔÚÃ¿¸öÏëÒªµ¼³öÊôĞÔµÄÎÄ¼şÏµÍ³±ØĞë
+ÔÚ fs/ ÏÂ´´½¨×Ô¼ºµÄ²ã´Î½á¹¹(²Î¼ûDocumentation/filesystems/fuse.txt)¡£
+
+dev/ °üº¬Á½¸ö×ÓÄ¿Â¼£º char/ ºÍ block/¡£ÔÚÕâÁ½¸ö×ÓÄ¿Â¼ÖĞ£¬ÓĞÒÔ
+<major>:<minor> ¸ñÊ½ÃüÃûµÄ·ûºÅÁ´½Ó¡£ÕâĞ©·ûºÅÁ´½ÓÖ¸Ïò sysfs Ä¿Â¼
+ÖĞÏàÓ¦µÄÉè±¸¡£/sys/dev Ìá¹©Ò»¸öÍ¨¹ıÒ»¸ö stat(2) ²Ù×÷½á¹û£¬²éÕÒ
+Éè±¸ sysfs ½Ó¿Ú¿ì½İµÄ·½·¨¡£
+
+¸ü¶àÓĞ¹Ø driver-model µÄÌØĞÔĞÅÏ¢¿ÉÒÔÔÚ Documentation/driver-model/
+ÖĞÕÒµ½¡£
+
+
+TODO: Íê³ÉÕâÒ»½Ú¡£
+
+
+µ±Ç°½Ó¿Ú
+~~~~~~~~
+
+ÒÔÏÂµÄ½Ó¿Ú²ãÆÕ±é´æÔÚÓÚµ±Ç°µÄsysfsÖĞ:
+
+- Éè±¸ (include/linux/device.h)
+----------------------------------
+½á¹¹Ìå:
+
+struct device_attribute {
+	struct attribute	attr;
+	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
+			char *buf);
+	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count);
+};
+
+ÉùÃ÷:
+
+DEVICE_ATTR(_name, _mode, _show, _store);
+
+Ôö/É¾ÊôĞÔ:
+
+int device_create_file(struct device *dev, const struct
device_attribute * attr);
+void device_remove_file(struct device *dev, const struct
device_attribute * attr);
+
+
+- ×ÜÏßÇı¶¯³ÌĞò (include/linux/device.h)
+--------------------------------------
+½á¹¹Ìå:
+
+struct bus_attribute {
+        struct attribute        attr;
+        ssize_t (*show)(struct bus_type *, char * buf);
+        ssize_t (*store)(struct bus_type *, const char * buf, size_t count);
+};
+
+ÉùÃ÷:
+
+BUS_ATTR(_name, _mode, _show, _store)
+
+Ôö/É¾ÊôĞÔ:
+
+int bus_create_file(struct bus_type *, struct bus_attribute *);
+void bus_remove_file(struct bus_type *, struct bus_attribute *);
+
+
+- Éè±¸Çı¶¯³ÌĞò (include/linux/device.h)
+-----------------------------------------
+
+½á¹¹Ìå:
+
+struct driver_attribute {
+        struct attribute        attr;
+        ssize_t (*show)(struct device_driver *, char * buf);
+        ssize_t (*store)(struct device_driver *, const char * buf,
+                         size_t count);
+};
+
+ÉùÃ÷:
+
+DRIVER_ATTR(_name, _mode, _show, _store)
+
+Ôö/É¾ÊôĞÔ£º
+
+int driver_create_file(struct device_driver *, const struct
driver_attribute *);
+void driver_remove_file(struct device_driver *, const struct
driver_attribute *);
+
+
+ÎÄµµ
+~~~~
+
+sysfs Ä¿Â¼½á¹¹ÒÔ¼°ÆäÖĞ°üº¬µÄÊôĞÔ¶¨ÒåÁËÒ»¸öÄÚºËÓëÓÃ»§¿Õ¼äÖ®¼äµÄ ABI¡£
+¶ÔÓÚÈÎºÎ ABI£¬Æä×ÔÉíµÄÎÈ¶¨ºÍÊÊµ±µÄÎÄµµÊÇ·Ç³£ÖØÒªµÄ¡£ËùÓĞĞÂµÄ sysfs
+ÊôĞÔ±ØĞëÔÚ Documentation/ABI ÖĞÓĞÎÄµµ¡£Ïê¼û Documentation/ABI/README¡£
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
