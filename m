Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab2JWUmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:42:25 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46379 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab2JWUF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:29 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Subject: [PATCH 193/193] final removal of CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:26 -0700
Message-Id: <1351022666-6960-194-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_EXPERIMENTAL, now that every mention of it has been removed
from the tree.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 init/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 4b65c1c..3b61f42 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -32,10 +32,6 @@ config BUILDTIME_EXTABLE_SORT
 
 menu "General setup"
 
-config EXPERIMENTAL
-	bool
-	default y
-
 config BROKEN
 	bool
 
-- 
1.7.9.5

