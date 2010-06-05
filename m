Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab0FEV25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:28:57 -0400
Received: from a.ns.miles-group.at ([217.188.240.210]:48230 "EHLO
	radon.swed.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab0FEV24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:28:56 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: tglx@linutronix.de
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, rakib.mullick@gmail.com,
       ebiederm@xmission.com, gorcunov@openvz.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Richard Weinberger <richard@nod.at>
Subject: [PATCH] APIC: Remove unused variable
Date: Sat,  5 Jun 2010 23:28:36 +0200
Message-Id: <1275773316-21626-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100605211943.GN5483@bicker>
References: <20100605211943.GN5483@bicker>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

base is never used in this file.
---
 arch/x86/kernel/apic/es7000_32.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 425e53a..770262b 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -125,12 +125,6 @@ static unsigned long			host_addr;
 
 int					es7000_plat;
 
-/*
- * GSI override for ES7000 platforms.
- */
-
-static unsigned int			base;
-
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
-- 
1.6.6.1

