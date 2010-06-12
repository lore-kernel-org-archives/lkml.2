Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0FLBHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:07:09 -0400
Received: from mail.perches.com ([173.55.12.10]:1084 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0FLBHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:07:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jim Paris <jim@jtan.com>
Subject: [PATCH 6/7] MAINTAINERS: Add patterns to PS3VRAM DRIVER
Date: Fri, 11 Jun 2010 18:06:55 -0700
Message-Id: <b7827ffb5b2d11dbd708bb41de850be6dd05513d.1276304638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jim Paris <jim@jtan.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a5310a8..4cf783b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4567,6 +4567,7 @@ PS3VRAM DRIVER
 M:	Jim Paris <jim@jtan.com>
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
+F:	drivers/block/ps3vram.c
 
 PTRACE SUPPORT
 M:	Roland McGrath <roland@redhat.com>
-- 
1.7.1.244.gbdc4

