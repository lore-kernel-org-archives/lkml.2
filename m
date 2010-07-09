Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab0GIRDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:03:31 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:46592 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0GIRDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:03:30 -0400
Date: Fri, 9 Jul 2010 19:04:32 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-linux-20100709@schottelius.org>
Subject: 2.6.35-rc4 / X201 issues
Message-ID: <20100709170432.GA7691@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc4 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good evening hackers,

latest report from 2.6.35-rc4 on X201:

  - (almost) everytime I close and reopen the lid, the image is screwed up
    - switching to vt1 (away from xorg) and back to vt7 fixes that almost a=
lways
    - did not happen on 2.6.34 (iirc)
  - if it's not screwed up, the system is frozen
    - does not react on ping, last image is displayed, no keyboard shortcut=
 works
    - ATTENTION: it's *NOT* needed to suspend directly before to get a free=
ze!
      - simplying closing & opening the lid is enough
  - on freeze, JFS screws up many (open?) files:
    - .viminfo contains stuff from other files / memory?
    - branch of git is damaged:
      [18:46] kr:ceofhack% cat .git/refs/heads/ceof-crypto
      --- !ruby/object:RDoc::RI::MethodDescript%
  - netdev notification for carrier change still broken (see previous repor=
ts)

The first two could probably also be xorg related, though in theory an appl=
ication
shouldn't be able to freeze the kernel... (yeah, know that xorg is "special=
" here).

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw3VqAACgkQ19zI5DGHffDpJQCfWNAr6trvdM5zDTSL5c5YLZAZ
COIAoJhVXYDwVthtShGFL1GsOxkjIr99
=F6C1
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
