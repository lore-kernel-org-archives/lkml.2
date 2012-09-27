Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2I0GIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:08:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2I0GI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:08:29 -0400
Date: Wed, 26 Sep 2012 23:08:14 -0700
From: tip-bot for Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Message-ID: <tip-57c078ce13983d27c83f962b3e9722887209005c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lenb@kernel.org, isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de
In-Reply-To: <50625239.3050403@jp.fujitsu.com>
References: <50625239.3050403@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/api: Rename mp_register_lapic in a comment
Git-Commit-ID: 57c078ce13983d27c83f962b3e9722887209005c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:08:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57c078ce13983d27c83f962b3e9722887209005c
Gitweb:     http://git.kernel.org/tip/57c078ce13983d27c83f962b3e9722887209005c
Author:     Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
AuthorDate: Wed, 26 Sep 2012 09:54:17 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 13:29:36 +0200

x86/api: Rename mp_register_lapic in a comment

Commit 31d2092eb0c23636b73d2c24c0c11b66470cef58 ("x86: move
mp_register_lapic_address to boot.c") renamed mp_register_lapic
to acpi_register_lapic. But mp_register_lapic remains in a
comment. So the patch rename it.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/50625239.3050403@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b2297e5..e651f7a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -656,7 +656,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	acpi_register_lapic(physid, ACPI_MADT_ENABLED);
 
 	/*
-	 * If mp_register_lapic successfully generates a new logical cpu
+	 * If acpi_register_lapic successfully generates a new logical cpu
 	 * number, then the following will get us exactly what was mapped
 	 */
 	cpumask_andnot(new_map, cpu_present_mask, tmp_map);
