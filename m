Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1GBBtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:49:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42485 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1GBBry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:47:54 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [RFC 2/7] kconfig/Makefile: ensure `conf' appears last in `hostprogs-y'
Date: Fri,  1 Jul 2011 21:47:34 -0400
Message-Id: <1309571259-15241-3-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309571259-15241-1-git-send-email-lacombar@gmail.com>
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com>
 <1309571259-15241-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 scripts/kconfig/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index ce46407..8abde17 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -173,7 +173,7 @@ qconf-cxxobjs	:= qconf.o
 qconf-objs	:= zconf.tab.o
 gconf-objs	:= gconf.o zconf.tab.o
 
-hostprogs-y := conf
+hostprogs-y :=
 
 ifeq ($(MAKECMDGOALS),nconfig)
 	hostprogs-y += nconf
@@ -203,6 +203,8 @@ ifeq ($(gconf-target),1)
 	hostprogs-y += gconf
 endif
 
+hostprogs-y += conf
+
 clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck
 clean-files	+= zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
 clean-files     += mconf qconf gconf nconf
-- 
1.7.3.4.574.g608b.dirty

