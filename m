Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2CHJkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:40:40 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33397 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2CHJki convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Thu, 8 Mar 2012 04:40:38 -0500
Message-Id: <4F588CD50200007800077112@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Mar 2012 09:41:25 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <rusty@rustcorp.com.au>, "Michal Marek" <mmarek@suse.cz>
Cc: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] modpost: fix ALL_INIT_DATA_SECTIONS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was lacking a comma between two supposed to be separate strings.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.3-rc6/scripts/mod/modpost.c
+++ 3.3-rc6-modpost-all-init-data/scripts/mod/modpost.c
@@ -849,7 +849,7 @@ static void check_section(const char *mo
 
 #define ALL_INIT_DATA_SECTIONS \
 	".init.setup$", ".init.rodata$", \
-	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
+	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \
 	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
 #define ALL_EXIT_DATA_SECTIONS \
 	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"



