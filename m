Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0JDOXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:23:22 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:39382 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab0JDOXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:23:21 -0400
Date: Mon, 4 Oct 2010 16:22:16 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Patrick McHardy <kaber@trash.net>
Cc: Hannes Eder <heder@google.com>, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: remove duplicated include
Message-ID: <20101004162216.6d2c26c5@absol.kitzblitz>
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

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 net/netfilter/xt_ipvs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 7a4d66d..9127a3d 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -16,7 +16,6 @@
 #include <linux/ip_vs.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_ipvs.h>
 #include <net/netfilter/nf_conntrack.h>
 
-- 
1.7.2.2
