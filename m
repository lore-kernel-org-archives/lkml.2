Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0JDLrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:47:21 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:59456 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab0JDLrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:47:11 -0400
X-Greylist: delayed 3957 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 07:47:10 EDT
X-ClientAddr: 91.119.0.188
Date: Mon, 4 Oct 2010 12:39:29 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] arm/shmobile: remove duplicated include
Message-ID: <20101004123929.094848ba@absol.kitzblitz>
In-Reply-To: <20101004122436.7092868f@absol.kitzblitz>
References: <20101004122436.7092868f@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o94AXLMP020440
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 arch/arm/mach-shmobile/board-ap4evb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 95935c8..3ebb5be 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -30,7 +30,6 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
-#include <linux/mmc/host.h>
 #include <linux/mmc/sh_mmcif.h>
 #include <linux/i2c.h>
 #include <linux/i2c/tsc2007.h>
-- 
1.7.2.2
