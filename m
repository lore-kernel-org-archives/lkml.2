Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2ASQqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:46:09 -0500
Received: from autoqwest.dor.state.ma.us ([65.118.148.102]:19363 "EHLO
	autoqwest.dor.state.ma.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2ASQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:46:05 -0500
X-Greylist: delayed 2728 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 11:46:05 EST
Message-ID: <4F18360D.3090304@dor.state.ma.us>
Date: Thu, 19 Jan 2012 10:26:05 -0500
From: Ron Murray <murrayr@dor.state.ma.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 
    Thunderbird/9.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel panic
References: <201201191202.q0JC243u029201@curly.dor.state.ma.us>
In-Reply-To: <201201191202.q0JC243u029201@curly.dor.state.ma.us>
X-Forwarded-Message-Id: <201201191202.q0JC243u029201@curly.dor.state.ma.us>
Content-Type: multipart/mixed; boundary="------------040608090009080404020606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--------------040608090009080404020606
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit


System Events
=-=-=-=-=-=-=
Jan 19 06:43:22 curly kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000028
Jan 19 06:43:22 curly kernel: IP: [<ffffffff810ca594>] 
dentry_lru_prune+0x22/0x49
Jan 19 06:43:22 curly kernel: PGD 79079067 PUD 337e1067 PMD 0
Jan 19 06:43:22 curly kernel: Oops: 0000 [#1] PREEMPT SMP
Jan 19 06:43:22 curly kernel: CPU 1
Jan 19 06:43:22 curly kernel: Modules linked in: pci_stub vboxpci(O) 
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) i915 drm_kms_helper bnep rfcomm 
bluetooth uinput act_police cls_basic cls_flow cls_fw cls_u32 sch_tbf 
sch_prio sch_hfsc sch_htb sch_ingress sch_sfq bridge stp llc 
xt_connlimit xt_realm xt_addrtype ip_set_hash_ip xt_comment ipt_ULOG 
xt_recent ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN 
ipt_ecn ipt_CLUSTERIP ipt_ah ip6_queue nf_nat_tftp nf_nat_sip 
nf_nat_pptp nf_nat_proto_gre nf_nat_irc xt_set nf_nat_h323 nf_nat_ftp 
nf_nat_amanda nf_conntrack_tftp nf_conntrack_sane nf_conntrack_sip 
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_broadcast ts_kmp nf_conntrack_irc nf_conntrack_amanda 
nf_conntrack_h323 nf_conntrack_ftp xt_time xt_TCPMSS xt_sctp xt_TPROXY 
nf_tproxy_core xt_policy xt_tcpmss xt_pkttype xt_physdev xt_owner 
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit 
xt_leng
Jan 19 06:43:22 curly kernel: th xt_iprange xt_helper xt_hashlimit 
xt_DSCP xt_dscp xt_dccp xt_connmark xt_CLASSIFY ip6t_LOG ip6t_REJECT 
ipt_LOG xt_state ip_set_hash_net ip_set nfnetlink fuse nfsd nfs lockd 
auth_rpcgss nfs_acl sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 
ip6table_mangle ip6table_raw ip6table_filter ip6_tables xt_tcpudp ipv6 
xt_conntrack iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 iptable_raw iptable_filter ip_tables 
x_tables configfs smsc47b397 coretemp loop dm_crypt joydev gspca_spca500 
gspca_main usbhid videodev v4l2_compat_ioctl32 hid snd_hda_codec_realtek 
tpm_infineon snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss 
snd_pcm snd_seq_dummy uhci_hcd snd_seq_oss e1000e snd_seq_midi hp_wmi 
psmouse sparse_keymap evdev serio_raw snd_rawmidi tpm_tis ehci_hcd 
pcspkr tpm snd_seq_midi_event snd_seq usbcore wmi iTCO_wdt floppy 
snd_timer tpm_bios snd_seq_device snd usb_common soundcore 
snd_page_alloc processor dm_mirror dm_region_hash dm_log dm_mod 
ata_generic sr_mod cdro
Jan 19 06:43:22 curly kernel: m
Jan 19 06:43:22 curly kernel:
Jan 19 06:43:22 curly kernel: Pid: 360, comm: kswapd0 Tainted: G 
W  O 3.2.1-curly-0 #1 Hewlett-Packard HP Compaq dc7700 Small Form 
Factor/0A54h
Jan 19 06:43:22 curly kernel: RIP: 0010:[<ffffffff810ca594>] 
[<ffffffff810ca594>] dentry_lru_prune+0x22/0x49
Jan 19 06:43:22 curly kernel: RSP: 0018:ffff880079be7bf0  EFLAGS: 00010202
Jan 19 06:43:22 curly kernel: RAX: 0000000000000000 RBX: 
ffff880041e85cc0 RCX: 0000000000002b2a
Jan 19 06:43:22 curly kernel: RDX: 0000000000002a2a RSI: 
0000000000000000 RDI: ffff880041e85cc0
Jan 19 06:43:22 curly kernel: RBP: ffff880079be7c00 R08: 
0000000000000000 R09: ffff88007dd10740
Jan 19 06:43:22 curly kernel: R10: ffff88007dd10740 R11: 
ffff88007dd10740 R12: ffff880017021600
Jan 19 06:43:22 curly kernel: R13: ffff8800620afd80 R14: 
0000000000000000 R15: ffff880018d8705c
Jan 19 06:43:22 curly kernel: FS:  0000000000000000(0000) 
GS:ffff88007dd00000(0000) knlGS:0000000000000000
Jan 19 06:43:22 curly kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Jan 19 06:43:22 curly kernel: CR2: 0000000000000028 CR3: 
0000000013c41000 CR4: 00000000000006e0
Jan 19 06:43:22 curly kernel: DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Jan 19 06:43:22 curly kernel: DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Jan 19 06:43:22 curly kernel: Process kswapd0 (pid: 360, threadinfo 
ffff880079be6000, task ffff88007a9c1e50)
Jan 19 06:43:22 curly kernel: Stack:
Jan 19 06:43:22 curly kernel: 0000000000000001 ffff880041e85cc0 
ffff880079be7c30 ffffffff810cb3ba
Jan 19 06:43:22 curly kernel: ffff880041e85cc0 ffff880079be7cb0 
ffff880041e85d40 ffff880041e85d1c
Jan 19 06:43:22 curly kernel: ffff880079be7c80 ffffffff810cb4f8 
ffff880079be7c50 ffff88006fac9d80
Jan 19 06:43:22 curly kernel: Call Trace:
Jan 19 06:43:22 curly kernel: [<ffffffff810cb3ba>] dentry_kill+0x7f/0x14a
Jan 19 06:43:22 curly kernel: [<ffffffff810cb4f8>] 
shrink_dentry_list+0x73/0xcf
Jan 19 06:43:22 curly kernel: [<ffffffff810cb6ad>] 
__shrink_dcache_sb+0x159/0x168
Jan 19 06:43:22 curly kernel: [<ffffffff810cbfed>] prune_dcache_sb+0xe/0x10
Jan 19 06:43:22 curly kernel: [<ffffffff810bd18d>] prune_super+0xd4/0x14f
Jan 19 06:43:22 curly kernel: [<ffffffff8108caa4>] shrink_slab+0x11a/0x195
Jan 19 06:43:22 curly kernel: [<ffffffff8108efb2>] kswapd+0x4e9/0x793
Jan 19 06:43:22 curly kernel: [<ffffffff81047ecd>] ? 
add_wait_queue+0x44/0x44
Jan 19 06:43:22 curly kernel: [<ffffffff8108eac9>] ? 
try_to_free_pages+0x3ca/0x3ca
Jan 19 06:43:22 curly kernel: [<ffffffff81047853>] kthread+0x7f/0x87
Jan 19 06:43:22 curly kernel: [<ffffffff81390d34>] 
kernel_thread_helper+0x4/0x10
Jan 19 06:43:22 curly kernel: [<ffffffff810477d4>] ? 
kthread_worker_fn+0x141/0x141
Jan 19 06:43:22 curly kernel: [<ffffffff81390d30>] ? gs_change+0xb/0xb
Jan 19 06:43:22 curly kernel: Code: 1a 4a 2c 00 41 5b 5b 5d c3 55 48 89 
e5 53 48 89 fb 50 48 8d 87 80 00 00 00 48 39 87 80 00 00 00 74 2c f6 07 
10 74 07 48 8b 47 60 <ff> 50 28 48 c7 c7 00 04 4f 81 e8 55 47 2c 00 48 
89 df e8 8a fd
Jan 19 06:43:22 curly kernel: RIP  [<ffffffff810ca594>] 
dentry_lru_prune+0x22/0x49
Jan 19 06:43:22 curly kernel: RSP <ffff880079be7bf0>
Jan 19 06:43:22 curly kernel: CR2: 0000000000000028
Jan 19 06:43:22 curly kernel: ---[ end trace a7919e7f17c0a729 ]---
Jan 19 06:43:22 curly kernel: note: kswapd0[360] exited with preempt_count 3


**********************************************************************
This email and any files transmitted with it are confidential and 
intended solely for the use of the individual or entity to whom they   
are addressed. If you have received this email in error please notify 
the system manager at postmaster at dor.state.ma.us.
**********************************************************************

--------------040608090009080404020606
Content-Type: text/plain; name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="Attached Message Part"


--------------040608090009080404020606--
