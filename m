Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2D1VAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:00:09 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:49778 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2D1VAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:00:07 -0400
Date: Sat, 28 Apr 2012 23:00:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/4] kbuild: document KBUILD_LDS,
	KBUILD_VMLINUX_{INIT,MAIN} and LDFLAGS_vmlinux
Message-ID: <20120428210005.GD7442@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120428205651.GA7426@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 27d836b236726aa5f472f3817df77e7076a2540d Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 28 Apr 2012 20:06:58 +0200
Subject: [PATCH 4/4] kbuild: document KBUILD_LDS, KBUILD_VMLINUX_{INIT,MAIN}
 and LDFLAGS_vmlinux

Newly exported variables - used by link-vmlinux.sh

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kbuild.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

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
1.7.10

