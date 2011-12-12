Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1LLXEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:04:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41009 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1LLXEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:04:35 -0500
Date: Mon, 12 Dec 2011 15:04:29 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] unicore32: standardize /proc/iomem "Kernel code" name
Message-ID: <20111212230429.GA25851@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other ports use "Kernel code" to identify the Kernel text segment
in /proc/iomem. Change the unicore32 resources to do the same.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
v2: Fixed my copy/paste-o.
---
 arch/unicore32/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 471b6bc..2a64061 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -64,7 +64,7 @@ static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
  */
 static struct resource mem_res[] = {
 	{
-		.name = "Kernel text",
+		.name = "Kernel code",
 		.start = 0,
 		.end = 0,
 		.flags = IORESOURCE_MEM
-- 
1.7.5.4


-- 
Kees Cook                                            @outflux.net
