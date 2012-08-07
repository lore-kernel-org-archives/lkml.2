Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2HGSup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:50:45 -0400
Received: from latitanza.investici.org ([82.94.249.234]:65263 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2HGSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:50:43 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 latitanza.investici.org 47E92981BD
Date: Tue, 7 Aug 2012 20:50:36 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: [PATCH] batman-adv: Fix mem leak in the batadv_tt_local_event()
 function
Message-ID: <20120807185036.GG3891@ritirata.org>
References: <alpine.LNX.2.00.1208072030500.3227@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208072030500.3227@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 07, 2012 at 08:32:34PM +0200, Jesper Juhl wrote:
> Memory is allocated for 'tt_change_node' with kmalloc().
> 'tt_change_node' may go out of scope really being used for anything
> (except have a few members initialized) if we hit the 'del:' label.
> This patch makes sure we free the memory in that case.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Antonio Quartulli <ordex@autistici.org>


Thank you very much Jepser!


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAhY3wACgkQpGgxIkP9cwdFfwCeLDF4mxfR3nqQFSugsswE1ABb
pfoAn1pozRGK5vdweqEYCEq63VXelh37
=QOsH
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
