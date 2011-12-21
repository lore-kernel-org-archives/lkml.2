Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1LVAY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:24:57 -0500
Received: from home.keithp.com ([63.227.221.253]:48581 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab1LVAY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:24:56 -0500
From: Keith Packard <keithp@keithp.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
In-Reply-To: <20111221222626.0b8c3a30@x220.fritz.box>
References: <20111221195410.5e4c065a@x220.fritz.box> <864nwty9sq.fsf@sumi.keithp.com> <20111221222626.0b8c3a30@x220.fritz.box>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 21 Dec 2011 14:55:07 -0800
Message-ID: <861urxy1pw.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Dec 2011 22:26:26 +0100, Udo Steinberg <udo@hypervisor.org> wrot=
e:

> That makes the problem go away. If you need more help tracking down the
> problem, then let me know. I can reproduce it fairly easily with something
> as simple as:
>=20
> 	while true; do dmesg; done

Are you using SNA?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvJjzDYtFsjWk68qAQh/lBAAp2CEMkbjnxcSPkhSBWJCD9CaMxfCyTpe
em0BD+GGBrZBft/CVHEX8KPTEgvaprqpYwlRkiaFT2nB8899VenvqPGiKUa7pDLW
gBWTewMjTqGcoln0/E1YV2cdilzgGYXCgldl8eQnmqoGnpTKO64Z7YXfMrnGRAYT
oCLPIrCZtRLPR6w/Y8tpYgMnMQtoRCbWvr6lqMsXMgR6LHYqhBgzehUmuvJoEKFO
HILEpk9Ufpf8Qlx2xiGHimI3D+UFksHVYB455qlySr4SVIvA53uLL9UFL21XmmTk
JTMvijs2B9cKNWnng0Q9eHa1uylCoEpxVqVPFBLsP5hnfoWDQWTvwSZ4jZr5s1EA
wofBk5WjLn8cFoa0YFJRDwBhHSUPqdTwXE5RhLnin/urCYjzkGMqEFsjw69/6GJS
6KM+64V6O5N6E5i+SoEfKVi1mQZ5z7VmKT5A81JnPge5EBjEq2p8/hE4cbwHcLjX
D6ZAoicAdf+y4Lt0Z43SsTFisaUtcaqYKRdPpVHaew82aBn29YhpAY2JixDXRnSC
gCkNRQQjpTljGCcncEhyKUaZ73Q61wQKnkUGHd9wUpZnLNMHqe/EGjQCvP6FXTk/
ZW6bQknI0h1udxyMlJpI6cZyQaPC4ZJQCqcDbDVuZNZMz5HCkMEa9MGabma/FkR9
RwtyCm0rXBg=
=+RdQ
-----END PGP SIGNATURE-----
--=-=-=--
