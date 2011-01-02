Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1ABKXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 05:23:12 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:46557 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1ABKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 05:23:10 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jan 2011 05:23:10 EST
Date: Sun, 2 Jan 2011 11:17:21 +0100
From: Nico Schottelius <nico-linux-20101229@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20101229@schottelius.org>
Subject: 2.6.37-rc7: screen black after several suspends
Message-ID: <20110102101721.GA2277@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20101229@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.36-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning guys,

with 2.6.37-rc7 automatic wifi reconnect works, but after several
suspend and resume issues the screen stays black. I am running
Linux on the Lenovo X201, Intel graphics card [0].

Earlier kernel versions (around 2.6.35, iirc) sometimes allowed me
to restore it by switching away from X to the console, which stopped
working broken display (weired characters everywhere) after some time.

With 2.6.37-rc7 this does not work. After about 4-5 suspends the screen
stays black, the machine is still working otherwise (i.e. rebooting
it works fine).

It seems there's a long ongoing problem restoring the display,
seeing it in various forms (including freeze) in at least

  * 2.6.27-rc1-00156-g94ad374,
  * 2.6.28-next-20090107-ikn
  * 2.6.28-ikn-06859-gede6f5a
  * 2.6.28-rc9-wl-ikn-24949-ge98df74
  * 2.6.29-rc4-58-g4c098bc,
  * 2.6.29-rc5-ikn-00168-gba95fd4
  * 2.6.30-rc7
  * 2.6.31-r2
  * many many more, see messages from me to LKML

With some working version (just brighness related):

  * 2.6.29-rc7-wl-ikn-32831-g98c5597
  * 2.6.30-rc3-next-20090428-04067-g72f1b63

I'm wondering whether there=20

  a) is one bug coming up again and not really fixed
  b) are many bugs, just parts fixed
  c) new bugs are introduced quite often

In any case, I downgraded to 2.6.36-ARCH, which works fine related to
brightness and suspend/resume.

Cheers,

Nico


[0] 00:02.0 VGA compatible controller: Intel Corporation Core Processor Int=
egrated Graphics Controller (rev 02).

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk0gULEACgkQ19zI5DGHffApgACgq81AUq68oEZ17R4USAXDM8vT
C6YAoKnO0r1DOMiddyCT3hqS4dOYl8+4
=IJYg
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
