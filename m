Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1FFHkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:40:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54056 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab1FFHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:40:39 -0400
Subject: [PATCH] arm/mxs: Fix build failure on ocotp.c
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 06 Jun 2011 01:40:38 -0600
Message-ID: <20110606074024.23861.55150.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-mxs/ocotp.c needs to include asm/processor.h to get the
definition of cpu_relax().

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-mxs/ocotp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mxs/ocotp.c b/arch/arm/mach-mxs/ocotp.c
index 65157a3..c7a4d34 100644
--- a/arch/arm/mach-mxs/ocotp.c
+++ b/arch/arm/mach-mxs/ocotp.c
@@ -16,6 +16,8 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 
+#include <asm/processor.h>
+
 #include <mach/mxs.h>
 
 #define OCOTP_WORD_OFFSET		0x20

