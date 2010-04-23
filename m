Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0DWKIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:08:30 -0400
Received: from monster.nessie.de ([84.200.20.120]:60121 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0DWKI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:08:29 -0400
X-Greylist: delayed 1781 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Apr 2010 06:08:29 EDT
From: Michael Roth <mroth@nessie.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       Michael Roth <mroth@nessie.de>
Subject: [PATCH] [ARM] .gitignore: Ignore piggy.lzo, lib1funcs.S and vmlinux
Date: Fri, 23 Apr 2010 11:38:18 +0200
Message-Id: <1272015498-10749-1-git-send-email-mroth@nessie.de>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e7db7b4270ed2a606b8c0b5f944a5f92ade0e84c added LZO compressed
kernels, lib1funcs.S is copied from the appropriate ARM sub-arch
and vmlinux is the obvious fruit of all efforts.

Signed-off-by: Michael Roth <mroth@nessie.de>
---
 arch/arm/boot/compressed/.gitignore |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index ab204db..6dac3d0 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -1,3 +1,6 @@
 font.c
+lib1funcs.S
 piggy.gz
+piggy.lzo
+vmlinux
 vmlinux.lds
-- 
1.6.4.4

