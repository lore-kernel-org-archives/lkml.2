Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0INEZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1978 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab0INEYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:11 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH next 02/16] arch/ia64: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:48 -0700
Message-Id: <8724a87b1091dce2527278a430ba150f0beb245f.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ia64/kernel/palinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index fdf6f9d..77597e5 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -434,7 +434,7 @@ register_info(char *page)
 	unsigned long phys_stacked;
 	pal_hints_u_t hints;
 	unsigned long iregs, dregs;
-	char *info_type[]={
+	static const char * const info_type[] = {
 		"Implemented AR(s)",
 		"AR(s) with read side-effects",
 		"Implemented CR(s)",
-- 
1.7.3.rc1

