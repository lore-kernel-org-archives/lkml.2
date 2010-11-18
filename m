Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab0KROpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:45:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64893 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459Ab0KROpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VYIwDcq6WbvZsQlC4Qlds0ZdlxVc9YT1EKxm9DzXMNvS21/+PpFmIqXkcVq3n+JGX5
         mag9Byb3e2j+OKpiNF8Q8Pisy0OtDHPdptCSGI2UQPo0mb+xgvINt0evvn7uEBSwE5/N
         omNcGi/sei5fned9PKnLwDLTBd6k6N6sQH+8o=
Subject: [PATCH] cpu.c: remove unused variable
From: Dhaval Giani <dhaval.giani@gmail.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com,
        akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 15:44:54 +0100
Message-ID: <1290091494.1145.5.camel@gondor.retis>
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


