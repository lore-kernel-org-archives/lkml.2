Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2BOFBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 00:01:25 -0500
Received: from ozlabs.org ([203.10.76.45]:40147 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2BOFAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 00:00:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Message-ID: <1329281884.20466.rusty@rustcorp.com.au>
Date: Wed, 15 Feb 2012 15:28:04 +1030
Subject: [PATCH 6/12] arch/powerpc: remove references to cpu_*_map.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/wsp/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/wsp/smp.c b/arch/powerpc/platforms/wsp/smp.c
--- a/arch/powerpc/platforms/wsp/smp.c
+++ b/arch/powerpc/platforms/wsp/smp.c
@@ -71,7 +71,7 @@ int __devinit smp_a2_kick_cpu(int nr)
 
 static int __init smp_a2_probe(void)
 {
-	return cpus_weight(cpu_possible_map);
+	return num_possible_cpus();
 }
 
 static struct smp_ops_t a2_smp_ops = {

