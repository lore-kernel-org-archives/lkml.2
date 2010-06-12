Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0FLBHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:07:12 -0400
Received: from mail.perches.com ([173.55.12.10]:1079 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0FLBHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:07:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 4/7] MAINTAINERS: Add patterns to OMAP USB
Date: Fri, 11 Jun 2010 18:06:53 -0700
Message-Id: <b16f9b76463cca3a68e95c139ba22b93d0f8df20.1276304638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f37ca69..468c26c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4166,6 +4166,8 @@ M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
+F:	drivers/usb/*/*omap*
+F:	arch/arm/*omap*/usb*
 
 OMFS FILESYSTEM
 M:	Bob Copeland <me@bobcopeland.com>
-- 
1.7.1.244.gbdc4

