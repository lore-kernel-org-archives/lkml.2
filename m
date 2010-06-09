Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0FITkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:40:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2944 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0FITip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:38:45 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, James Chapman <jchapman@katalix.com>
Subject: [PATCH 06/12] MAINTAINERS: Update PPP OVER L2TP file patterns
Date: Wed,  9 Jun 2010 12:38:32 -0700
Message-Id: <9932567e949f3db5628dc1b57c6039a587836a62.1276112117.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276112117.git.joe@perches.com>
References: <cover.1276112117.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 21b4aaa14329db793832e865f15000c5c0192ac3
moved the file

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James Chapman <jchapman@katalix.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 70742db..977309a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4501,7 +4501,7 @@ F:	drivers/net/pppox.c
 PPP OVER L2TP
 M:	James Chapman <jchapman@katalix.com>
 S:	Maintained
-F:	drivers/net/pppol2tp.c
+F:	net/l2tp/l2tp_ppp.c
 F:	include/linux/if_pppol2tp.h
 
 PPS SUPPORT
-- 
1.7.1.244.gbdc4

