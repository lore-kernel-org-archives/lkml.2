Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0FEVDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:03:23 -0400
Received: from a.ns.miles-group.at ([217.188.240.210]:48945 "EHLO
	radon.swed.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0FEVDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:03:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jun 2010 17:03:21 EDT
/m: 
From: Richard Weinberger <richard@nod.at>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, rakib.mullick@gmail.com,
       ebiederm@xmission.com, gorcunov@openvz.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Richard Weinberger <richard@nod.at>
Subject: [PATCH] APIC: Remove unused variable
Date: Sat,  5 Jun 2010 22:56:09 +0200
Message-Id: <1275771369-15113-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

base is never used in this file.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/kernel/apic/es7000_32.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 425e53a..ef34391 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -129,8 +129,6 @@ int					es7000_plat;
  * GSI override for ES7000 platforms.
  */
 
-static unsigned int			base;
-
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
-- 
1.6.6.1

