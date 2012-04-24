Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2DXTnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:43:03 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:65038 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab2DXTnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:43:00 -0400
Date: Tue, 24 Apr 2012 21:42:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/4] kbuild: drop unused KBUILD_VMLINUX_OBJS from top-level
	Makefile
Message-ID: <20120424194259.GA2311@merkur.ravnborg.org>
References: <20120424194148.GA2216@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424194148.GA2216@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a5fa412754aef31d590f805049fd8e25857b1802 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 23 Apr 2012 18:52:39 +0200
Subject: [PATCH 1/4] kbuild: drop unused KBUILD_VMLINUX_OBJS from top-level
 Makefile

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    1 -
 1 file changed, 1 deletion(-)

diff --git a/Makefile b/Makefile
index f6578f4..287aee4 100644
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
1.7.10

