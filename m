Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0H3Izr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:55:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60890 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0H3Izp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QsZTGzv9MJ72zQ1cvpduIcL7zn2R3nz0+G8A6fq2kiU5V/co3/cp5Tcr5DAMBNhd9s
         Ue1rqOZbIaDhtYCp59IIXtcX6RHQTuG0ge2D6v0tVYK+e1yICFXOzNfb9WtEBK8Lmjrv
         1Sk01LcQqzkyLeSdySfXcu0DPmzN5Qan9Kunk=
Date: Mon, 30 Aug 2010 11:55:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, Avi Kivity <avi@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #16961] kernel BUG at
 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
Message-ID: <20100830085539.GA5244@swordfish.minsk.epam.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
 <4AUWBNzTkbD.A.qb.EGueMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <4AUWBNzTkbD.A.qb.EGueMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/30/10 00:36), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16961
> Subject		: kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-08-19 9:54 (11 days old)
> Message-ID	: <20100819095429.GA5201@swordfish.minsk.epam.com>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128221169606214&w=3D2
> Handled-By	: Avi Kivity <avi@redhat.com>
>=20

Hello,
=2E36-rc3

[ 2913.218767] kvm: disabling virtualization on CPU1
[ 2913.219078] CPU 1 is now offline
[ 2913.221758] lockdep: fixing up alternatives.
[ 2913.221814] Booting Node 0 Processor 1 APIC 0x1
[ 2913.363980] ------------[ cut here ]------------
[ 2913.364042] kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978!
[ 2913.364107] invalid opcode: 0000 [#1] PREEMPT SMP=20
[ 2913.364173] last sysfs file: /sys/devices/system/cpu/cpu1/online
[ 2913.364262] CPU 1=20
[ 2913.364285] Modules linked in: kvm_intel kvm ipv6 ac battery snd_seq_dum=
my snd_seq_oss snd_seq_midi_event wmi snd_seq snd_seq_device snd_hda_codec_=
atihdmi button snd_hda_codec_realtek psmouse serio_raw snd_hda_intel snd_hd=
a_codec
snd_hwdep snd_pcm_oss snd_pcm broadcom snd_timer usbhid hid tg3 libphy snd_=
page_alloc evdev snd_mixer_oss snd soundcore ehci_hcd sr_mod usbcore cdrom =
sd_mod ahci libahci
[ 2913.364784]=20
[ 2913.364805] Pid: 5912, comm: qemu-kvm Not tainted 2.6.36-rc3-dbg-00144-g=
b958348-dirty #144 Aspire 5741G    /Aspire 5741G   =20
[ 2913.364965] RIP: 0010:[<ffffffffa0223446>]  [<ffffffffa0223446>] kvm_han=
dle_fault_on_reboot+0xf/0x11 [kvm]
[ 2913.365073] RSP: 0000:ffff880150b87b18  EFLAGS: 00010246
[ 2913.365128] RAX: ffff880150b87b40 RBX: ffff8801534fc000 RCX: ffff880154e=
75000
[ 2913.365225] RDX: ffff880002640000 RSI: ffff880154e4e638 RDI: ffff880154e=
75000
[ 2913.365292] RBP: ffff880150b87b18 R08: 0000000000000001 R09: 00000000000=
0039c
[ 2913.365357] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000=
00001
[ 2913.365422] R13: ffff880154e75000 R14: ffff880154e4df10 R15: 00000000000=
00000
[ 2913.365489] FS:  00007f23062c6710(0000) GS:ffff880002640000(0000) knlGS:=
0000000000000000
[ 2913.365563] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 2913.365617] CR2: 0000000000000000 CR3: 000000015544d000 CR4: 00000000000=
006e0
[ 2913.365682] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2913.365747] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2913.365813] Process qemu-kvm (pid: 5912, threadinfo ffff880150b86000, ta=
sk ffff880154e4df10)
[ 2913.365929] Stack:
[ 2913.365953]  ffff880150b87b68 ffffffffa02660a2 ffff880150b87b58 ffffffff=
81063240
[ 2913.366034] <0> ffff880154e4df10 0000000154e75000 ffff880157d55f10 ffff8=
801534fc000
[ 2913.366132] <0> 0000000000000001 0000000000014200 ffff880150b87b98 fffff=
fffa022c4cc
[ 2913.366255] Call Trace:
[ 2913.366288]  [<ffffffffa02660a2>] vmx_vcpu_load+0x90/0x1a0 [kvm_intel]
[ 2913.366355]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.366422]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.366490]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.366547]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.366604]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.366663]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.366715]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.366781]  [<ffffffffa023e838>] ? kvm_cpu_has_interrupt+0x3a/0x56 [kvm]
[ 2913.366876]  [<ffffffffa0226057>] kvm_vcpu_block+0x8e/0xa9 [kvm]
[ 2913.366956]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
[ 2913.367029]  [<ffffffffa023125a>] kvm_arch_vcpu_ioctl_run+0x97d/0xc9f [k=
vm]
[ 2913.367104]  [<ffffffffa0231177>] ? kvm_arch_vcpu_ioctl_run+0x89a/0xc9f =
[kvm]
[ 2913.367210]  [<ffffffff814026a5>] ? __mutex_unlock_slowpath+0x111/0x13d
[ 2913.367276]  [<ffffffff810346ec>] ? sub_preempt_count+0x92/0xa5
[ 2913.367341]  [<ffffffffa0225164>] kvm_vcpu_ioctl+0x113/0x4e9 [kvm]
[ 2913.367401]  [<ffffffff814011cf>] ? schedule+0x8a3/0x8f2
[ 2913.367458]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[ 2913.367515]  [<ffffffff810dcffc>] ? fget_light+0xe0/0xf8
[ 2913.367568]  [<ffffffff810dcf6e>] ? fget_light+0x52/0xf8
[ 2913.369987]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[ 2913.372394]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[ 2913.374739] Code: 2f 02 00 85 c0 75 13 ba 01 00 00 00 31 f6 48 c7 c7 bb =
37 22 a0 e8 76 ce e1 e0 c9 c3 55 80 3d 79 2f 02 00 00 48 89 e5 74 02 eb fe =
<0f> 0b 55 48 89 e5 53 48 89 f3 48 83 ec 08 48 8b 87 98 00 00 00=20
[ 2913.380357] RIP  [<ffffffffa0223446>] kvm_handle_fault_on_reboot+0xf/0x1=
1 [kvm]
[ 2913.383084]  RSP <ffff880150b87b18>
[ 2913.397343] ---[ end trace 9564e615f538c7b1 ]---
[ 2913.399336] kvm: enabling virtualization on CPU1
[ 2913.402446] note: qemu-kvm[5912] exited with preempt_count 1
[ 2913.404860] NMI watchdog enabled, takes one hw-pmu counter.
[ 2913.404918] vmwrite error: reg 6c0a value ffff880002650dc0 (err 40177088)
[ 2913.404924] Pid: 5912, comm: qemu-kvm Tainted: G      D     2.6.36-rc3-d=
bg-00144-gb958348-dirty #144
[ 2913.404928] Call Trace:
[ 2913.404937]  [<ffffffffa0263ad5>] vmwrite_error+0x32/0x37 [kvm_intel]
[ 2913.404944]  [<ffffffffa0263af3>] vmcs_writel+0x19/0x1b [kvm_intel]
[ 2913.404951]  [<ffffffffa0266147>] vmx_vcpu_load+0x135/0x1a0 [kvm_intel]
[ 2913.404958]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.404974]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.404985]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.404990]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.404995]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.405002]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.405010]  [<ffffffff811f7c25>] ? do_raw_spin_unlock+0x8f/0x98
[ 2913.405016]  [<ffffffff810363d7>] __cond_resched+0x13/0x1f
[ 2913.405022]  [<ffffffff8103645f>] __cond_resched_lock+0x7c/0x96
[ 2913.405028]  [<ffffffff810ebc4b>] ? __shrink_dcache_sb+0x253/0x2da
[ 2913.405034]  [<ffffffff810eb9f0>] ? d_kill+0x64/0x6c
[ 2913.405039]  [<ffffffff810ebc5c>] __shrink_dcache_sb+0x264/0x2da
[ 2913.405046]  [<ffffffff810ec34b>] shrink_dcache_parent+0x37/0x136
[ 2913.405053]  [<ffffffff811287de>] proc_flush_task+0xb2/0x2b2
[ 2913.405060]  [<ffffffff8103d26d>] release_task+0x7f/0x3ec
[ 2913.405066]  [<ffffffff8103d20e>] ? release_task+0x20/0x3ec
[ 2913.405071]  [<ffffffff8103eb9e>] do_exit+0x659/0x6c4
[ 2913.405079]  [<ffffffff810060b6>] oops_end+0x97/0x9c
[ 2913.405084]  [<ffffffff810061f8>] die+0x55/0x5e
[ 2913.405089]  [<ffffffff810030c4>] do_trap+0x11c/0x12b
[ 2913.405094]  [<ffffffff810032c4>] ? do_invalid_op+0x72/0xa5
[ 2913.405102]  [<ffffffff810032ee>] do_invalid_op+0x9c/0xa5
[ 2913.405119]  [<ffffffffa0223446>] ? kvm_handle_fault_on_reboot+0xf/0x11 =
[kvm]
[ 2913.405130]  [<ffffffff81403601>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2913.405139]  [<ffffffff81404544>] ? irq_return+0x0/0xc
[ 2913.405149]  [<ffffffff81002d1b>] invalid_op+0x1b/0x20
[ 2913.405166]  [<ffffffffa0223446>] ? kvm_handle_fault_on_reboot+0xf/0x11 =
[kvm]
[ 2913.405181]  [<ffffffffa02660a2>] vmx_vcpu_load+0x90/0x1a0 [kvm_intel]
[ 2913.405189]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.405204]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.405215]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.405221]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.405227]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.405234]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.405240]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.405255]  [<ffffffffa023e838>] ? kvm_cpu_has_interrupt+0x3a/0x56 [kvm]
[ 2913.405269]  [<ffffffffa0226057>] kvm_vcpu_block+0x8e/0xa9 [kvm]
[ 2913.405276]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
[ 2913.405292]  [<ffffffffa023125a>] kvm_arch_vcpu_ioctl_run+0x97d/0xc9f [k=
vm]
[ 2913.405306]  [<ffffffffa0231177>] ? kvm_arch_vcpu_ioctl_run+0x89a/0xc9f =
[kvm]
[ 2913.405313]  [<ffffffff814026a5>] ? __mutex_unlock_slowpath+0x111/0x13d
[ 2913.405321]  [<ffffffff810346ec>] ? sub_preempt_count+0x92/0xa5
[ 2913.405334]  [<ffffffffa0225164>] kvm_vcpu_ioctl+0x113/0x4e9 [kvm]
[ 2913.405341]  [<ffffffff814011cf>] ? schedule+0x8a3/0x8f2
[ 2913.405348]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[ 2913.405354]  [<ffffffff810dcffc>] ? fget_light+0xe0/0xf8
[ 2913.405360]  [<ffffffff810dcf6e>] ? fget_light+0x52/0xf8
[ 2913.405366]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[ 2913.405373]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[ 2913.405378] vmwrite error: reg 6c0c value ffff880002644000 (err 40124416)
[ 2913.405384] Pid: 5912, comm: qemu-kvm Tainted: G      D     2.6.36-rc3-d=
bg-00144-gb958348-dirty #144
[ 2913.405388] Call Trace:
[ 2913.405395]  [<ffffffffa0263ad5>] vmwrite_error+0x32/0x37 [kvm_intel]
[ 2913.405402]  [<ffffffffa0263af3>] vmcs_writel+0x19/0x1b [kvm_intel]
[ 2913.405410]  [<ffffffffa0266159>] vmx_vcpu_load+0x147/0x1a0 [kvm_intel]
[ 2913.405417]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.405432]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.405444]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.405450]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.405455]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.405461]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.405469]  [<ffffffff811f7c25>] ? do_raw_spin_unlock+0x8f/0x98
[ 2913.405475]  [<ffffffff810363d7>] __cond_resched+0x13/0x1f
[ 2913.405482]  [<ffffffff8103645f>] __cond_resched_lock+0x7c/0x96
[ 2913.405489]  [<ffffffff810ebc4b>] ? __shrink_dcache_sb+0x253/0x2da
[ 2913.405495]  [<ffffffff810eb9f0>] ? d_kill+0x64/0x6c
[ 2913.405501]  [<ffffffff810ebc5c>] __shrink_dcache_sb+0x264/0x2da
[ 2913.405508]  [<ffffffff810ec34b>] shrink_dcache_parent+0x37/0x136
[ 2913.405515]  [<ffffffff811287de>] proc_flush_task+0xb2/0x2b2
[ 2913.405522]  [<ffffffff8103d26d>] release_task+0x7f/0x3ec
[ 2913.405528]  [<ffffffff8103d20e>] ? release_task+0x20/0x3ec
[ 2913.405534]  [<ffffffff8103eb9e>] do_exit+0x659/0x6c4
[ 2913.405540]  [<ffffffff810060b6>] oops_end+0x97/0x9c
[ 2913.405545]  [<ffffffff810061f8>] die+0x55/0x5e
[ 2913.405550]  [<ffffffff810030c4>] do_trap+0x11c/0x12b
[ 2913.405556]  [<ffffffff810032c4>] ? do_invalid_op+0x72/0xa5
[ 2913.405561]  [<ffffffff810032ee>] do_invalid_op+0x9c/0xa5
[ 2913.405572]  [<ffffffffa0223446>] ? kvm_handle_fault_on_reboot+0xf/0x11 =
[kvm]
[ 2913.405580]  [<ffffffff81403601>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2913.405586]  [<ffffffff81404544>] ? irq_return+0x0/0xc
[ 2913.405592]  [<ffffffff81002d1b>] invalid_op+0x1b/0x20
[ 2913.405603]  [<ffffffffa0223446>] ? kvm_handle_fault_on_reboot+0xf/0x11 =
[kvm]
[ 2913.405612]  [<ffffffffa02660a2>] vmx_vcpu_load+0x90/0x1a0 [kvm_intel]
[ 2913.405618]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.405634]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.405645]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.405651]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.405657]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.405664]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.405670]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.405686]  [<ffffffffa023e838>] ? kvm_cpu_has_interrupt+0x3a/0x56 [kvm]
[ 2913.405699]  [<ffffffffa0226057>] kvm_vcpu_block+0x8e/0xa9 [kvm]
[ 2913.405706]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
[ 2913.405721]  [<ffffffffa023125a>] kvm_arch_vcpu_ioctl_run+0x97d/0xc9f [k=
vm]
[ 2913.405736]  [<ffffffffa0231177>] ? kvm_arch_vcpu_ioctl_run+0x89a/0xc9f =
[kvm]
[ 2913.405743]  [<ffffffff814026a5>] ? __mutex_unlock_slowpath+0x111/0x13d
[ 2913.405750]  [<ffffffff810346ec>] ? sub_preempt_count+0x92/0xa5
[ 2913.405764]  [<ffffffffa0225164>] kvm_vcpu_ioctl+0x113/0x4e9 [kvm]
[ 2913.405773]  [<ffffffff814011cf>] ? schedule+0x8a3/0x8f2
[ 2913.405784]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[ 2913.405793]  [<ffffffff810dcffc>] ? fget_light+0xe0/0xf8
[ 2913.405802]  [<ffffffff810dcf6e>] ? fget_light+0x52/0xf8
[ 2913.405810]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[ 2913.405819]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[ 2913.405828] vmwrite error: reg 6c10 value 0 (err 0)
[ 2913.405834] Pid: 5912, comm: qemu-kvm Tainted: G      D     2.6.36-rc3-d=
bg-00144-gb958348-dirty #144
[ 2913.405839] Call Trace:
[ 2913.405849]  [<ffffffffa0263ad5>] vmwrite_error+0x32/0x37 [kvm_intel]
[ 2913.405861]  [<ffffffffa0263af3>] vmcs_writel+0x19/0x1b [kvm_intel]
[ 2913.405873]  [<ffffffffa0266176>] vmx_vcpu_load+0x164/0x1a0 [kvm_intel]
[ 2913.405895]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.405907]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.405915]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.405921]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.405927]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.405934]  [<ffffffff811f7c25>] ? do_raw_spin_unlock+0x8f/0x98
[ 2913.405941]  [<ffffffff810363d7>] __cond_resched+0x13/0x1f
[ 2913.405948]  [<ffffffff8103645f>] __cond_resched_lock+0x7c/0x96
[ 2913.405955]  [<ffffffff810ebc4b>] ? __shrink_dcache_sb+0x253/0x2da
[ 2913.405961]  [<ffffffff810eb9f0>] ? d_kill+0x64/0x6c
[ 2913.405967]  [<ffffffff810ebc5c>] __shrink_dcache_sb+0x264/0x2da
[ 2913.405973]  [<ffffffff810ec34b>] shrink_dcache_parent+0x37/0x136
[ 2913.405980]  [<ffffffff811287de>] proc_flush_task+0xb2/0x2b2
[ 2913.405986]  [<ffffffff8103d26d>] release_task+0x7f/0x3ec
[ 2913.405992]  [<ffffffff8103d20e>] ? release_task+0x20/0x3ec
[ 2913.405998]  [<ffffffff8103eb9e>] do_exit+0x659/0x6c4
[ 2913.406004]  [<ffffffff810060b6>] oops_end+0x97/0x9c
[ 2913.406009]  [<ffffffff810061f8>] die+0x55/0x5e
[ 2913.406014]  [<ffffffff810030c4>] do_trap+0x11c/0x12b
[ 2913.406019]  [<ffffffff810032c4>] ? do_invalid_op+0x72/0xa5
[ 2913.406026]  [<ffffffff810032ee>] do_invalid_op+0x9c/0xa5
[ 2913.406036]  [<ffffffffa0223446>] ? kvm_handle_fault_on_reboot+0xf/0x11 =
[kvm]
[ 2913.406043]  [<ffffffff81403601>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2913.406050]  [<ffffffff81404544>] ? irq_return+0x0/0xc
[ 2913.406058]  [<ffffffff81002d1b>] invalid_op+0x1b/0x20
[ 2913.406076]  [<ffffffffa0223446>] ? kvm_handle_fault_on_reboot+0xf/0x11 =
[kvm]
[ 2913.406089]  [<ffffffffa02660a2>] vmx_vcpu_load+0x90/0x1a0 [kvm_intel]
[ 2913.406098]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.406121]  [<ffffffffa022c4cc>] kvm_arch_vcpu_load+0x73/0xbb [kvm]
[ 2913.406136]  [<ffffffffa0223cd8>] kvm_sched_in+0xd/0xf [kvm]
[ 2913.406142]  [<ffffffff8102e0d2>] finish_task_switch+0x90/0xd7
[ 2913.406147]  [<ffffffff8102e042>] ? finish_task_switch+0x0/0xd7
[ 2913.406153]  [<ffffffff81401149>] schedule+0x81d/0x8f2
[ 2913.406158]  [<ffffffff81063240>] ? mark_held_locks+0x50/0x72
[ 2913.406173]  [<ffffffffa023e838>] ? kvm_cpu_has_interrupt+0x3a/0x56 [kvm]
[ 2913.406186]  [<ffffffffa0226057>] kvm_vcpu_block+0x8e/0xa9 [kvm]
[ 2913.406191]  [<ffffffff810530d5>] ? autoremove_wake_function+0x0/0x34
[ 2913.406206]  [<ffffffffa023125a>] kvm_arch_vcpu_ioctl_run+0x97d/0xc9f [k=
vm]
[ 2913.406220]  [<ffffffffa0231177>] ? kvm_arch_vcpu_ioctl_run+0x89a/0xc9f =
[kvm]
[ 2913.406226]  [<ffffffff814026a5>] ? __mutex_unlock_slowpath+0x111/0x13d
[ 2913.406233]  [<ffffffff810346ec>] ? sub_preempt_count+0x92/0xa5
[ 2913.406245]  [<ffffffffa0225164>] kvm_vcpu_ioctl+0x113/0x4e9 [kvm]
[ 2913.406250]  [<ffffffff814011cf>] ? schedule+0x8a3/0x8f2
[ 2913.406257]  [<ffffffff810e98c3>] do_vfs_ioctl+0x4c1/0x502
[ 2913.406262]  [<ffffffff810dcffc>] ? fget_light+0xe0/0xf8
[ 2913.406267]  [<ffffffff810dcf6e>] ? fget_light+0x52/0xf8
[ 2913.406273]  [<ffffffff810e9955>] sys_ioctl+0x51/0x74
[ 2913.406279]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b
[ 2913.749804] kvm: disabling virtualization on CPU2
[ 2913.749831] CPU 2 is now offline
[ 2913.751880] lockdep: fixing up alternatives.
[ 2913.753457] Booting Node 0 Processor 2 APIC 0x4
[ 2913.918676] kvm: enabling virtualization on CPU2
[ 2913.920349] NMI watchdog enabled, takes one hw-pmu counter.
[ 2913.922404] coretemp coretemp.2: TjMax is 105 C.
[ 2913.952819] kvm: disabling virtualization on CPU1
[ 2913.953052] CPU 1 is now offline



	Sergey
--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkx7cgsACgkQfKHnntdSXjS6HgQAizKgdVtbAdr3EquuX7bwPcpr
RddL6Yx2K/FHgGRY7ePZDzZtFoUTRhOoZjr/qykFab+nqMtfUNTR5ybMUrEcQlJi
0Zhk+n3emxN64Ill384aEQu4acTKjOyEzRaSwxoHn1aYPO4JkuJObEU9cdOmw875
hGNHDCyn16q+ECkAtqw=
=IpuK
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
