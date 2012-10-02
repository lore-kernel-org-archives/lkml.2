Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2JBLeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:34:36 -0400
Received: from mail2.charite.de ([141.42.206.200]:49715 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab2JBLef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:34:35 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 07:34:34 EDT
Date: Tue, 2 Oct 2012 13:26:31 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: 3.6.0: WARNING: at arch/x86/kernel/apic/ipi.c:109
 default_send_IPI_mask_logical+0x97/0xc7()
Message-ID: <20121002112631.GB15862@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct  2 10:49:33 mail2 kernel: [62773.643261] ------------[ cut here ]------------
Oct  2 10:49:33 mail2 kernel: [62773.643289] WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x97/0xc7()
Oct  2 10:49:33 mail2 kernel: [62773.643296] Hardware name: ProLiant DL360 G4
Oct  2 10:49:33 mail2 kernel: [62773.643301] empty IPI mask
Oct  2 10:49:33 mail2 kernel: [62773.643306] Modules linked in: nfnetlink_log nfnetlink ipv6 tg3 microcode rng_core psmouse hpwdt container thermal button processor i6300esb
Oct  2 10:49:33 mail2 kernel: [62773.643349] Pid: 22582, comm: clamd Not tainted 3.6.0 #1
Oct  2 10:49:33 mail2 kernel: [62773.643352] Call Trace:
Oct  2 10:49:33 mail2 kernel: [62773.643362]  [<c1027f94>] warn_slowpath_common+0x67/0x8e
Oct  2 10:49:33 mail2 kernel: [62773.643368]  [<c101beef>] ? default_send_IPI_mask_logical+0x97/0xc7
Oct  2 10:49:33 mail2 kernel: [62773.643373]  [<c101beef>] ? default_send_IPI_mask_logical+0x97/0xc7
Oct  2 10:49:33 mail2 kernel: [62773.643378]  [<c1028037>] warn_slowpath_fmt+0x2e/0x30
Oct  2 10:49:33 mail2 kernel: [62773.643383]  [<c101beef>] default_send_IPI_mask_logical+0x97/0xc7
Oct  2 10:49:33 mail2 kernel: [62773.643391]  [<c101aac4>] native_send_call_func_ipi+0x42/0x54
Oct  2 10:49:33 mail2 kernel: [62773.643398]  [<c105c56a>] smp_call_function_many+0x160/0x1dd
Oct  2 10:49:33 mail2 kernel: [62773.643403]  [<c1024fe7>] native_flush_tlb_others+0x26/0x28
Oct  2 10:49:33 mail2 kernel: [62773.643408]  [<c1025218>] flush_tlb_page+0x49/0x73
Oct  2 10:49:33 mail2 kernel: [62773.643416]  [<c109c420>] ptep_clear_flush+0x18/0x20
Oct  2 10:49:33 mail2 kernel: [62773.643427]  [<c108fe26>] do_wp_page+0x1f4/0x72f
Oct  2 10:49:33 mail2 kernel: [62773.643438]  [<c104ab0c>] ? __enqueue_entity+0x6b/0x73
Oct  2 10:49:33 mail2 kernel: [62773.643447]  [<c10917c4>] handle_pte_fault+0x47a/0x8d8
Oct  2 10:49:33 mail2 kernel: [62773.643452]  [<c105c7eb>] ? generic_smp_call_function_interrupt+0x6c/0x150
Oct  2 10:49:33 mail2 kernel: [62773.643457]  [<c105c842>] ? generic_smp_call_function_interrupt+0xc3/0x150
Oct  2 10:49:33 mail2 kernel: [62773.643462]  [<c10928e1>] handle_mm_fault+0x19c/0x211
Oct  2 10:49:33 mail2 kernel: [62773.643471]  [<c1020fe5>] ? vmalloc_sync_all+0x5/0x5
Oct  2 10:49:33 mail2 kernel: [62773.643476]  [<c10210d8>] do_page_fault+0xf3/0x3ab
Oct  2 10:49:33 mail2 kernel: [62773.643483]  [<c105c842>] ? generic_smp_call_function_interrupt+0xc3/0x150
Oct  2 10:49:33 mail2 kernel: [62773.643494]  [<c116a593>] ? radix_tree_lookup_slot+0xd/0xf
Oct  2 10:49:33 mail2 kernel: [62773.643502]  [<c10793fd>] ? find_get_page+0x1b/0x70
Oct  2 10:49:33 mail2 kernel: [62773.643511]  [<c1020fe5>] ? vmalloc_sync_all+0x5/0x5
Oct  2 10:49:33 mail2 kernel: [62773.643523]  [<c129f7a3>] error_code+0x67/0x6c
Oct  2 10:49:33 mail2 kernel: [62773.643531]  [<c107914e>] ? file_read_actor+0x25/0xb8
Oct  2 10:49:33 mail2 kernel: [62773.643540]  [<c1088e4b>] shmem_file_aio_read+0xf1/0x2bb
Oct  2 10:49:33 mail2 kernel: [62773.643552]  [<c10abb31>] do_sync_read+0x8f/0xbf
Oct  2 10:49:33 mail2 kernel: [62773.643558]  [<c10abaa2>] ? do_sync_write+0xbf/0xbf
Oct  2 10:49:33 mail2 kernel: [62773.643563]  [<c10ac450>] vfs_read+0x80/0x13e
Oct  2 10:49:33 mail2 kernel: [62773.643568]  [<c10abaa2>] ? do_sync_write+0xbf/0xbf
Oct  2 10:49:33 mail2 kernel: [62773.643573]  [<c10ac636>] sys_pread64+0x4e/0x7c
Oct  2 10:49:33 mail2 kernel: [62773.643578]  [<c129fa17>] sysenter_do_call+0x12/0x26
Oct  2 10:49:33 mail2 kernel: [62773.643582] ---[ end trace 5b941cf88518b699 ]---

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
