Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1F0Vo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:44:59 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:33332 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab1F0Voi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:44:38 -0400
Date: Mon, 27 Jun 2011 17:42:36 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] kbuild: silence generated makefile message
Message-id: <alpine.LNX.2.00.1106271619350.24034@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch silences the make -C /usr/src/git O=/usr/src/git/build/. 
message shown when using the generated makefile in KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/mkmakefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 5325423..f4642f2 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -40,7 +40,7 @@ MAKEFLAGS += --no-print-directory
 all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
 
 all:
-	\$(MAKE) \$(MAKEARGS) \$(all)
+	@\$(MAKE) \$(MAKEARGS) \$(all)
 
 Makefile:;
 
-- 
1.7.5.3

