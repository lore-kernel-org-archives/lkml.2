Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2F0Ok4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:40:56 -0400
Received: from mail2.charite.de ([141.42.206.200]:49911 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab2F0Oky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:40:54 -0400
Date: Wed, 27 Jun 2012 16:40:51 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: Kernel 3.4.3: WARNING: at arch/x86/kernel/apic/ipi.c:109
 default_send_IPI_mask_logical+0x97/0xc7()
Message-ID: <20120627144051.GB8726@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI:

Jun 26 12:42:49 mail2 kernel: [436077.350389] ------------[ cut here ]------------
Jun 26 12:42:49 mail2 kernel: [436077.350417] WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x97/0xc7()
Jun 26 12:42:49 mail2 kernel: [436077.350423] Hardware name: ProLiant DL360 G4
Jun 26 12:42:49 mail2 kernel: [436077.350426] empty IPI mask
Jun 26 12:42:49 mail2 kernel: [436077.350428] Modules linked in: nfnetlink_log nfnetlink ipv6 tg3 microcode hpwdt rng_core psmouse container i6300esb button thermal processor
Jun 26 12:42:49 mail2 kernel: [436077.350457] Pid: 20792, comm: /usr/sbin/amavi Not tainted 3.4.3 #1
Jun 26 12:42:49 mail2 kernel: [436077.350462] Call Trace:
Jun 26 12:42:49 mail2 kernel: [436077.350477]  [<c1024334>] warn_slowpath_common+0x67/0x8e
Jun 26 12:42:49 mail2 kernel: [436077.350484]  [<c1018795>] ? default_send_IPI_mask_logical+0x97/0xc7
Jun 26 12:42:49 mail2 kernel: [436077.350490]  [<c1018795>] ? default_send_IPI_mask_logical+0x97/0xc7
Jun 26 12:42:49 mail2 kernel: [436077.350496]  [<c10243d7>] warn_slowpath_fmt+0x2e/0x30
Jun 26 12:42:49 mail2 kernel: [436077.350502]  [<c1018795>] default_send_IPI_mask_logical+0x97/0xc7
Jun 26 12:42:49 mail2 kernel: [436077.350510]  [<c107007b>] ? put_callchain_buffers+0x1b/0x3d
Jun 26 12:42:49 mail2 kernel: [436077.350516]  [<c10173ad>] native_send_call_func_ipi+0x42/0x54
Jun 26 12:42:49 mail2 kernel: [436077.350525]  [<c1055ae7>] smp_call_function_many+0x15c/0x1d5
Jun 26 12:42:49 mail2 kernel: [436077.350534]  [<c107713b>] ? drain_pages+0x62/0x62
Jun 26 12:42:49 mail2 kernel: [436077.350540]  [<c1055b85>] on_each_cpu_mask+0x25/0x3d
Jun 26 12:42:49 mail2 kernel: [436077.350545]  [<c107713b>] ? drain_pages+0x62/0x62
Jun 26 12:42:49 mail2 kernel: [436077.350550]  [<c10751fa>] drain_all_pages+0x89/0x90
Jun 26 12:42:49 mail2 kernel: [436077.350555]  [<c10774f3>] __alloc_pages_nodemask+0x3a8/0x651
Jun 26 12:42:49 mail2 kernel: [436077.350567]  [<c10a0ace>] do_huge_pmd_wp_page+0x1bc/0x567
Jun 26 12:42:49 mail2 kernel: [436077.350574]  [<c1044787>] ? __enqueue_entity+0x67/0x6f
Jun 26 12:42:49 mail2 kernel: [436077.350582]  [<c1089972>] handle_mm_fault+0x14a/0x206
Jun 26 12:42:49 mail2 kernel: [436077.350588]  [<c101d725>] ? vmalloc_sync_all+0x5/0x5
Jun 26 12:42:49 mail2 kernel: [436077.350593]  [<c101d818>] do_page_fault+0xf3/0x3ab
Jun 26 12:42:49 mail2 kernel: [436077.350604]  [<c1008fbc>] ? sys_clone+0x2b/0x32
Jun 26 12:42:49 mail2 kernel: [436077.350609]  [<c101d725>] ? vmalloc_sync_all+0x5/0x5
Jun 26 12:42:49 mail2 kernel: [436077.350620]  [<c12873bf>] error_code+0x67/0x6c
Jun 26 12:42:49 mail2 kernel: [436077.350625] ---[ end trace 402a702d5527abf9 ]---

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
