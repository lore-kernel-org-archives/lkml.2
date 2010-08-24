Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0HXJRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:17:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47722 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0HXJRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W3Wzo4Dvmo09UehTX3hh4kjgncxOOBWMK1+lbyxxN7pXdef3xiLoyg+UVhtlNFUaKK
         LE9yxW+LWpZJrVvkYj5wM/RCjjvQ03S/yDSb0JiyrAgwNSnjobQpd3p+HQ2cRwDCMRKR
         sHtLyzMvQLIDMoIK6Lke8HHmE+qo4SSC1nVmM=
Date: Tue, 24 Aug 2010 12:17:35 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: general protection fault: 0000 [#1] PREEMPT SMP
Message-ID: <20100824091735.GB5440@swordfish.minsk.epam.com>
References: <20100813134756.GA5235@swordfish.minsk.epam.com>
 <AANLkTindn3Sdbbv-4vjf+5MO4T_s_1e759Mkf1Mpbuz1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <AANLkTindn3Sdbbv-4vjf+5MO4T_s_1e759Mkf1Mpbuz1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/24/10 17:08), Yong Zhang wrote:
> > Hello,
> >
> > Got this traces today:
> >
> > [ =A0 29.940248] CPU 1 is now offline
> > [ =A0 29.941025] general protection fault: 0000 [#1] PREEMPT SMP
> > [ =A0 29.941103] last sysfs file: /sys/devices/system/cpu/cpu1/online
> > [ =A0 29.941157] CPU 0
> > [ =A0 29.941178] Modules linked in: snd_hwdep snd_hda_codec_atihdmi snd=
_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device battery ac=
 wmi snd_pcm_oss snd_mixer_oss button snd_hda_codec_realtek radeon broadcom=
 snd_hda_intel
> > snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc usbhid hid=
 tg3 libphy psmouse serio_raw evdev ttm drm_kms_helper ehci_hcd sr_mod usbc=
ore cdrom sd_mod ahci libahci
> > [ =A0 29.941679]
> > [ =A0 29.941699] Pid: 5208, comm: bash Not tainted 2.6.36-rc0-git12-079=
21-g60bf26a-dirty #124 Aspire 5741G =A0 =A0/Aspire 5741G
> > [ =A0 29.941792] RIP: 0010:[<ffffffff810640a1>] =A0[<ffffffff810640a1>]=
 __lock_acquire+0x4e9/0x17fd
> > [ =A0 29.941878] RSP: 0018:ffff88015751dbc8 =A0EFLAGS: 00010082
> > [ =A0 29.941926] RAX: 0000000000000001 RBX: ffff880152284920 RCX: 00000=
00000000000
> > [ =A0 29.941988] RDX: dead4ead00000202 RSI: 0000000000000000 RDI: ffff8=
80152284920
> > [ =A0 29.942049] RBP: ffff88015751dca8 R08: 0000000000000002 R09: 00000=
00000000001
> > [ =A0 29.942111] R10: 0000000000000000 R11: 0000000000000005 R12: ffff8=
801504c3f60
> > [ =A0 29.942171] R13: 0000000000000000 R14: 0000000000000000 R15: 00000=
00000000002
> > [ =A0 29.942233] FS: =A000007f53580ca700(0000) GS:ffff880002200000(0000=
) knlGS:0000000000000000
> > [ =A0 29.942303] CS: =A00010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ =A0 29.942353] CR2: 00007fb030079000 CR3: 0000000151b5a000 CR4: 00000=
000000006f0
> > [ =A0 29.942414] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
> > [ =A0 29.942475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000=
00000000400
> > [ =A0 29.942536] Process bash (pid: 5208, threadinfo ffff88015751c000, =
task ffff8801504c3f60)
> > [ =A0 29.942604] Stack:
> > [ =A0 29.942625] =A0ffff8801569a4888 ffff88015751dc48 ffff88015751dcb8 =
ffffffff81132b2a
> > [ =A0 29.942702] <0> ffff8801504c3f60 0000000000000001 ffff880100000000=
 ffffffff8186c0a0
> > [ =A0 29.942789] <0> ffffffff00000000 0000000000000004 ffff8801504c3f60=
 ffff8801504c3f60
> > [ =A0 29.942880] Call Trace:
> > [ =A0 29.942910] =A0[<ffffffff81132b2a>] ? sysfs_deactivate+0x3e/0xec
> > [ =A0 29.942966] =A0[<ffffffff81062ddd>] ? mark_held_locks+0x50/0x72
> > [ =A0 29.943019] =A0[<ffffffff81065893>] lock_acquire+0x97/0xb6
> > [ =A0 29.943072] =A0[<ffffffff8137145b>] ? percpu_counter_hotcpu_callba=
ck+0x3e/0x93
> > [ =A0 29.943136] =A0[<ffffffff81374321>] ? mutex_lock_nested+0x2f3/0x31b
> > [ =A0 29.943192] =A0[<ffffffff81371446>] ? percpu_counter_hotcpu_callba=
ck+0x29/0x93
> > [ =A0 29.943257] =A0[<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x=
60
> > [ =A0 29.943313] =A0[<ffffffff8137145b>] ? percpu_counter_hotcpu_callba=
ck+0x3e/0x93
> > [ =A0 29.943376] =A0[<ffffffff8137145b>] percpu_counter_hotcpu_callback=
+0x3e/0x93
> > [ =A0 29.943441] =A0[<ffffffff81057344>] notifier_call_chain+0x32/0x5e
> > [ =A0 29.943494] =A0[<ffffffff8105738f>] __raw_notifier_call_chain+0x9/=
0xb
> > [ =A0 29.943552] =A0[<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
> > [ =A0 29.943602] =A0[<ffffffff8103c703>] cpu_notify+0xe/0x10
> > [ =A0 29.943649] =A0[<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
> > [ =A0 29.943703] =A0[<ffffffff81362d82>] _cpu_down+0x151/0x206
> > [ =A0 29.943751] =A0[<ffffffff81362ea8>] cpu_down+0x28/0x35
> > [ =A0 29.943798] =A0[<ffffffff8136430d>] store_online+0x27/0x6e
> > [ =A0 29.943850] =A0[<ffffffff812923ab>] sysdev_store+0x1b/0x1d
> > [ =A0 29.943899] =A0[<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
> > [ =A0 29.943955] =A0[<ffffffff810daf92>] vfs_write+0xb0/0x14f
> > [ =A0 29.944003] =A0[<ffffffff810db22e>] sys_write+0x45/0x6c
> > [ =A0 29.944054] =A0[<ffffffff81002002>] system_call_fastpath+0x16/0x1b
> > [ =A0 29.946132] Code: 85 c0 0f 84 a4 12 00 00 be 0b 03 00 00 83 3d 5e =
c4 f5 00 00 0f 85 92 12 00 00 e9 a4 11 00 00 45 31 f6 48 85 d2 0f 84 81 12 =
00 00 <f0> ff 82 98 01 00 00 45 8b 84 24 20 07 00 00 83 3d 79 ce 6a 00
> > [ =A0 29.951109] RIP =A0[<ffffffff810640a1>] __lock_acquire+0x4e9/0x17fd
> > [ =A0 29.953421] =A0RSP <ffff88015751dbc8>
> > [ =A0 29.965605] ---[ end trace 34832156140843b2 ]---
> > [ =A0 29.967758] note: bash[5208] exited with preempt_count 1
> > [ =A0 29.969997] BUG: scheduling while atomic: bash/5208/0x10000002
> > [ =A0 29.972098] INFO: lockdep is turned off.
> > [ =A0 29.974167] Modules linked in: snd_hwdep snd_hda_codec_atihdmi snd=
_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device battery ac=
 wmi snd_pcm_oss snd_mixer_oss button snd_hda_codec_realtek radeon broadcom=
 snd_hda_intel
> > snd_hda_codec snd_pcm snd_timer snd soundcore snd_page_alloc usbhid hid=
 tg3 libphy psmouse serio_raw evdev ttm drm_kms_helper ehci_hcd sr_mod usbc=
ore cdrom sd_mod ahci libahci
> > [ =A0 29.981076] Pid: 5208, comm: bash Tainted: G =A0 =A0 =A0D =A0 =A0 =
2.6.36-rc0-git12-07921-g60bf26a-dirty #124
> > [ =A0 29.983375] Call Trace:
> > [ =A0 29.985672] =A0[<ffffffff8102dd6a>] __schedule_bug+0x72/0x77
> > [ =A0 29.987996] =A0[<ffffffff81372790>] schedule+0xdc/0x8f2
> > [ =A0 29.990342] =A0[<ffffffff810360f9>] __cond_resched+0x13/0x1f
> > [ =A0 29.992607] =A0[<ffffffff813730c5>] _cond_resched+0x29/0x30
> > [ =A0 29.994912] =A0[<ffffffff810bbe97>] unmap_vmas+0x747/0x92b
> > [ =A0 29.997198] =A0[<ffffffff810c15cd>] exit_mmap+0xda/0x184
> > [ =A0 29.999410] =A0[<ffffffff8103888e>] mmput+0x28/0xcf
> > [ =A0 30.001623] =A0[<ffffffff8103cd21>] exit_mm+0x109/0x116
> > [ =A0 30.003791] =A0[<ffffffff81375db0>] ? _raw_spin_unlock_irq+0x55/0x=
59
> > [ =A0 30.005931] =A0[<ffffffff8103e387>] do_exit+0x1fe/0x6c0
> > [ =A0 30.008070] =A0[<ffffffff8103c6a5>] ? kmsg_dump+0x14f/0x16a
> > [ =A0 30.010205] =A0[<ffffffff810060c4>] oops_end+0x8f/0x94
> > [ =A0 30.012285] =A0[<ffffffff81006206>] die+0x55/0x5e
> > [ =A0 30.014369] =A0[<ffffffff8100371c>] do_general_protection+0x135/0x=
13d
> > [ =A0 30.016453] =A0[<ffffffff81376304>] ? irq_return+0x0/0xc
> > [ =A0 30.018546] =A0[<ffffffff813764e5>] general_protection+0x25/0x30
> > [ =A0 30.020643] =A0[<ffffffff810640a1>] ? __lock_acquire+0x4e9/0x17fd
> > [ =A0 30.022719] =A0[<ffffffff81132b2a>] ? sysfs_deactivate+0x3e/0xec
> > [ =A0 30.024804] =A0[<ffffffff81062ddd>] ? mark_held_locks+0x50/0x72
> > [ =A0 30.026883] =A0[<ffffffff81065893>] lock_acquire+0x97/0xb6
> > [ =A0 30.028932] =A0[<ffffffff8137145b>] ? percpu_counter_hotcpu_callba=
ck+0x3e/0x93
> > [ =A0 30.031017] =A0[<ffffffff81374321>] ? mutex_lock_nested+0x2f3/0x31b
> > [ =A0 30.033076] =A0[<ffffffff81371446>] ? percpu_counter_hotcpu_callba=
ck+0x29/0x93
> > [ =A0 30.035171] =A0[<ffffffff8137568d>] _raw_spin_lock_irqsave+0x4e/0x=
60
> > [ =A0 30.037272] =A0[<ffffffff8137145b>] ? percpu_counter_hotcpu_callba=
ck+0x3e/0x93
> > [ =A0 30.039372] =A0[<ffffffff8137145b>] percpu_counter_hotcpu_callback=
+0x3e/0x93
> > [ =A0 30.041515] =A0[<ffffffff81057344>] notifier_call_chain+0x32/0x5e
> > [ =A0 30.043653] =A0[<ffffffff8105738f>] __raw_notifier_call_chain+0x9/=
0xb
> > [ =A0 30.045777] =A0[<ffffffff8103c6e3>] __cpu_notify+0x1b/0x2d
> > [ =A0 30.047927] =A0[<ffffffff8103c703>] cpu_notify+0xe/0x10
> > [ =A0 30.050049] =A0[<ffffffff8103c70e>] cpu_notify_nofail+0x9/0x11
> > [ =A0 30.052172] =A0[<ffffffff81362d82>] _cpu_down+0x151/0x206
> > [ =A0 30.054308] =A0[<ffffffff81362ea8>] cpu_down+0x28/0x35
> > [ =A0 30.056413] =A0[<ffffffff8136430d>] store_online+0x27/0x6e
> > [ =A0 30.058546] =A0[<ffffffff812923ab>] sysdev_store+0x1b/0x1d
> > [ =A0 30.060537] =A0[<ffffffff811321b2>] sysfs_write_file+0x103/0x13f
> > [ =A0 30.062357] =A0[<ffffffff810daf92>] vfs_write+0xb0/0x14f
> > [ =A0 30.064167] =A0[<ffffffff810db22e>] sys_write+0x45/0x6c
> > [ =A0 30.065943] =A0[<ffffffff81002002>] system_call_fastpath+0x16/0x1b
>=20
> Seems this is resolved by commit 602586a8, can you try it?
>=20
> Thanks,
> Yong
>=20

commit 602586a83b719df0fbd94196a1359ed35aeb2df3
Author: Hugh Dickins <hughd@google.com>
Date:   Tue Aug 17 15:23:56 2010 -0700
shmem: put_super must percpu_counter_destroy

Already compiled. Seems to be fixed.=20


	Sergey

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxzji8ACgkQfKHnntdSXjSYYgP+M+uNu64lFX22vtbgRBqW+5C5
YKg+ELPcVwHcpUiWOpF7RorpuMnC2fhPztiW+jyr/xRtgfhSOyv5YAjypwh8tIAS
k/7iXdqaT/Vi39qVoxPmph0sca4Xg5mjQuz2rnIAp5tRKujSj16VNQ2g2gaeguQe
FojhyCpEDX317hC/Upc=
=WOXX
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
