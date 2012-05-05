Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2EEISv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:18:51 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:44833 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2EEISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:48 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/8] kbuild: drop unused KBUILD_VMLINUX_OBJS from top-level Makefile
Date: Sat,  5 May 2012 10:18:39 +0200
Message-Id: <1336205926-13946-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index a06ee9f..1af1b7a 100644
--- a/Makefile
+++ b/Makefile
@@ -758,7 +758,6 @@ vmlinux-init := $(head-y) $(init-y)
 vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
 vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
 vmlinux-lds  := arch/$(SRCARCH)/kernel/vmlinux.lds
-export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
-- 
1.6.0.6

