Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab1IKDwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:52:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50133 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1IKDwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:52:10 -0400
MIME-Version: 1.0
Date: Sun, 11 Sep 2011 11:52:08 +0800
Message-ID: <CAD+1EGNqz_-KgfF-2AGiX6g+bRGO09ux_VQpjxw8beAusYBgmw@mail.gmail.com>
Subject: [PATCH]Remove the messy code file Documentation/zh_CN/SubmitChecklist
From: harryxiyou <harryxiyou@gmail.com>
To: Tranlations maintainer for linux kernel <greg@kroah.com>,
        kernel man <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8B3qKhw005277

Hi greg,
This patch can remove the messy code file Documentation/zh_CN/SubmitChecklist.
I am now proofreading it again. When it is ok for us, i will give you
a patch. So we should
first remove this messy one.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 Documentation/zh_CN/SubmitChecklist |  109 -----------------------------------
 1 files changed, 0 insertions(+), 109 deletions(-)
 delete mode 100644 Documentation/zh_CN/SubmitChecklist

diff --git a/Documentation/zh_CN/SubmitChecklist
b/Documentation/zh_CN/SubmitChecklist
deleted file mode 100644
index 4c741d6..0000000
--- a/Documentation/zh_CN/SubmitChecklist
+++ /dev/null
@@ -1,109 +0,0 @@
-Chinese translated version of Documentation/SubmitChecklist
-
-If you have any comment or update to the content, please contact the
-original document maintainer directly.  However, if you have a problem
-communicating in English you can also ask the Chinese maintainer for
-help.  Contact the Chinese maintainer if this translation is outdated
-or if there is a problem with the translation.
-
-Chinese maintainer: Harry Wei <harryxiyou@gmail.com>
----------------------------------------------------------------------
-Documentation/SubmitChecklist µÄÖÐÎÄ·­Òë
-
-Èç¹ûÏëÆÀÂÛ»òžüÐÂ±ŸÎÄµÄÄÚÈÝ£¬ÇëÖ±œÓÁªÏµÔ­ÎÄµµµÄÎ¬»€Õß¡£Èç¹ûÄãÊ¹ÓÃÓ¢ÎÄ
-œ»Á÷ÓÐÀ§ÄÑµÄ»°£¬Ò²¿ÉÒÔÏòÖÐÎÄ°æÎ¬»€ÕßÇóÖú¡£Èç¹û±Ÿ·­ÒëžüÐÂ²»Œ°Ê±»òÕß·­
-ÒëŽæÔÚÎÊÌâ£¬ÇëÁªÏµÖÐÎÄ°æÎ¬»€Õß¡£
-
-ÖÐÎÄ°æÎ¬»€Õß£º ŒÖÍþÍþ Harry Wei <harryxiyou@gmail.com>
-ÖÐÎÄ°æ·­ÒëÕß£º ŒÖÍþÍþ Harry Wei <harryxiyou@gmail.com>
-ÖÐÎÄ°æÐ£ÒëÕß£º ŒÖÍþÍþ Harry Wei <harryxiyou@gmail.com>
-
-
-ÒÔÏÂÎªÕýÎÄ
----------------------------------------------------------------------
-LinuxÄÚºËÌáœ»Çåµ¥
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-ÕâÀïÓÐÒ»Ð©ÄÚºË¿ª·¢ÕßÓŠžÃ×öµÄ»ù±ŸÊÂÇé£¬Èç¹ûËûÃÇÏë¿Žµœ×ÔŒºµÄÄÚºË²¹¶¡Ìáœ»
-±»œÓÊÜµÄžü¿ì¡£
-
-ÕâÐ©¶ŒÊÇ³¬³öDocumentation/SubmittingPatchesÎÄµµÀïËùÌá¹©µÄÒÔŒ°ÆäËû
-¹ØÓÚÌáœ»LinuxÄÚºË²¹¶¡µÄËµÃ÷¡£
-
-1£ºÈç¹ûÄãÊ¹ÓÃÁËÒ»žö¹ŠÄÜÄÇÃŽŸÍ#include¶šÒå/ÉùÃ÷ÄÇžö¹ŠÄÜµÄÄÇžöÎÄŒþ¡£
-   ²»ÒªÒÀ¿¿ÆäËûŒäœÓÒýÈë¶šÒå/ÉùÃ÷ÄÇžö¹ŠÄÜµÄÍ·ÎÄŒþ¡£
-
-2£º¹¹œšŒòœàÊÊÓÃ»òÕßžüžÄCONFIGÑ¡Ïî =y£¬=m£¬»òÕß=n¡£
-   ²»ÒªÓÐ±àÒëŸ¯žæ/ŽíÎó£¬ ²»ÒªÓÐÁŽœÓŸ¯žæ/ŽíÎó¡£
-
-2b£ºÍš¹ý allnoconfig, allmodconfig
-
-2c£ºµ±Ê¹ÓÃ 0=builddir ³É¹ŠµØ¹¹œš
-
-3£ºÍš¹ýÊ¹ÓÃ±ŸµØœ»²æ±àÒë¹€Ÿß»òÕßÆäËûÒ»Ð©¹¹œš²úËù£¬ÔÚ¶àCPU¿òŒÜÉÏ¹¹œš¡£
-
-4£ºppc64 ÊÇÒ»žöºÜºÃµÄŒì²éœ»²æ±àÒëµÄ¿òŒÜ£¬ÒòÎªËüÍùÍù°Ñ¡®unsigned long¡¯
-   µ±64Î»ÖµÀŽÊ¹ÓÃ¡£
-
-5£º°ŽÕÕDocumentation/CodingStyleÎÄŒþÀïµÄÏêÏžÃèÊö£¬Œì²éÄã²¹¶¡µÄÕûÌå·çžñ¡£
-   Ê¹ÓÃ²¹¶¡·çžñŒì²éËöËéµÄÎ¥¹æ(scripts/checkpatch.pl)£¬ÉóºËÔ±ÓÅÏÈÌáœ»¡£
-   ÄãÓŠžÃµ÷ÕûÒÅÁôÔÚÄã²¹¶¡ÖÐµÄËùÓÐÎ¥¹æ¡£
-
-6£ºÈÎºÎžüÐÂ»òÕßžÄ¶¯CONFIGÑ¡Ïî¶Œ²»ÄÜŽòÂÒÅäÖÃ²Ëµ¥¡£
-
-7£ºËùÓÐµÄKconfigÑ¡ÏîžüÐÂ¶ŒÒªÓÐËµÃ÷ÎÄ×Ö¡£
-
-8£ºÒÑŸ­ÈÏÕæµØ×ÜœáÁËÏà¹ØµÄKconfig×éºÏ¡£ÕâÊÇºÜÄÑÍš¹ý²âÊÔ×öºÃµÄ--ÄÔÁŠÔÚÕâÀïÏÂœµ¡£
-
-9£ºŒì²éŸßÓÐŒòœàÐÔ¡£
-
-10£ºÊ¹ÓÃ'make checkstack'ºÍ'make namespacecheck'Œì²é£¬È»ºóÐÞžÄËùÕÒµœµÄÎÊÌâ¡£
-    ×¢Òâ£º¶ÑÕ»Œì²é²»»áÃ÷È·µØ³öÏÖÎÊÌâ£¬µ«ÊÇÈÎºÎµÄÒ»žöº¯ÊýÔÚ¶ÑÕ»ÉÏÊ¹ÓÃ¶àÓÚ512×ÖœÚ
-    ¶ŒÒª×Œ±žÐÞžÄ¡£
-
-11£º°üº¬kernel-docµœÈ«ŸÖÄÚºËAPIsÎÄŒþ¡££š²»ÒªÇóŸ²Ì¬µÄº¯Êý£¬µ«ÊÇ°üº¬Ò²ÎÞËùÎœ¡££©
-    Ê¹ÓÃ'make htmldocs'»òÕß'make mandocs'ÀŽŒì²ékernel-doc£¬È»ºóÐÞžÄÈÎºÎ
-    ·¢ÏÖµÄÎÊÌâ¡£
-
-12£ºÒÑŸ­Íš¹ýCONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
-    CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP²âÊÔ£¬²¢ÇÒÍ¬Ê±¶Œ
-    Ê¹ÄÜ¡£
-
-13£ºÒÑŸ­¶Œ¹¹œš²¢ÇÒÊ¹ÓÃ»òÕß²»Ê¹ÓÃ CONFIG_SMP ºÍ CONFIG_PREEMPT²âÊÔÖŽÐÐÊ±Œä¡£
-
-14£ºÈç¹û²¹¶¡Ó°ÏìIO/Disk£¬µÈµÈ£ºÒÑŸ­Íš¹ýÊ¹ÓÃ»òÕß²»Ê¹ÓÃ CONFIG_LBDAF ²âÊÔ¡£
-
-15£ºËùÓÐµÄcodepathsÒÑŸ­ÐÐÊ¹ËùÓÐlockdepÆôÓÃ¹ŠÄÜ¡£
-
-16£ºËùÓÐµÄ/procŒÇÂŒžüÐÂ¶ŒÒª×÷³ÉÎÄŒþ·ÅÔÚDocumentation/Ä¿ÂŒÏÂ¡£
-
-17£ºËùÓÐµÄÄÚºËÆô¶¯²ÎÊýžüÐÂ¶Œ±»ŒÇÂŒµœDocumentation/kernel-parameters.txtÎÄŒþÖÐ¡£
-
-18£ºËùÓÐµÄÄ£¿é²ÎÊýžüÐÂ¶ŒÓÃMODULE_PARM_DESC()ŒÇÂŒ¡£
-
-19£ºËùÓÐµÄÓÃ»§¿ÕŒäœÓ¿ÚžüÐÂ¶Œ±»ŒÇÂŒµœDocumentation/ABI/¡£²é¿ŽDocumentation/ABI/README
-    ¿ÉÒÔ»ñµÃžü¶àµÄÐÅÏ¢¡£žÄ±äÓÃ»§¿ÕŒäœÓ¿ÚµÄ²¹¶¡ÓŠžÃ±»ÓÊŒþ³­ËÍžølinux-api@vger.kernel.org¡£
-
-20£ºŒì²éËüÊÇ²»ÊÇ¶ŒÍš¹ý`make headers_check'¡£
-
-21£ºÒÑŸ­Íš¹ýÖÁÉÙÒýÈëslabºÍpage-allocationÊ§°ÜŒì²é¡£²é¿ŽDocumentation/fault-injection/¡£
-
-22£ºÐÂŒÓÈëµÄÔŽÂëÒÑŸ­Íš¹ý`gcc -W'£šÊ¹ÓÃ"make
EXTRA_CFLAGS=-W"£©±àÒë¡£ÕâÑùœ«²úÉúºÜ¶à·³ÄÕ£¬
-    µ«ÊÇ¶ÔÓÚÑ°ÕÒÂ©¶ŽºÜÓÐÒæŽŠ£¬ÀýÈç:"warning: comparison between
signed and unsigned"¡£
-
-23£ºµ±Ëü±»ºÏ²¢µœ-mm²¹¶¡Œ¯ºóÔÙ²âÊÔ£¬ÓÃÀŽÈ·¶šËüÊÇ·ñ»¹ºÍ²¹¶¡¶ÓÁÐÖÐµÄÆäËû²¹¶¡Ò»Æð¹€×÷ÒÔŒ°ÔÚVM£¬VFS
-    ºÍÆäËû×ÓÏµÍ³ÖÐž÷žö±ä»¯¡£
-
-24£ºËùÓÐµÄÄÚŽæÆÁÕÏ{e.g., barrier(), rmb(),
wmb()}ÐèÒªÔÚÔŽŽúÂëÖÐµÄÒ»žö×¢ÊÍÀŽœâÊÍËûÃÇ¶ŒÊÇžÉÊ²ÃŽµÄ
-    ÒÔŒ°Ô­Òò¡£
-
-25£ºÈç¹ûÓÐÈÎºÎÊäÈëÊä³ö¿ØÖÆµÄ²¹¶¡±»ÌíŒÓ£¬Ò²ÒªžüÐÂDocumentation/ioctl/ioctl-number.txt¡£
-
-26£ºÈç¹ûÄãµÄžüžÄŽúÂëÒÀ¿¿»òÕßÊ¹ÓÃÈÎºÎµÄÄÚºËAPIs»òÕßÓëÏÂÃæµÄkconfig·ûºÅÓÐ¹ØÏµµÄ¹ŠÄÜ£¬ÄãŸÍÒª
-    Ê¹ÓÃÏà¹ØµÄkconfig·ûºÅ¹Ø±Õ£¬ and/or
=m£šÈç¹ûÑ¡ÏîÌá¹©£©[ÔÚÍ¬Ò»Ê±Œä²»ÊÇËùÓÃµÄ¶ŒÆôÓÃ£¬œöœöž÷žö»òÕß×ÔÓÉ
-    ×éºÏËûÃÇ]£º
-
-    CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
-    CONFIG_BLOCK, CONFIG_PM, CONFIG_HOTPLUG, CONFIG_MAGIC_SYSRQ,
-    CONFIG_NET, CONFIG_INET=n (ºóÒ»žöÊ¹ÓÃ CONFIG_NET=y)
-- 
1.7.0.4
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
