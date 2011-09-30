Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1I3IaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:30:16 -0400
Received: from mailout.selfhost.de ([82.98.82.25]:57293 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755278Ab1I3IaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:30:12 -0400
Message-ID: <4E857E10.3030103@afaics.de>
Date: Fri, 30 Sep 2011 10:30:08 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: rcu_sched_state detected stall on CPU 6
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD20BC627E2267BDDB7836A6E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD20BC627E2267BDDB7836A6E
Content-Type: multipart/mixed;
 boundary="------------010801020203030801000005"

This is a multi-part message in MIME format.
--------------010801020203030801000005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,

I received this for 3.0.4 (amd64) (see attachment for the
complete kern.log).

Sep 30 10:09:03 cecil kernel: [ 9345.593031] INFO: rcu_sched_state detect=
ed stall on CPU 6 (t=3D0 jiffies)
Sep 30 10:09:03 cecil kernel: [ 9345.593035] sending NMI to all CPUs:
Sep 30 10:09:03 cecil kernel: [ 9345.593040] NMI backtrace for cpu 6
Sep 30 10:09:03 cecil kernel: [ 9345.593043] CPU 6
:
:
ep 30 10:09:03 cecil kernel: [ 9345.593194] Call Trace:
Sep 30 10:09:03 cecil kernel: [ 9345.593195]  <IRQ>
Sep 30 10:09:03 cecil kernel: [ 9345.593200]  [<ffffffff810179e2>] ? arch=
_trigger_all_cpu_backtrace+0x59/0x67
Sep 30 10:09:03 cecil kernel: [ 9345.593204]  [<ffffffff81076033>] ? __rc=
u_pending+0x7e/0x337
Sep 30 10:09:03 cecil kernel: [ 9345.593208]  [<ffffffff8105580c>] ? tick=
_nohz_handler+0xcd/0xcd
Sep 30 10:09:03 cecil kernel: [ 9345.593211]  [<ffffffff81076e45>] ? rcu_=
check_callbacks+0xbb/0x10a
Sep 30 10:09:03 cecil kernel: [ 9345.593214]  [<ffffffff8103dea5>] ? upda=
te_process_times+0x31/0x63
Sep 30 10:09:03 cecil kernel: [ 9345.593217]  [<ffffffff81055873>] ? tick=
_sched_timer+0x67/0x8d
Sep 30 10:09:03 cecil kernel: [ 9345.593219]  [<ffffffff8104bec1>] ? __ru=
n_hrtimer.isra.28+0x4f/0xa8
Sep 30 10:09:03 cecil kernel: [ 9345.593222]  [<ffffffff8104c47f>] ? hrti=
mer_interrupt+0xd5/0x1a1
Sep 30 10:09:03 cecil kernel: [ 9345.593225]  [<ffffffff8101701f>] ? smp_=
apic_timer_interrupt+0x7d/0x8f
Sep 30 10:09:03 cecil kernel: [ 9345.593229]  [<ffffffff812ac48e>] ? apic=
_timer_interrupt+0xe/0x20
Sep 30 10:09:03 cecil kernel: [ 9345.593231]  [<ffffffff812ac493>] ? apic=
_timer_interrupt+0x13/0x20
Sep 30 10:09:03 cecil kernel: [ 9345.593232]  <EOI>
Sep 30 10:09:03 cecil kernel: [ 9345.593236]  [<ffffffff81175830>] ? inte=
l_idle+0xd1/0xed
Sep 30 10:09:03 cecil kernel: [ 9345.593239]  [<ffffffff8117580c>] ? inte=
l_idle+0xad/0xed
Sep 30 10:09:03 cecil kernel: [ 9345.593242]  [<ffffffff8120a273>] ? cpui=
dle_idle_call+0x82/0xb9
Sep 30 10:09:03 cecil kernel: [ 9345.593245]  [<ffffffff8100112d>] ? cpu_=
idle+0x4e/0x99
Sep 30 10:09:03 cecil kernel: [ 9345.593246] Code: 0f 1f 84 00 00 00 00 0=
0 48 ff c8 75 fb 48 ff c8 c3 48 8b 05 c8 40 2d 00 ff e0 48 8d 04 bd 00 00=
 00 00 65 48 8b 14 25 98 02 01 00
Sep 30 10:09:03 cecil kernel: [ 9345.593271] Call Trace:
Sep 30 10:09:03 cecil kernel: [ 9345.593272]  <IRQ>  [<ffffffff810179e2>]=
 ? arch_trigger_all_cpu_backtrace+0x59/0x67
Sep 30 10:09:03 cecil kernel: [ 9345.593276]  [<ffffffff81076033>] ? __rc=
u_pending+0x7e/0x337
Sep 30 10:09:03 cecil kernel: [ 9345.593279]  [<ffffffff8105580c>] ? tick=
_nohz_handler+0xcd/0xcd
Sep 30 10:09:03 cecil kernel: [ 9345.593281]  [<ffffffff81076e45>] ? rcu_=
check_callbacks+0xbb/0x10a
Sep 30 10:09:03 cecil kernel: [ 9345.593284]  [<ffffffff8103dea5>] ? upda=
te_process_times+0x31/0x63
Sep 30 10:09:03 cecil kernel: [ 9345.593286]  [<ffffffff81055873>] ? tick=
_sched_timer+0x67/0x8d
Sep 30 10:09:03 cecil kernel: [ 9345.593288]  [<ffffffff8104bec1>] ? __ru=
n_hrtimer.isra.28+0x4f/0xa8
Sep 30 10:09:03 cecil kernel: [ 9345.593291]  [<ffffffff8104c47f>] ? hrti=
mer_interrupt+0xd5/0x1a1
Sep 30 10:09:03 cecil kernel: [ 9345.593293]  [<ffffffff8101701f>] ? smp_=
apic_timer_interrupt+0x7d/0x8f
Sep 30 10:09:03 cecil kernel: [ 9345.593296]  [<ffffffff812ac48e>] ? apic=
_timer_interrupt+0xe/0x20
Sep 30 10:09:03 cecil kernel: [ 9345.593298]  [<ffffffff812ac493>] ? apic=
_timer_interrupt+0x13/0x20
Sep 30 10:09:03 cecil kernel: [ 9345.593300]  <EOI>  [<ffffffff81175830>]=
 ? intel_idle+0xd1/0xed
Sep 30 10:09:03 cecil kernel: [ 9345.593304]  [<ffffffff8117580c>] ? inte=
l_idle+0xad/0xed
Sep 30 10:09:03 cecil kernel: [ 9345.593307]  [<ffffffff8120a273>] ? cpui=
dle_idle_call+0x82/0xb9
Sep 30 10:09:03 cecil kernel: [ 9345.593309]  [<ffffffff8100112d>] ? cpu_=
idle+0x4e/0x99
:

When the problem occured I was running an rsync of some huge
files (>4 GByte each) from one USB device to another. It was
already running for more than 2 hours.

Please mail if I can help to track this down.


Regards

Harri


--------------010801020203030801000005
Content-Type: application/x-tar;
 name="kern.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="kern.log.gz"

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
--------------010801020203030801000005--

--------------enigD20BC627E2267BDDB7836A6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6FfhAACgkQUTlbRTxpHjeKqACeLIRxhpFbYDFPX53tY8BT0U9W
BXwAn0jEpdUJn5/s67jVficINaWhJS4k
=fGXe
-----END PGP SIGNATURE-----

--------------enigD20BC627E2267BDDB7836A6E--
