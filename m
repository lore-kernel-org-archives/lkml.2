Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1EVOus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:50:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:45092 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab1EVOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:50:40 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/7] um: remove SIGHUP handler
Date: Sun, 22 May 2011 16:48:31 +0200
Message-Id: <1306075716-20042-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1306075716-20042-1-git-send-email-richard@nod.at>
References: <1306075716-20042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UML kernel ignores SIGHUP anyway.
This handler is in vain.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index 39613ea..fb2a97a 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -142,7 +142,6 @@ int __init main(int argc, char **argv, char **envp)
 	 */
 	install_fatal_handler(SIGINT);
 	install_fatal_handler(SIGTERM);
-	install_fatal_handler(SIGHUP);
 
 	scan_elf_aux(envp);
 
-- 
1.7.4.2

