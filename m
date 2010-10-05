Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab0JEIml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:42:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56363 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0JEImj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:42:39 -0400
Date: Tue, 5 Oct 2010 19:42:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Valdis.Kletnieks@vt.edu, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for October 5
Message-Id: <20101005194232.de733b2b.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikF+-0ybP3RMA-7wr8DMit6At=G1W7oB0UO4Mvz@mail.gmail.com>
References: <20101005161220.0bef433f.sfr@canb.auug.org.au>
	<AANLkTikF+-0ybP3RMA-7wr8DMit6At=G1W7oB0UO4Mvz@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Oct_2010_19_42_32_+1100_evqXAoM7MXNoxLx."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Oct_2010_19_42_32_+1100_evqXAoM7MXNoxLx.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 5 Oct 2010 09:38:49 +0200 Zimny Lech <napohybelskurwysynom2010@gmai=
l.com> wrote:
>
> Also, I saw this
> /home/test/linux-2.6/include/linux/fs.h:1274:20: warning: function
> declaration isn't a prototype
> /home/test/linux-2.6/include/linux/fs.h:1278:20: warning: function
> declaration isn't a prototype
>=20
> It was fixed in -mmotm by Valdis Kletnieks.

Yeah, it was fixed in linux-next, but rebroken by a rebase of the bkl-vfs
tree since yesterday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Oct_2010_19_42_32_+1100_evqXAoM7MXNoxLx.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMquT4AAoJEDMEi1NhKgbsBuIH/RCeFEsWrmgTFKQlerPNUZVa
vcKeonyYt+O3V+vzy52SZy3xFmNg4IO3haILsQ7WAutx5cBOnik1x5P0wCfyaEhZ
R39j/4CL9Kjnxp/SqvBiRWtIv2dzVmiR1mXK7AzCBZtHN9SbDVFB61e118uBuijX
XqVrWUyk4th5GERPFujDrn0C6pgJXjG1u7ktVVs7F/d0Ii2aIRPX8DzsWee96BJB
AXeX9sdNZo7B7XdIEWIdYeRRiLFn/8MpebABdO3VRzyKwmzOoA6DnN/vT1Rb7BI4
WUWROjAmiZ46Eub9t0GmzATnupZqkTytmoAaDvvthWPKIASLAs6mAWrmUAS2gho=
=z3mq
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Oct_2010_19_42_32_+1100_evqXAoM7MXNoxLx.--
