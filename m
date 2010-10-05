Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab0JEMM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:12:28 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:33607 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085Ab0JEMM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:12:27 -0400
X-ClientAddr: 91.119.2.61
Date: Tue, 5 Oct 2010 14:11:40 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound/soc/nuc900: remove duplicated include
Message-ID: <20101005141140.0276dc14@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o95C4VGB008556
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated include.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 sound/soc/nuc900/nuc900-ac97.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index caa7c90..265a950 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -20,7 +20,6 @@
 #include <sound/pcm.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
-#include <linux/device.h>
 #include <linux/clk.h>
 
 #include <mach/mfp.h>
-- 
1.7.2.2
