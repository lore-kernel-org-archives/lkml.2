Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0JVNBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:01:20 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:59387 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab0JVNBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:01:19 -0400
Date: Fri, 22 Oct 2010 14:58:53 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Dale Farnsworth <dale@farnsworth.org>
Subject: [PATCH] powerpc/mv64x60: suspected typo in assignment
Message-ID: <20101022145853.7216c41f@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested, but looks like an obvious typo to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/powerpc/sysdev/mv64x60_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/mv64x60_dev.c b/arch/powerpc/sysdev/mv64x60_dev.c
index 1398bc4..a2c4999 100644
--- a/arch/powerpc/sysdev/mv64x60_dev.c
+++ b/arch/powerpc/sysdev/mv64x60_dev.c
@@ -345,7 +345,7 @@ static int __init mv64x60_i2c_device_setup(struct device_node *np, int id)
 	if (prop)
 		pdata.freq_m = *prop;
 
-	pdata.freq_m = 3;	/* default */
+	pdata.freq_n = 3;	/* default */
 	prop = of_get_property(np, "freq_n", NULL);
 	if (prop)
 		pdata.freq_n = *prop;
-- 
1.7.2.2
