Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab1D0VgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:36:14 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:33814 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753869Ab1D0VgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:36:10 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB88C1F.5070006@verizon.net>
Date: Wed, 27 Apr 2011 17:35:27 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH V2 resend 4/7] kbuild: rearrange clean-files
Content-Type: multipart/mixed;
	boundary="------------090900080006000803070306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090900080006000803070306
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

This patch rearranges clean-files.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 74d9512..eacdefb 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -202,8 +202,8 @@ ifeq ($(gconf-target),1)
 	hostprogs-y += gconf
 endif

-clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
-		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
+clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck .tmp_gtkcheck
+clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot

-- 
1.7.5.rc1




--------------090900080006000803070306
Content-Type: text/plain; name="kbuild-rearrange-clean-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kbuild-rearrange-clean-files.patch"

>From 78e493828805822d9a9273202c18cefc042e5de8 Mon Sep 17 00:00:00 2001
From: Peter Foley <pefoley2@verizon.net>
Date: Tue, 26 Apr 2011 18:06:55 -0400
Subject: [PATCH 4/7] kbuild: rearrange clean-files


Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 74d9512..eacdefb 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -202,8 +202,8 @@ ifeq ($(gconf-target),1)
 	hostprogs-y += gconf
 endif
 
-clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
-		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
+clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck .tmp_gtkcheck
+clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
 clean-files     += config.pot linux.pot
 
-- 
1.7.5.rc1



--------------090900080006000803070306--
