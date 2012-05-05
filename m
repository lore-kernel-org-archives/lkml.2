Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2EEIUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:20:00 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:31451 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2EEISt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 4/8] kbuild: document KBUILD_LDS, KBUILD_VMLINUX_{INIT,MAIN} and LDFLAGS_vmlinux
Date: Sat,  5 May 2012 10:18:42 +0200
Message-Id: <1336205926-13946-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly exported variables - used by link-vmlinux.sh

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kbuild.txt |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 68e32bb..1053642 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -50,6 +50,10 @@ LDFLAGS_MODULE
 --------------------------------------------------
 Additional options used for $(LD) when linking modules.
 
+LDFLAGS_vmlinux
+--------------------------------------------------
+Additional options passed to final link of vmlinux.
+
 KBUILD_VERBOSE
 --------------------------------------------------
 Set the kbuild verbosity. Can be assigned same values as "V=...".
@@ -214,3 +218,18 @@ KBUILD_BUILD_USER, KBUILD_BUILD_HOST
 These two variables allow to override the user@host string displayed during
 boot and in /proc/version. The default value is the output of the commands
 whoami and host, respectively.
+
+KBUILD_LDS
+--------------------------------------------------
+The linker script with full path. Assigned by the top-level Makefile.
+
+KBUILD_VMLINUX_INIT
+--------------------------------------------------
+All objects files for the init (first) part of vmlinux.
+Files specified with KBUILD_VMLINUX_INIT are linked first.
+
+KBUILD_VMLINUX_MAIN
+--------------------------------------------------
+All objects files for the main part of vmlinux.
+KBUILD_VMLINUX_INIT and KBUILD_VMLINUX_MAIN together specify
+all the object files used to link vmlinux.
-- 
1.6.0.6

