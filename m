Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HRS7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:59:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49880 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1HRS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:59:19 -0400
Date: Thu, 18 Aug 2011 19:59:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 02/91] um: fix build breakage in mm/slub.c
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7oF-0007P3-3s@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we have no equivalent of cpufeature machinery, so...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index e3ca7e0..94fed18 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -313,7 +313,7 @@ config CMPXCHG_LOCAL
 	def_bool X86_64 || (X86_32 && !M386)
 
 config CMPXCHG_DOUBLE
-	def_bool y
+	def_bool !UML
 
 config X86_L1_CACHE_SHIFT
 	int
-- 
1.7.2.5


