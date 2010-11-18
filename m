Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab0KROmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:42:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60210 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758430Ab0KROmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=RcUM7G717zeJkFrsTD+4+cPPdTDdC46EsaLTml5o/MXKuox4ikveP/3PqfbH8vlSWE
         LR/pIqDGac8sE4BIihCkdUVHnXi/eqlYJtf+nhtdSH5xFmr5mkMIMyKfnCuwPCsa556T
         dwgNVBEKZZx7HbZTe+ggyRba2F3nwhmDAkFhY=
Subject: [PATCH] cpu.c: remove unused variable
From: Dhaval Giani <dhaval.giani@gmail.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        akinobu.mita@gmail.com, oleg@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 15:41:59 +0100
Message-ID: <1290091319.1145.2.camel@gondor.retis>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu.c: remove unused variable

kernel/cpu.c: In function ‘take_cpu_down’:
kernel/cpu.c:200:15: warning: unused variable ‘cpu’

This variable is unused since param->hcpu is directly
used later on in cpu_notify.

Signed-off-by: Dhaval Giani <dhaval_giani@gmail.com>
---
 kernel/cpu.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -197,7 +197,6 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
-	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */


