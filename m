Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2JGOGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 10:06:53 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47048 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2JGOGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 10:06:48 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 22:06:47 +0800
Message-ID: <CAPgLHd-D5pe5L5OLfbNZv7MLywy-2Qr_VWH27AiwaC+Q7inzmA@mail.gmail.com>
Subject: [PATCH] xen/x86: remove duplicated include from enlighten.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com, jeremy@goop.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
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
 arch/x86/xen/enlighten.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bf788d3..061b148 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -81,8 +81,6 @@
 #include "smp.h"
 #include "multicalls.h"
 
-#include <xen/events.h>
-
 EXPORT_SYMBOL_GPL(hypercall_page);
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);

