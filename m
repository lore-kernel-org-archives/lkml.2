Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab2KAISH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 04:18:07 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34646 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2KAISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 04:18:00 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 16:17:59 +0800
Message-ID: <CAPgLHd_4Ehr62ifhr0wSTqp=xa9EmtO1RW4AVtfUtRR4Cui-+A@mail.gmail.com>
Subject: [PATCH -next] xen/x86: remove duplicated include from enlighten.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com, jeremy@goop.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, mukesh.rathor@oracle.com
Cc: yongjun_wei@trendmicro.com.cn, x86@kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/x86/xen/enlighten.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index eb9a567..4c694a7 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -45,7 +45,6 @@
 #include <xen/hvm.h>
 #include <xen/hvc-console.h>
 #include <xen/acpi.h>
-#include <xen/features.h>
 
 #include <asm/paravirt.h>
 #include <asm/apic.h>


