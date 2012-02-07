Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2BGAW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:22:57 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab2BGAWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:22:18 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        Artem.Bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/5] um: Wire CONFIG_GENERIC_IO up
Date: Tue,  7 Feb 2012 01:22:49 +0100
Message-Id: <1328574170-2286-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1328574170-2286-1-git-send-email-richard@nod.at>
References: <1328574170-2286-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML has no io memory but implements everything defined in
generic-asm/io.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.common |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index b37ae70..20a49ba 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -9,6 +9,7 @@ config UML
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select GENERIC_IO
 
 config MMU
 	bool
-- 
1.7.6

