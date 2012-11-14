Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423425Ab2KNVBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:01:43 -0500
Received: from nn7.de ([85.214.94.156]:36855 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422629Ab2KNVBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:01:41 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2012 16:01:40 EST
Message-ID: <1352926496.30504.2.camel@no>
Subject: slab error in verify_redzone_free(): cache `radix_tree_node':
 memory outside object was overwritten
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 14 Nov 2012 21:54:56 +0100
Organization: 
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-IX2ky2wGbMqib8svTAt1"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IX2ky2wGbMqib8svTAt1
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi there!

I am on a core i7 system bl67 intel board and it all keeps oopsing on
me. On 3.2.33 I get on 3.6.6 I get rcu errors (though rcu stress test
didn't show anything) or traces that include cpuidle / apic.

Does anyone have an idea what that could be? The system is just running
a plain console and some disk i/o is going on all the time.

Thanks,
Soeren

slab error in verify_redzone_free(): cache `radix_tree_node': memory outsid=
e object was overwritten
Pid: 0, comm: swapper/3 Not tainted 3.2.33 #1
Call Trace:
 <IRQ>  [<ffffffff8112554b>] ? __slab_error.isra.53+0x1b/0x30
 [<ffffffff811257de>] ? cache_free_debugcheck+0x27e/0x280
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81125ecb>] ? kmem_cache_free+0x5b/0x1e0
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81094a15>] ? __do_softirq+0x95/0x120
 [<ffffffff81058118>] ? lapic_next_event+0x18/0x20
 [<ffffffff810b873f>] ? clockevents_program_event+0x6f/0x110
 [<ffffffff8169ba6c>] ? call_softirq+0x1c/0x30
 [<ffffffff8103e725>] ? do_softirq+0x65/0xa0
 [<ffffffff81094dbe>] ? irq_exit+0x8e/0xb0
 [<ffffffff810587d8>] ? smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff8169aede>] ? apic_timer_interrupt+0x6e/0x80
 <EOI>  [<ffffffff813c2aed>] ? intel_idle+0xed/0x160
 [<ffffffff813c2acb>] ? intel_idle+0xcb/0x160
 [<ffffffff815a473b>] ? cpuidle_idle_call+0x8b/0x100
 [<ffffffff8103b18a>] ? cpu_idle+0x6a/0xf0
ffff8801ba9366d8: redzone 1:0xd84156c5635688c0, redzone 2:0xf14156c5635688c=
0.
slab error in verify_redzone_free(): cache `radix_tree_node': memory outsid=
e object was overwritten
Pid: 16, comm: ksoftirqd/3 Not tainted 3.2.33 #1
Call Trace:
 [<ffffffff8112554b>] ? __slab_error.isra.53+0x1b/0x30
 [<ffffffff811257de>] ? cache_free_debugcheck+0x27e/0x280
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81125ecb>] ? kmem_cache_free+0x5b/0x1e0
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81094a15>] ? __do_softirq+0x95/0x120
 [<ffffffff81094baa>] ? run_ksoftirqd+0x10a/0x230
 [<ffffffff81094aa0>] ? __do_softirq+0x120/0x120
 [<ffffffff81094aa0>] ? __do_softirq+0x120/0x120
 [<ffffffff810aa16e>] ? kthread+0x7e/0x90
 [<ffffffff8169b974>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810aa0f0>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff8169b970>] ? gs_change+0x13/0x13
ffff8801ba936248: redzone 1:0xd84156c5635688c0, redzone 2:0x964156c5635688c=
0.
slab error in verify_redzone_free(): cache `radix_tree_node': memory outsid=
e object was overwritten
Pid: 0, comm: swapper/3 Not tainted 3.2.33 #1
Call Trace:
 <IRQ>  [<ffffffff8112554b>] ? __slab_error.isra.53+0x1b/0x30
 [<ffffffff811257de>] ? cache_free_debugcheck+0x27e/0x280
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81125ecb>] ? kmem_cache_free+0x5b/0x1e0
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81094a15>] ? __do_softirq+0x95/0x120
 [<ffffffff81058118>] ? lapic_next_event+0x18/0x20
 [<ffffffff810b873f>] ? clockevents_program_event+0x6f/0x110
 [<ffffffff8169ba6c>] ? call_softirq+0x1c/0x30
 [<ffffffff8103e725>] ? do_softirq+0x65/0xa0
 [<ffffffff81094dbe>] ? irq_exit+0x8e/0xb0
 [<ffffffff810587d8>] ? smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff8169aede>] ? apic_timer_interrupt+0x6e/0x80
 <EOI>  [<ffffffff813c2aed>] ? intel_idle+0xed/0x160
 [<ffffffff813c2acb>] ? intel_idle+0xcb/0x160
 [<ffffffff815a473b>] ? cpuidle_idle_call+0x8b/0x100
 [<ffffffff8103b18a>] ? cpu_idle+0x6a/0xf0
ffff8801ba9366d8: redzone 1:0xd84156c5635688c0, redzone 2:0xf04156c5635688c=
0.
slab error in verify_redzone_free(): cache `radix_tree_node': memory outsid=
e object was overwritten
Pid: 0, comm: swapper/3 Not tainted 3.2.33 #1
Call Trace:
 <IRQ>  [<ffffffff8112554b>] ? __slab_error.isra.53+0x1b/0x30
 [<ffffffff811257de>] ? cache_free_debugcheck+0x27e/0x280
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81125ecb>] ? kmem_cache_free+0x5b/0x1e0
 [<ffffffff810df2a4>] ? __rcu_process_callbacks+0x174/0x390
 [<ffffffff81094a15>] ? __do_softirq+0x95/0x120
 [<ffffffff81058118>] ? lapic_next_event+0x18/0x20
 [<ffffffff810b873f>] ? clockevents_program_event+0x6f/0x110
 [<ffffffff8169ba6c>] ? call_softirq+0x1c/0x30
 [<ffffffff8103e725>] ? do_softirq+0x65/0xa0
 [<ffffffff81094dbe>] ? irq_exit+0x8e/0xb0
 [<ffffffff810587d8>] ? smp_apic_timer_interrupt+0x68/0xa0
 [<ffffffff8169aede>] ? apic_timer_interrupt+0x6e/0x80
 <EOI>  [<ffffffff813c2aed>] ? intel_idle+0xed/0x160
 [<ffffffff813c2acb>] ? intel_idle+0xcb/0x160
 [<ffffffff815a473b>] ? cpuidle_idle_call+0x8b/0x100
 [<ffffffff8103b18a>] ? cpu_idle+0x6a/0xf0
ffff8801ba936248: redzone 1:0xd84156c5635688c0, redzone 2:0x964156c5635688c=
0.
Slab corruption: radix_tree_node start=3Dffff8801ba936b70, len=3D560
Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
Last user: [<ffffffff810df2a4>](__rcu_process_callbacks+0x174/0x390)
090: 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b 6b 6b 6b 6b 00  kkkkkkk.kkkkkkk.
0a0: 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b 6b 6b 6b 6b 00  kkkkkkk.kkkkkkk.
0b0: 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b 6b 6b 6b 6b 00  kkkkkkk.kkkkkkk.
0c0: 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b 6b 6b 6b 6b 00  kkkkkkk.kkkkkkk.
Prev obj: start=3Dffff8801ba936928, len=3D560
Redzone: 0xfd4156c5635688c0/0xd84156c5635688c0.
Last user: [<ffffffff813775d6>](radix_tree_preload+0x66/0xf0)
000: 01 00 00 00 00 00 00 3c 00 00 00 00 00 00 00 b8  .......<........
010: 00 00 00 00 00 00 00 19 00 00 00 00 00 00 00 00  ................
Next obj: start=3Dffff8801ba936db8, len=3D560
Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
Last user: [<ffffffff813775d6>](radix_tree_preload+0x66/0xf0)
000: 01 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00  ....@...........
010: 00 00 00 00 00 00 00 00 08 96 1a 0c 00 ea ff ff  ................

--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-IX2ky2wGbMqib8svTAt1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJQpAUgAAoJEH82z1Wqh6p3SZoP/39IBXvsP3g/r0lACHWcda36
Be5LnzTQKUVDF+RYPwFGe5sgjD8857qICjbgLP7sfXB3Ev8x+ZJSAJvl3w05htn+
Wnl4AHmdBuEUvmfoBdZOzNmA4aDvb90MilD0GUVJRcDmjq5FIpQ6uKgHDwumO+ZW
RUbNTkO1+YZ0+IK4mRtg+pf11XFFMYR6+BaRrr08mDRqI7yKktK4vbI8Brfj3wM6
JN0BlpWOlAyy+tOxQK8btpQPtBlANBES0HdI/W82ji4I8ZtWZrW93ayciedjNnXc
mYe0ISbzUaZwuys+aWnYr5j0Ng4A3E2P7jnvFYM9616ZjFW7zcZzSVJq3raPgWua
ggw09CaHzP5TwSTKUExhHt4tcDX2Gq7fG7VqOmH/StGF+5hC1jEg0Vgc0J86Ayvz
iNnQ00PScbDaGxIUNW3s/Nl7iIXAhHAanfCPweBk7f/KwMfxR7dvopbTqPIHnCtg
dXiqzSkCpn3WSsA4Vn5fh8MEigd+7buHU5jvJRwz3lXa5aLVm+2U/5YRJJSlhfQS
LTGlkU87NHXW7DKpNv3h5Nn977Cp3QKM/cBM/AfLEDLf0lKEnT5QTfWrjQpBRMnP
AQtSj1VJumxMQ61ZeVI0D2v7rA90sEuIxNCnUQ1rz+efCx2krN/US6d+X4g4SiNg
BigXRe7zetunrvSTIA4A
=io2U
-----END PGP SIGNATURE-----

--=-IX2ky2wGbMqib8svTAt1--
