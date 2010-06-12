Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0FLBHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:07:13 -0400
Received: from mail.perches.com ([173.55.12.10]:1079 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab0FLBHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:07:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Vitaly Bordug <vitb@kernel.crashing.org>,
       Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH 3/7] MAINTAINERS: Add patterns to POWERPC EMBEDDED PPC8XX
Date: Fri, 11 Jun 2010 18:06:52 -0700
Message-Id: <23569e8b6c7dbf2f0085e863af40b7e2aaf7830c.1276304638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Marcelo Tosatti <marcelo@kvack.org>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f322c72..f37ca69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3495,6 +3495,7 @@ M:	Marcelo Tosatti <marcelo@kvack.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/8xx/
 
 LINUX FOR POWERPC EMBEDDED PPC83XX AND PPC85XX
 M:	Kumar Gala <galak@kernel.crashing.org>
-- 
1.7.1.244.gbdc4

