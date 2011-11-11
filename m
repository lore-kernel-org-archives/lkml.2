Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1KKWad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 17:30:33 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:51329 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1KKWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 17:30:32 -0500
Date: Fri, 11 Nov 2011 23:30:18 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: i915 screen corruption
Message-ID: <20111111233018.629c864b@x220>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b41QxSY.i5KlrW/w70_5baZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b41QxSY.i5KlrW/w70_5baZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On a Lenovo Thinkpad X220 with Gen6 (SNB) integrated graphics, I occasional=
ly
get screen corruption under X. Every time this happens I'm seeing the
following in dmesg. This is a vanilla Linux 3.1 kernel.

Cheers,

	- Udo

------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/i915_drv.c:387 __gen6_gt_wait_for_fifo+0x6=
3/0x6e()
Hardware name: 4290W4H
Pid: 1671, comm: X Not tainted 3.1.0 #1
Call Trace:
 [<ffffffff81036028>] ? warn_slowpath_common+0x73/0x87
 [<ffffffff811efe99>] ? __gen6_gt_wait_for_fifo+0x63/0x6e
 [<ffffffff81223835>] ? gen6_ring_put_irq+0x66/0xa6
 [<ffffffff8120001c>] ? i915_wait_request+0x2e0/0x3b9
 [<ffffffff812250ea>] ? render_ring_flush+0xa1/0xac =20
 [<ffffffff8104bdd1>] ? abort_exclusive_wait+0x79/0x79
 [<ffffffff8120014e>] ? i915_gem_flush_ring+0x24/0xdc=20
 [<ffffffff812053f0>] ? i915_gem_do_execbuffer.clone.8+0xd7b/0x11cf
 [<ffffffff81205ccf>] ? i915_gem_execbuffer2+0x12b/0x1ac
 [<ffffffff811dfbb6>] ? drm_ioctl+0x251/0x306
 [<ffffffff81205ba4>] ? i915_gem_execbuffer+0x360/0x360
 [<ffffffff81008734>] ? init_fpu+0x10b/0x124
 [<ffffffff81008b38>] ? check_for_xstate+0x1c/0x71
 [<ffffffff810b1761>] ? do_vfs_ioctl+0x404/0x445 =20
 [<ffffffff81001b25>] ? sys_rt_sigreturn+0x196/0x1c5
 [<ffffffff810b17de>] ? sys_ioctl+0x3c/0x5e
 [<ffffffff813c1bfb>] ? system_call_fastpath+0x16/0x1b
---[ end trace 63d59cd44de45e89 ]---

--Sig_/b41QxSY.i5KlrW/w70_5baZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk69ofoACgkQnhRzXSM7nSmgpACbBzEA2HgnS923/26Ql+0MLeqb
krIAn1VbPikJD7db/LV0MdjPtUfxP/m+
=GmFM
-----END PGP SIGNATURE-----

--Sig_/b41QxSY.i5KlrW/w70_5baZ--
