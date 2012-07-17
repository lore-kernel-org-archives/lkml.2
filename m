Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2GQFCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:02:24 -0400
Received: from ozlabs.org ([203.10.76.45]:54596 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2GQFAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:54 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 06/10] kvm tools, powerpc: Reformatting in find_cpu_info()
Date: Tue, 17 Jul 2012 15:00:16 +1000
Message-Id: <1342501220-10209-7-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt's enter key was broken when he wrote this ;)

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index 7326f5b..586b232 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -75,13 +75,15 @@ static struct pvr_info host_pvr_info[] = {
 struct cpu_info *find_cpu_info(u32 pvr)
 {
 	unsigned int i;
+
 	for (i = 0; i < ARRAY_SIZE(host_pvr_info); i++) {
-		if ((pvr & host_pvr_info[i].pvr_mask) ==
-		    host_pvr_info[i].pvr) {
+		if ((pvr & host_pvr_info[i].pvr_mask) == host_pvr_info[i].pvr) {
 			return host_pvr_info[i].cpu_info;
 		}
 	}
+
 	/* Didn't find anything? Rut-ro. */
 	pr_warning("Host CPU unsupported by kvmtool\n");
+
 	return &cpu_dummy_info;
 }
-- 
1.7.9.5

