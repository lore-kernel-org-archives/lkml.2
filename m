Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1CZTtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:49:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:52085 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1CZTtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:49:21 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, torvalds@linux-foundation.org, mingo@elte.hu,
        jdike@addtoit.com, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Add myself as co-maintainer
Date: Sat, 26 Mar 2011 20:48:57 +0100
Message-Id: <1301168937-21074-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKML-Reference: <alpine.LFD.2.00.1103262010590.31464@localhost6.localdomain6>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fb9017..42471b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6633,6 +6633,7 @@ F:	drivers/media/video/zr364xx.c
 
 USER-MODE LINUX (UML)
 M:	Jeff Dike <jdike@addtoit.com>
+M:	Richard Weinberger <richard@nod.at>
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
-- 
1.6.6.1

