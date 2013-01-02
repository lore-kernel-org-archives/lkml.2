Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3ABTSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:18:33 -0500
Received: from mail2.charite.de ([141.42.206.200]:42128 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3ABTSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:18:30 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 14:18:30 EST
Date: Wed, 2 Jan 2013 20:09:20 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
Message-ID: <20130102190920.GD29452@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happened of a virtual guest (Linux mail 3.2.0-35-virtual #55-Ubuntu SMP Wed Dec 5 18:02:05 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux)

Jan  2 13:24:08 mail kernel: [3531872.484283] INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
Jan  2 13:24:08 mail kernel: [3531872.484398] sending NMI to all CPUs:
Jan  2 13:24:08 mail kernel: [3531872.484430] NMI backtrace for cpu 3
Jan  2 13:24:08 mail kernel: [3531872.484432] CPU 3
Jan  2 13:24:08 mail kernel: [3531872.484433] Modules linked in: btrfs zlib_deflate libcrc32c ufs vfat msdos fat xfs ip6_queue nf_conntrack_proto_udplite xt_TCPMSS xt_sctp ip6t_LOG ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle ip6table_filter act_police cls_basic cls_flow cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_i
 pv6 xt_tcpmss xt_pkttype xt
Jan  2 13:24:08 mail kernel: _physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext2 psmouse serio_raw virtio_balloon lp parport floppy
Jan  2 13:24:08 mail kernel: [3531872.484533]
Jan  2 13:24:08 mail kernel: [3531872.484536] Pid: 0, comm: swapper/3 Not tainted 3.2.0-33-virtual #52-Ubuntu Bochs Bochs
Jan  2 13:24:08 mail kernel: [3531872.484539] RIP: 0010:[<ffffffff81036d5f>]  [<ffffffff81036d5f>] flat_send_IPI_all+0xaf/0xd0
Jan  2 13:24:08 mail kernel: [3531872.484548] RSP: 0018:ffff88011fd83d88  EFLAGS: 00010006
Jan  2 13:24:08 mail kernel: [3531872.484550] RAX: 0000000000000000 RBX: 0000000000000046 RCX: 000000000003ffff
Jan  2 13:24:08 mail kernel: [3531872.484552] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000300
Jan  2 13:24:08 mail kernel: [3531872.484554] RBP: ffff88011fd83da8 R08: 000000000000000a R09: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.484556] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000c00
Jan  2 13:24:08 mail kernel: [3531872.484558] R13: 000000000f000000 R14: ffff88011fd8e700 R15: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.484560] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.484562] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  2 13:24:08 mail kernel: [3531872.484564] CR2: 00007fc17c266000 CR3: 000000007a52d000 CR4: 00000000000006e0
Jan  2 13:24:08 mail kernel: [3531872.484570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.484575] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  2 13:24:08 mail kernel: [3531872.484577] Process swapper/3 (pid: 0, threadinfo ffff880118b4e000, task ffff880118b516e0)
Jan  2 13:24:08 mail kernel: [3531872.484579] Stack:
Jan  2 13:24:08 mail kernel: [3531872.484610]  0000000000000000 0000000000002710 ffffffff81c30900 ffffffff81c30a00
Jan  2 13:24:08 mail kernel: [3531872.484614]  ffff88011fd83dc8 ffffffff810323ca 000609111e000000 ffffffff81c30900
Jan  2 13:24:08 mail kernel: [3531872.484617]  ffff88011fd83de8 ffffffff810ddf37 ffff88011fd83e18 ffff88011fd8ea60
Jan  2 13:24:08 mail kernel: [3531872.484620] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.484652]  <IRQ>
Jan  2 13:24:08 mail kernel: [3531872.484689]  [<ffffffff810323ca>] arch_trigger_all_cpu_backtrace+0x5a/0x90
Jan  2 13:24:08 mail kernel: [3531872.484703]  [<ffffffff810ddf37>] check_cpu_stall.isra.36+0x97/0xf0
Jan  2 13:24:08 mail kernel: [3531872.484706]  [<ffffffff810ddfc8>] __rcu_pending+0x38/0x1b0
Jan  2 13:24:08 mail kernel: [3531872.484709]  [<ffffffff810de58b>] rcu_check_callbacks+0x1cb/0x1e0
Jan  2 13:24:08 mail kernel: [3531872.484719]  [<ffffffff81076fb8>] update_process_times+0x48/0x90
Jan  2 13:24:08 mail kernel: [3531872.484725]  [<ffffffff8109a5f4>] tick_sched_timer+0x64/0xc0
Jan  2 13:24:08 mail kernel: [3531872.484730]  [<ffffffff8108cd78>] __run_hrtimer+0x78/0x1f0
Jan  2 13:24:08 mail kernel: [3531872.484733]  [<ffffffff8109a590>] ? tick_nohz_handler+0x100/0x100
Jan  2 13:24:08 mail kernel: [3531872.484736]  [<ffffffff8108d6a7>] hrtimer_interrupt+0xf7/0x230
Jan  2 13:24:08 mail kernel: [3531872.484742]  [<ffffffff8165f0c9>] smp_apic_timer_interrupt+0x69/0x99
Jan  2 13:24:08 mail kernel: [3531872.484745]  [<ffffffff8165cf9e>] apic_timer_interrupt+0x6e/0x80
Jan  2 13:24:08 mail kernel: [3531872.484747]  <EOI>
Jan  2 13:24:08 mail kernel: [3531872.484780]  [<ffffffff8108f175>] ? sched_clock_local+0x25/0x90
Jan  2 13:24:08 mail kernel: [3531872.484785]  [<ffffffff8103bf6b>] ? native_safe_halt+0xb/0x10
Jan  2 13:24:08 mail kernel: [3531872.484790]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.484794]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.484804]  [<ffffffff81631f52>] start_secondary+0xd9/0xdb
Jan  2 13:24:08 mail kernel: [3531872.484806] Code: 8b 05 06 4b ca 00 41 c1 e5 18 44 8b 60 34 ff 90 48 01 00 00 44 89 2c 25 10 b3 5f ff 41 81 cc 00 04 00 00 44 89 24 25 00 b3 5f ff <48> 89 df 57 9d 0f 1f 44 00 00 48 83 c4 08 5b 41 5c 41 5d 5d c3
Jan  2 13:24:08 mail kernel: [3531872.485054] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.485055]  <IRQ>  [<ffffffff810323ca>] arch_trigger_all_cpu_backtrace+0x5a/0x90
Jan  2 13:24:08 mail kernel: [3531872.485061]  [<ffffffff810ddf37>] check_cpu_stall.isra.36+0x97/0xf0
Jan  2 13:24:08 mail kernel: [3531872.485064]  [<ffffffff810ddfc8>] __rcu_pending+0x38/0x1b0
Jan  2 13:24:08 mail kernel: [3531872.485067]  [<ffffffff810de58b>] rcu_check_callbacks+0x1cb/0x1e0
Jan  2 13:24:08 mail kernel: [3531872.485070]  [<ffffffff81076fb8>] update_process_times+0x48/0x90
Jan  2 13:24:08 mail kernel: [3531872.485073]  [<ffffffff8109a5f4>] tick_sched_timer+0x64/0xc0
Jan  2 13:24:08 mail kernel: [3531872.485076]  [<ffffffff8108cd78>] __run_hrtimer+0x78/0x1f0
Jan  2 13:24:08 mail kernel: [3531872.485078]  [<ffffffff8109a590>] ? tick_nohz_handler+0x100/0x100
Jan  2 13:24:08 mail kernel: [3531872.485081]  [<ffffffff8108d6a7>] hrtimer_interrupt+0xf7/0x230
Jan  2 13:24:08 mail kernel: [3531872.485088]  [<ffffffff8165f0c9>] smp_apic_timer_interrupt+0x69/0x99
Jan  2 13:24:08 mail kernel: [3531872.485090]  [<ffffffff8165cf9e>] apic_timer_interrupt+0x6e/0x80
Jan  2 13:24:08 mail kernel: [3531872.485092]  <EOI>  [<ffffffff8108f175>] ? sched_clock_local+0x25/0x90
Jan  2 13:24:08 mail kernel: [3531872.485097]  [<ffffffff8103bf6b>] ? native_safe_halt+0xb/0x10
Jan  2 13:24:08 mail kernel: [3531872.485099]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.485102]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.485105]  [<ffffffff81631f52>] start_secondary+0xd9/0xdb
Jan  2 13:24:08 mail kernel: [3531872.485109] NMI backtrace for cpu 1
Jan  2 13:24:08 mail kernel: [3531872.485111] CPU 1
Jan  2 13:24:08 mail kernel: [3531872.485113] Modules linked in: btrfs zlib_deflate libcrc32c ufs vfat msdos fat xfs ip6_queue nf_conntrack_proto_udplite xt_TCPMSS xt_sctp ip6t_LOG ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle ip6table_filter act_police cls_basic cls_flow cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_i
 pv6 xt_tcpmss xt_pkttype xt
Jan  2 13:24:08 mail kernel: _physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext2 psmouse serio_raw virtio_balloon lp parport floppy
Jan  2 13:24:08 mail kernel: [3531872.485179]
Jan  2 13:24:08 mail kernel: [3531872.485181] Pid: 0, comm: swapper/1 Not tainted 3.2.0-33-virtual #52-Ubuntu Bochs Bochs
Jan  2 13:24:08 mail kernel: [3531872.485184] RIP: 0010:[<ffffffff8103bf6b>]  [<ffffffff8103bf6b>] native_safe_halt+0xb/0x10
Jan  2 13:24:08 mail kernel: [3531872.485190] RSP: 0018:ffff880118b17ec8  EFLAGS: 00000246
Jan  2 13:24:08 mail kernel: [3531872.485192] RAX: 0000000000000000 RBX: ffff880118b17fd8 RCX: 00000000ffffffff
Jan  2 13:24:08 mail kernel: [3531872.485194] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81dd9e48
Jan  2 13:24:08 mail kernel: [3531872.485196] RBP: ffff880118b17ec8 R08: 0000000000000000 R09: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485198] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81cdbc60
Jan  2 13:24:08 mail kernel: [3531872.485200] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485202] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485204] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  2 13:24:08 mail kernel: [3531872.485206] CR2: 00007fb19f934000 CR3: 0000000001c05000 CR4: 00000000000006e0
Jan  2 13:24:08 mail kernel: [3531872.485212] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485217] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  2 13:24:08 mail kernel: [3531872.485219] Process swapper/1 (pid: 0, threadinfo ffff880118b16000, task ffff880118b196e0)
Jan  2 13:24:08 mail kernel: [3531872.485220] Stack:
Jan  2 13:24:08 mail kernel: [3531872.485254]  ffff880118b17ef8 ffffffff8101b8a3 ffff880118b17fd8 ffffffff81cdbc60
Jan  2 13:24:08 mail kernel: [3531872.485257]  0000000000000000 0000000000000000 ffff880118b17f28 ffffffff81012236
Jan  2 13:24:08 mail kernel: [3531872.485261]  ffff880118b17f18 cc49a6709741f8e5 0000000000000000 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485264] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.485298]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.485301]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.485304]  [<ffffffff81631f52>] start_secondary+0xd9/0xdb
Jan  2 13:24:08 mail kernel: [3531872.485306] Code: 55 48 89 e5 0f 1f 44 00 00 fa 5d c3 0f 1f 40 00 55 48 89 e5 0f 1f 44 00 00 fb 5d c3 0f 1f 40 00 55 48 89 e5 0f 1f 44 00 00 fb f4 <5d> c3 0f 1f 00 55 48 89 e5 0f 1f 44 00 00 f4 5d c3 0f 1f 40 00
Jan  2 13:24:08 mail kernel: [3531872.485556] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.485559]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.485561]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.485568]  [<ffffffff81631f52>] start_secondary+0xd9/0xdb
Jan  2 13:24:08 mail kernel: [3531872.485573] NMI backtrace for cpu 2
Jan  2 13:24:08 mail kernel: [3531872.485578] CPU 2
Jan  2 13:24:08 mail kernel: [3531872.485581] Modules linked in: btrfs zlib_deflate libcrc32c ufs vfat msdos fat xfs ip6_queue nf_conntrack_proto_udplite xt_TCPMSS xt_sctp ip6t_LOG ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle ip6table_filter act_police cls_basic cls_flow cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_i
 pv6 xt_tcpmss xt_pkttype xt
Jan  2 13:24:08 mail kernel: _physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext2 psmouse serio_raw virtio_balloon lp parport floppy
Jan  2 13:24:08 mail kernel: [3531872.485718]
Jan  2 13:24:08 mail kernel: [3531872.485723] Pid: 0, comm: swapper/2 Not tainted 3.2.0-33-virtual #52-Ubuntu Bochs Bochs
Jan  2 13:24:08 mail kernel: [3531872.485729] RIP: 0010:[<ffffffff8103bf6b>]  [<ffffffff8103bf6b>] native_safe_halt+0xb/0x10
Jan  2 13:24:08 mail kernel: [3531872.485741] RSP: 0018:ffff880118b39ec8  EFLAGS: 00000246
Jan  2 13:24:08 mail kernel: [3531872.485745] RAX: 0000000000000000 RBX: ffff880118b39fd8 RCX: 00000000ffffffff
Jan  2 13:24:08 mail kernel: [3531872.485749] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81dd9e48
Jan  2 13:24:08 mail kernel: [3531872.485753] RBP: ffff880118b39ec8 R08: 0000000000000000 R09: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485757] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff81cdbc60
Jan  2 13:24:08 mail kernel: [3531872.485761] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485766] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485770] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  2 13:24:08 mail kernel: [3531872.485774] CR2: 00007fb19f934000 CR3: 000000008f70e000 CR4: 00000000000006e0
Jan  2 13:24:08 mail kernel: [3531872.485785] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485795] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  2 13:24:08 mail kernel: [3531872.485800] Process swapper/2 (pid: 0, threadinfo ffff880118b38000, task ffff880118b316e0)
Jan  2 13:24:08 mail kernel: [3531872.485803] Stack:
Jan  2 13:24:08 mail kernel: [3531872.485873]  ffff880118b39ef8 ffffffff8101b8a3 ffff880118b39fd8 ffffffff81cdbc60
Jan  2 13:24:08 mail kernel: [3531872.485881]  0000000000000000 0000000000000000 ffff880118b39f28 ffffffff81012236
Jan  2 13:24:08 mail kernel: [3531872.485887]  ffff880118b39f18 4aab3b13eb9b4215 0000000000000000 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.485894] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.485970]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.485977]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.485984]  [<ffffffff81631f52>] start_secondary+0xd9/0xdb
Jan  2 13:24:08 mail kernel: [3531872.485988] Code: 55 48 89 e5 0f 1f 44 00 00 fa 5d c3 0f 1f 40 00 55 48 89 e5 0f 1f 44 00 00 fb 5d c3 0f 1f 40 00 55 48 89 e5 0f 1f 44 00 00 fb f4 <5d> c3 0f 1f 00 55 48 89 e5 0f 1f 44 00 00 f4 5d c3 0f 1f 40 00
Jan  2 13:24:08 mail kernel: [3531872.486565] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.486570]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.486576]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.486581]  [<ffffffff81631f52>] start_secondary+0xd9/0xdb
Jan  2 13:24:08 mail kernel: [3531872.467874] NMI backtrace for cpu 0
Jan  2 13:24:08 mail kernel: [3531872.467874] CPU 0
Jan  2 13:24:08 mail kernel: [3531872.467874] Modules linked in: btrfs zlib_deflate libcrc32c ufs vfat msdos fat xfs ip6_queue nf_conntrack_proto_udplite xt_TCPMSS xt_sctp ip6t_LOG ip6t_REJECT nf_conntrack_ipv6 ip6table_raw ip6table_mangle ip6table_filter act_police cls_basic cls_flow cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah xt_set ip_set nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_i
 pv6 xt_tcpmss xt_pkttype xt
Jan  2 13:24:08 mail kernel: _physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables ext2 psmouse serio_raw virtio_balloon lp parport floppy
Jan  2 13:24:08 mail kernel: [3531872.467874]
Jan  2 13:24:08 mail kernel: [3531872.467874] Pid: 0, comm: swapper/0 Not tainted 3.2.0-33-virtual #52-Ubuntu Bochs Bochs
Jan  2 13:24:08 mail kernel: [3531872.467874] RIP: 0010:[<ffffffff8103bf6b>]  [<ffffffff8103bf6b>] native_safe_halt+0xb/0x10
Jan  2 13:24:08 mail kernel: [3531872.467874] RSP: 0018:ffffffff81c01ea8  EFLAGS: 00000246
Jan  2 13:24:08 mail kernel: [3531872.467874] RAX: 0000000000000000 RBX: ffffffff81c01fd8 RCX: 00000000ffffffff
Jan  2 13:24:08 mail kernel: [3531872.467874] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81dd9e48
Jan  2 13:24:08 mail kernel: [3531872.467874] RBP: ffffffff81c01ea8 R08: 0000000000000000 R09: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.467874] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81cdbc60
Jan  2 13:24:08 mail kernel: [3531872.467874] R13: 0000000000000000 R14: ffffffffffffffff R15: 000000000008c800
Jan  2 13:24:08 mail kernel: [3531872.467874] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.467874] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  2 13:24:08 mail kernel: [3531872.467874] CR2: 00007ffe7e9c39cc CR3: 00000000db7ed000 CR4: 00000000000006f0
Jan  2 13:24:08 mail kernel: [3531872.467874] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  2 13:24:08 mail kernel: [3531872.467874] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  2 13:24:08 mail kernel: [3531872.467874] Process swapper/0 (pid: 0, threadinfo ffffffff81c00000, task ffffffff81c0d020)
Jan  2 13:24:08 mail kernel: [3531872.467874] Stack:
Jan  2 13:24:08 mail kernel: [3531872.467874]  ffffffff81c01ed8 ffffffff8101b8a3 ffffffff81c01fd8 ffffffff81cdbc60
Jan  2 13:24:08 mail kernel: [3531872.467874]  ffff88011ffb0840 ffffffffffffffff ffffffff81c01f08 ffffffff81012236
Jan  2 13:24:08 mail kernel: [3531872.467874]  ffffffffffffffff a87feeb7073bf6b3 0000000000000000 ffffffff81d42d20
Jan  2 13:24:08 mail kernel: [3531872.467874] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff8161ac2e>] rest_init+0x72/0x74
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9c03>] start_kernel+0x3b0/0x3bd
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9388>] x86_64_start_reservations+0x132/0x136
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9140>] ? early_idt_handlers+0x140/0x140
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9459>] x86_64_start_kernel+0xcd/0xdc
Jan  2 13:24:08 mail kernel: [3531872.467874] Code: 55 48 89 e5 0f 1f 44 00 00 fa 5d c3 0f 1f 40 00 55 48 89 e5 0f 1f 44 00 00 fb 5d c3 0f 1f 40 00 55 48 89 e5 0f 1f 44 00 00 fb f4 <5d> c3 0f 1f 00 55 48 89 e5 0f 1f 44 00 00 f4 5d c3 0f 1f 40 00
Jan  2 13:24:08 mail kernel: [3531872.467874] Call Trace:
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff8101b8a3>] default_idle+0x53/0x1d0
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81012236>] cpu_idle+0xd6/0x120
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff8161ac2e>] rest_init+0x72/0x74
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9c03>] start_kernel+0x3b0/0x3bd
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9388>] x86_64_start_reservations+0x132/0x136
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9140>] ? early_idt_handlers+0x140/0x140
Jan  2 13:24:08 mail kernel: [3531872.467874]  [<ffffffff81cf9459>] x86_64_start_kernel+0xcd/0xdc

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
