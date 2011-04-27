Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab1D0Vgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:36:40 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:33915 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760058Ab1D0Vg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:36:28 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB88C32.20403@verizon.net>
Date: Wed, 27 Apr 2011 17:35:46 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 resend 6/7] kbuild: change update-po-config to reflect
 new layout of arch/um
Content-Type: multipart/mixed;
	boundary="------------070604090204060101010508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------070604090204060101010508
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch changes update-po-config to reflect the new layout of arch/um.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 4507336..0674e78 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,7 +84,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --directory=$(srctree) --directory=$(objtree)           \
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
+	$(Q)ln -fs Kconfig.x86 arch/um/Kconfig
 	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
 	    do                                           \
 		echo "  GEN $$i";                        \
@@ -93,7 +93,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f $(srctree)/arch/um/Kconfig.arch
+	$(Q)rm -f $(srctree)/arch/um/Kconfig
 	$(Q)rm -f $(obj)/config.pot

 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
-- 
1.7.5.rc1



--------------070604090204060101010508
Content-Type: text/plain;
	name="kbuild-change-update-po-config-to-reflect-new-layout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-change-update-po-config-to-reflect-new-layout.patch"

>From 9e6e3991ea395dd6033a389f550f828285e739ac Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 18:13:56 -0400
Subject: [PATCH 6/7] kbuild: change update-po-config to reflect new layout
 of arch/um


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 4507336..0674e78 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -84,7 +84,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --directory=$(srctree) --directory=$(objtree)           \
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-	$(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch
+	$(Q)ln -fs Kconfig.x86 arch/um/Kconfig
 	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
 	    do                                           \
 		echo "  GEN $$i";                        \
@@ -93,7 +93,7 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    done )
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f $(srctree)/arch/um/Kconfig.arch
+	$(Q)rm -f $(srctree)/arch/um/Kconfig
 	$(Q)rm -f $(obj)/config.pot
 
 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
-- 
1.7.5.rc1



--------------070604090204060101010508--
