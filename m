Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946009Ab2JYNk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:40:26 -0400
Received: from mail.southpole.se ([193.12.106.18]:51292 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945939Ab2JYNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:40:23 -0400
Message-ID: <1351172416.6232.70.camel@jerome.southpole.se>
Subject: Re: [PATCH] asm-generic/io.h: remove asm/cacheflush.h include
From: Jonas Bonn <jonas@southpole.se>
To: James Hogan <james.hogan@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-xtensa@linux-xtensa.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Date: Thu, 25 Oct 2012 15:40:16 +0200
In-Reply-To: <1350984117-17369-1-git-send-email-james.hogan@imgtec.com>
References: <1350984117-17369-1-git-send-email-james.hogan@imgtec.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-DroHWeIpZkq/HMR3Q1UU"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 72417-10120
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DroHWeIpZkq/HMR3Q1UU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-23 at 10:21 +0100, James Hogan wrote:
> Including <asm/cacheflush.h> from <asm-generic/io.h> prevents
> cacheflush.h being able to use I/O functions like readl and writel due
> to circular include dependencies. It doesn't appear as if anything from
> cacheflush.h is actually used by the generic io.h, so remove the
> include.
>=20
> I've compile tested a defconfig compilation of blackfin, openrisc (which
> needed <asm/pgtable.h> including from it's <asm/io.h> to get the PAGE_*
> definitions), and xtensa.
>=20
> Other architectures which use asm-generic/io.h are score and unicore32,
> and looking at their io.h I don't see any obvious problems.

Acked-by: Jonas Bonn <jonas@southpole.se> for OpenRISC

Who's tree should this go via.  I can take it via the openrisc tree, but
it would be good to get some Ack's that this isn't going to break things
for the other arch's (in particular score and unicore32, since they are
untested).

/Jonas

--=-DroHWeIpZkq/HMR3Q1UU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCJQUAACgkQ70gcjN2673Mg9ACgj7RYv/dyPk9S9zHc+g4dSAhL
KpIAn0413qPWwD42ZyDGpMBjlY5nzmxf
=i/LT
-----END PGP SIGNATURE-----

--=-DroHWeIpZkq/HMR3Q1UU--

