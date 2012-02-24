Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2BXQuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:50:16 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43702 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756067Ab2BXQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:50:14 -0500
Date: Fri, 24 Feb 2012 08:50:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: only enable pci realloc when SRIOV bar is not
 assigned
Message-ID: <20120224085005.59f55ff5@jbarnes-desktop>
In-Reply-To: <1330053812-10316-5-git-send-email-yinghai@kernel.org>
References: <1330053812-10316-1-git-send-email-yinghai@kernel.org>
	<1330053812-10316-5-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PnU5VxREw/7_ZbBdQgSyv7_"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PnU5VxREw/7_ZbBdQgSyv7_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 19:23:32 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> If bios does not assign those BAR or wrong address, then kernel will
> try to do pci realloc.
>=20
> in that case, user still can use pci=3Drealloc=3Doff to override it.
>=20
> -v2: According to Jesse, adding one CONFIG option for distribution to
>      disable it or enable it.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

Ok applied these, thanks for the cleanups Yinghai.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/PnU5VxREw/7_ZbBdQgSyv7_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR7+9AAoJEIEoDkX4Qk9hrr0P/0ipSQ9Ep+2NIphBSDrT65Nw
We5u0JcKnJGZRolacgm5cwYHseOw0rF6AkYN3Pqiw7PNE3B7bmUBxu4ENGZf2gNE
+0GAVOCXqkrTQ1N4BXn73vsId1RMVZlVXN8NVAYJM8Rtjb7VUOBz0hTNqOHnoNwh
XCyJP3D0OmCxBIhglD3tdnSxBCaqsl8ZdOl6fi5J0I7Dv8xSbSun2av5lRMNrfkG
CrD85j0xdea1B37tBk1NWZ47RD+5pXEgsZ7LP3aWA8hQL3LhEZi+UU1ldRaAixuy
QBqIjZlMKD9upGiDV7Ibt1lhWQjjP/VuSfQ9g8vHsv77OyX/SIrUPxv0pl8KaxsF
2s0oMhHYuLE1K45pfbZeMm7Dk3byhNJh0y2aYf0fq8MoiyYml3cM8KBodhtOR4FH
TyDnGTTyLJnB4X14sxtDR50l5ji5oIKN2jloC0geWWVyhas4QEPC90AMMO7fbqYD
4OTUipi99n6tGOz+r80KJbI9waxbVz/HU7zKvn3aVBWL9i69vgwM5+7XdXHGwvgf
476+/1Jn6RkuswUycXkjwAclxRgofCYfX6xwUeNsC4X1d8SIp86gTEbOTLA9XKkV
MNgA3GZjsp7nWfcwZ+Uiy7Wy/3DbDRaxJSyBtkR2BMS0elS6LHaKcx93aWJqmryu
9NJU8dgM0731CGbQ4mHt
=oWc0
-----END PGP SIGNATURE-----

--Sig_/PnU5VxREw/7_ZbBdQgSyv7_--
