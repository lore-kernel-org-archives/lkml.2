Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2HZQGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:06:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51355 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2HZQGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:06:46 -0400
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 00:06:45 +0800
Message-ID: <CADu=CFriPHFUG8aM9h=dGsTzmRHAq1QKCu5XO9iY0ZL8-gBALg@mail.gmail.com>
Subject: [PATCH 1/1] Document:add Chinese translation of basic_profiling.txt
From: liang xie <xieliang007@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@zh-kernel.org, greg@kroah.com,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7QG6q3f010270

This is a Chinese translated version of Documentation/basic_profiling.txt

Signed-off-by: Liang Xie <xieliang007@gmail.com>
---
 Documentation/zh_CN/basic_profiling.txt |   71 +++++++
 1 files changed, 71 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/zh_CN/basic_profiling.txt

diff --git a/Documentation/zh_CN/basic_profiling.txt
b/Documentation/zh_CN/basic_profiling.txt
new file mode 100755
index 0000000..3105eaf
--- /dev/null
+++ b/Documentation/zh_CN/basic_profiling.txt
@@ -0,0 +1,71 @@
+Chinese translated version of Documentation/basic_profiling
+
+If you have any comment or update to the content, please post to LKML directly.
+However, if you have problem communicating in English you can also ask the
+Chinese maintainer for help.  Contact the Chinese maintainer, if this
+translation is outdated or there is problem with translation.
+
+Chinese maintainer: Liang Xie <xieliang@xiaomi.com>
+---------------------------------------------------------------------
+Documentation/basic_profilingµÄÖĞÎÄ·­Òë
+
+Èç¹ûÏëÆÀÂÛ»ò¸üĞÂ±¾ÎÄµÄÄÚÈİ£¬ÇëÖ±½Ó·¢ĞÅµ½LKML¡£Èç¹ûÄãÊ¹ÓÃÓ¢ÎÄ½»Á÷ÓĞÀ§ÄÑµÄ»°£¬Ò²¿É
+ÒÔÏòÖĞÎÄ°æÎ¬»¤ÕßÇóÖú¡£Èç¹û±¾·­Òë¸üĞÂ²»¼°Ê±»òÕß·­Òë´æÔÚÎÊÌâ£¬ÇëÁªÏµÖĞÎÄ°æÎ¬»¤Õß¡£
+
+ÖĞÎÄ°æÎ¬»¤Õß£º Ğ»Á¼ Liang Xie <xieliang007@gmail.com>
+ÖĞÎÄ°æ·­ÒëÕß£º Ğ»Á¼ Liang Xie <xieliang007@gmail.com>
+ÖĞÎÄ°æĞ£ÒëÕß£º
+ÒÔÏÂÎªÕıÎÄ
+---------------------------------------------------------------------
+
+ÏÂÃæÕâĞ©ËµÃ÷Ö¸Áî¶¼ÊÇ·Ç³£»ù´¡µÄ£¬Èç¹ûÄãÏë½øÒ»²½ÁË½âÇëÔÄ¶ÁÏà¹Ø×¨ÒµÎÄµµ£º£©
+Çë²»ÒªÔÙÔÚ±¾ÎÄµµÔö¼ÓĞÂµÄÄÚÈİ£¬µ«¿ÉÒÔĞŞ¸´ÎÄµµÖĞµÄ´íÎó£º£©(mbligh@aracnet.com)
+¸ĞĞ»John Levon£¬Dave HansenµÈÔÚ×«Ğ´Ê±µÄ°ïÖú
+
+<test> ÓÃÓÚ±íÊ¾Òª²âÁ¿µÄÄ¿±ê
+ÇëÏÈÈ·±£ÄúÒÑ¾­ÓĞÕıÈ·µÄSystem.map / vmlinuxÅäÖÃ£¡
+
+¶ÔÓÚlinuxÏµÍ³À´Ëµ£¬ÅäÖÃvmlinuz×îÈİÒ×µÄ·½·¨¿ÉÄÜ¾ÍÊÇÊ¹ÓÃ¡°make install¡±£¬È»ºóĞŞ¸Ä
+/sbin/installkernel½«vmlinux¿½±´µ½/bootÄ¿Â¼£¬¶øSystem.mapÍ¨³£ÊÇÄ¬ÈÏ°²×°ºÃµÄ
+
+Readprofile
+-----------
+2.6ÏµÁĞÄÚºËĞèÒª°æ±¾Ïà¶Ô½ÏĞÂµÄreadprofile£¬±ÈÈçutil-linux 2.12aÖĞ°üº¬µÄ£¬¿ÉÒÔ´Ó:
+
+http://www.kernel.org/pub/linux/utils/util-linux/ ÏÂÔØ
+
+´ó²¿·Ölinux·¢ĞĞ°æÒÑ¾­°üº¬ÁË.
+
+ÆôÓÃreadprofileĞèÒªÔÚkernelÆô¶¯ÃüÁîĞĞÔö¼Ó¡±profile=2¡°
+
+clear		readprofile -r
+		<test>
+dump output	readprofile -m /boot/System.map > captured_profile
+
+Oprofile
+--------
+
+´Óhttp://oprofile.sourceforge.net/»ñÈ¡Ô´´úÂë£¨Çë²Î¿¼ChangesÒÔ»ñÈ¡Æ¥ÅäµÄ°æ±¾£©
+ÔÚkernelÆô¶¯ÃüÁîĞĞÔö¼Ó¡°idle=poll¡±
+
+ÅäÖÃCONFIG_PROFILING=yºÍCONFIG_OPROFILE=yÈ»ºóÖØÆô½øÈëĞÂkernel
+
+./configure --with-kernel-support
+make install
+
+ÏëµÃµ½ºÃµÄ²âÁ¿½á¹û£¬ÇëÈ·±£ÆôÓÃÁË±¾µØAPICÌØĞÔ¡£Èç¹ûopreportÏÔÊ¾ÓĞ0Hz CPU£¬
+ËµÃ÷APICÌØĞÔÃ»ÓĞ¿ªÆô¡£ÁíÍâ×¢Òâidle=pollÑ¡Ïî¿ÉÄÜÓĞËğĞÔÄÜ¡£
+
+One time setup:
+		opcontrol --setup --vmlinux=/boot/vmlinux
+
+clear		opcontrol --reset
+start		opcontrol --start
+		<test>
+stop		opcontrol --stop
+dump output	opreport >  output_file
+
+Èç¹ûÖ»¿´kernelÏà¹ØµÄ±¨¸æ½á¹û£¬ÇëÔËĞĞÃüÁî opreport -l /boot/vmlinux > output_file
+
+Í¨¹ıresetÑ¡Ïî¿ÉÒÔÇåÀí¹ıÆÚÍ³¼ÆÊı¾İ£¬Ïàµ±ÓÚÖØÆôµÄĞ§¹û¡£
+
-- 
1.7.9.6 (Apple Git-31.1)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
