Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2IZAyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:54:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53977 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2IZAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:54:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50625239.3050403@jp.fujitsu.com>
Date: Wed, 26 Sep 2012 09:54:17 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@kernel.org>, <hpa@zytor.com>,
        <lenb@kernel.org>
Subject: [PATCH] x86: rename mp_register_lapic in a comment
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 31d2092eb0c23636b73d2c24c0c11b66470cef58 (x86: move
mp_register_lapic_address to boot.c) renamed mp_register_lapic
to acpi_register_lapic. But mp_register_lapic remains in a
comment. So the patch rename it.

CC: Len Brown <lenb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.6-rc5/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-3.6-rc5.orig/arch/x86/kernel/acpi/boot.c	2012-09-19 11:38:03.990715466 +0900
+++ linux-3.6-rc5/arch/x86/kernel/acpi/boot.c	2012-09-26 09:50:42.269534856 +0900
@@ -656,7 +656,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 	acpi_register_lapic(physid, ACPI_MADT_ENABLED);
 
 	/*
-	 * If mp_register_lapic successfully generates a new logical cpu
+	 * If acpi_register_lapic successfully generates a new logical cpu
 	 * number, then the following will get us exactly what was mapped
 	 */
 	cpumask_andnot(new_map, cpu_present_mask, tmp_map);

