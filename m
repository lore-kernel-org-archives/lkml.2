Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0HSJ45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:56:57 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:45306 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0HSJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:56:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] MAINTAINERS: remove Bob Picco
Date: Thu, 19 Aug 2010 11:56:46 +0200
Message-Id: <1282211806-9613-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<bob.picco@hp.com>: Recipient address rejected: User unknown in virtual alias table (state 14).
Does anybody have a more recent contact to him?

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4ae0416..a409749 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2765,11 +2765,6 @@ S:	Maintained
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 
-HPET:	ACPI
-M:	Bob Picco <bob.picco@hp.com>
-S:	Maintained
-F:	drivers/char/hpet.c
-
 HPFS FILESYSTEM
 M:	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
 W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
-- 
1.7.2.1


