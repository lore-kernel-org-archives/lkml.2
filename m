Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab2DXTpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:45:21 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:33506 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab2DXTpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:45:19 -0400
Date: Tue, 24 Apr 2012 21:45:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] kbuild: document KBUILD_LDS, KBUILD_VMLINUX_INIT and
	KBUILD_VMLINUX_MAIN
Message-ID: <20120424194518.GD2311@merkur.ravnborg.org>
References: <20120424194148.GA2216@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424194148.GA2216@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8e5298ec2fd86f90ce55503b02ccb67c30677611 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 23 Apr 2012 23:06:25 +0200
Subject: [PATCH 4/4] kbuild: document KBUILD_LDS, KBUILD_VMLINUX_INIT and
 KBUILD_VMLINUX_MAIN

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/kbuild.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 68e32bb..47038a2 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -214,3 +214,18 @@ KBUILD_BUILD_USER, KBUILD_BUILD_HOST
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

