Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0I2LEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:04:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58126 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751412Ab0I2LEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:04:41 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18AwPcgx7sA7JUtc2TAGhKHxfnSxX4v3u7HEW1007
	yynIEduELPUwhK
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Fwd: i915  blocked for more than 120 seconds.
Date: Wed, 29 Sep 2010 13:04:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_H1xoM8odydHBkot"
Message-Id: <201009291304.39255.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_H1xoM8odydHBkot
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=46orget to Cc: the kernel list.

=2D-=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--Boundary-00=_H1xoM8odydHBkot
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>: i915  blocked for more than 120 seconds.
Content-Disposition: inline

From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: dri-devel@lists.freedesktop.org
Subject: i915  blocked for more than 120 seconds.
Date: Wed, 29 Sep 2010 11:36:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201009291136.23043.toralf.foerster@gmx.de>

Hello,

today I run at the latest 2.6.35.6 kernel few apps like Lotus Notes under w=
ine, amarok and firefox
and in parallel a "git bisect" when I got this :

n22 ~ # grep 2010-09-29T11:21 /var/log/messages | grep kernel
2010-09-29T11:21:36.984+02:00 n22 kernel: INFO: task i915:868 blocked for m=
ore than 120 seconds.
2010-09-29T11:21:36.984+02:00 n22 kernel: "echo 0 > /proc/sys/kernel/hung_t=
ask_timeout_secs" disables this message.
2010-09-29T11:21:36.984+02:00 n22 kernel: i915          D ffa47280     0   =
868      2 0x00000000
2010-09-29T11:21:36.984+02:00 n22 kernel: f5d0ff1c 00000046 000112be ffa472=
80 f53f0064 0ec0c353 00000532 f723b804
2010-09-29T11:21:36.984+02:00 n22 kernel: c2406b40 0000118d 00000000 c13b7b=
00 0ec0b1c6 00000532 c13b1000 c13b1000
2010-09-29T11:21:36.984+02:00 n22 kernel: c13b7b00 c13b7b00 f6384030 f63840=
30 f5d0ff6c c123c6f1 1ddceea9 0000164f
2010-09-29T11:21:36.984+02:00 n22 kernel: Call Trace:
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c123c6f1>] ? schedule+0x211/0x7=
80
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c123d5c0>] __mutex_lock_slowpat=
h+0xd0/0x130
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c123d980>] mutex_lock+0x20/0x40
2010-09-29T11:21:36.984+02:00 n22 kernel: [<f8a88508>] i915_gem_retire_work=
_handler+0x28/0xc0 [i915]
2010-09-29T11:21:36.984+02:00 n22 kernel: [<f8a884e0>] ? i915_gem_retire_wo=
rk_handler+0x0/0xc0 [i915]
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c10441af>] worker_thread+0xef/0=
x1b0
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c102e6ab>] ? default_wake_funct=
ion+0xb/0x10
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c1047bd0>] ? autoremove_wake_fu=
nction+0x0/0x40
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c10440c0>] ? worker_thread+0x0/=
0x1b0
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c1047864>] kthread+0x74/0x80
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c10477f0>] ? kthread+0x0/0x80
2010-09-29T11:21:36.984+02:00 n22 kernel: [<c10032be>] kernel_thread_helper=
+0x6/0x18
2010-09-29T11:21:36.984+02:00 n22 kernel: INFO: task X:12082 blocked for mo=
re than 120 seconds.
2010-09-29T11:21:36.985+02:00 n22 kernel: "echo 0 > /proc/sys/kernel/hung_t=
ask_timeout_secs" disables this message.
2010-09-29T11:21:36.985+02:00 n22 kernel: X             D c11cf5a4     0 12=
082  12029 0x00400004
2010-09-29T11:21:36.985+02:00 n22 kernel: f5fc7dd0 00203082 f5fc7db0 c11cf5=
a4 ffffffff f2e0157c 00000531 00000000
2010-09-29T11:21:36.985+02:00 n22 kernel: 000004d0 000382ff 00000000 c13b7b=
00 f2dc927d 00000531 c13b1000 c13b1000
2010-09-29T11:21:36.985+02:00 n22 kernel: c13b7b00 c13b7b00 f516dba0 f5fc7d=
c4 c11d26e8 00000020 c3680c80 00000020
2010-09-29T11:21:36.985+02:00 n22 kernel: Call Trace:
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c11cf5a4>] ? sock_alloc_send_ps=
kb+0x164/0x2a0
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c11d26e8>] ? skb_queue_tail+0x3=
8/0x50
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c123d5c0>] __mutex_lock_slowpat=
h+0xd0/0x130
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c123d980>] mutex_lock+0x20/0x40
2010-09-29T11:21:36.985+02:00 n22 kernel: [<f8a8843b>] i915_gem_throttle_io=
ctl+0x2b/0x80 [i915]
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c11cb3f3>] ? sock_aio_write+0x1=
13/0x140
2010-09-29T11:21:36.985+02:00 n22 kernel: [<f89ea08b>] drm_ioctl+0x1ab/0x43=
0 [drm]
2010-09-29T11:21:36.985+02:00 n22 kernel: [<f8a88410>] ? i915_gem_throttle_=
ioctl+0x0/0x80 [i915]
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c10a2045>] ? do_sync_readv_writ=
ev+0x95/0xd0
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c10a1eb2>] ? rw_copy_check_uvec=
tor+0x52/0x100
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c10af03d>] vfs_ioctl+0x2d/0xc0
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c10a27c1>] ? do_readv_writev+0x=
141/0x1b0
2010-09-29T11:21:36.985+02:00 n22 kernel: [<f89e9ee0>] ? drm_ioctl+0x0/0x43=
0 [drm]
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c10af21a>] do_vfs_ioctl+0x6a/0x=
590
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c104bac3>] ? hrtimer_try_to_can=
cel+0x33/0x80
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c1036efd>] ? do_setitimer+0xad/=
0x1a0
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c112c6e8>] ? _copy_from_user+0x=
38/0x130
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c103703c>] ? sys_setitimer+0x4c=
/0xa0
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c10af779>] sys_ioctl+0x39/0x60
2010-09-29T11:21:36.985+02:00 n22 kernel: [<c1002d97>] sysenter_do_call+0x1=
2/0x26

The ThinkPad T400 hang completey and I had to use the magic SysRq+B key to =
reboot the system.
Is this a known problem ?

=2D-=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--Boundary-00=_H1xoM8odydHBkot--
