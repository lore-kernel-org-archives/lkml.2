Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1JKGkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:40:22 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44763 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1JKGkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:40:20 -0400
Date: Tue, 11 Oct 2011 17:40:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Input tree moved back to kernel.org
Message-Id: <20111011174014.f9e23daea8f8c8526096131a@canb.auug.org.au>
In-Reply-To: <20111011011224.GA11832@core.coreip.homeip.net>
References: <20111011011224.GA11832@core.coreip.homeip.net>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_17_40_14_+1100_gaju+SHAkw8a9v5B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_17_40_14_+1100_gaju+SHAkw8a9v5B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,=20

On Mon, 10 Oct 2011 18:12:24 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.c=
om> wrote:
>
> I have moved input tree back to its original place on kernel.org:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
>=20
> The structure is still the same: 'for-linus' branch for current work and
> 'next' (same as master) branch for the next merge window. I will try
> keeping version on github up to date as well.
>=20
> Stephen, could you please update linux-next once more?

I will switch back tomorrow.

> BTW, does anyone know how one can update project description with
> gitolite?

echo <description> | ssh gitolite@ra.kernel.org setdesc <repo>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_17_40_14_+1100_gaju+SHAkw8a9v5B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk+TOAAoJEECxmPOUX5FE+98QAI3VM7XvWN/l2lWOj9F+NU/J
oSn2bjfeaCuW7jCkt+t6S/QblZEKxo3gHtoyQ037J+R/0451iFlUfxA/phFnc50X
fuOluyMQos2BlwpCSzc+hqE0rNN8pBeidTYix6GvXmibuo8U8dVlOVypWmCu4iJA
hY4AS/ICLxdJ/Q9IQp/xpv82MXzPxb4XJNQFhDXGdodtefVuRByMio3hETmcmAQp
maunNV+ujoqqjK+W/wKuai/F3Aako26wVKOr1+sgaMS87D+ftIYwYf6Nr6BgSJMn
IonL/nSLPsluwluxbQPCT1ErBb2DyJA5w8xldhfLcJk8+o1DnuH7ZnOyGM2kLbAk
bHEGp34zqJ/gNtM9TuS2frUtFhImE8castgmGzu8yEHC+CqAhYFwkkzdoRsGUDxY
hesTS3Uf573jT+x9qtEZxDOYuDR6Qpo2A19eLF0pX/GT+E97qryBgSGTgxzTkQXe
WsaBV6oCBKfZy90zprOT2HSBtc2cH4T9EWWLGbO0pgs9oEzoB8q3/e3dkrOFR5m9
+eqWoTM5Nxeh9OtVjqEo6vaerJH+WCgbbs9TJvzRDge/yov7XT1DkgHl3FfdgpvL
eUkJ83SPw1g6lzu/ZTgVWHdFmaOPE76ZD+rGiUxeCHA6z1toelCfPCluMI7+u131
WzvVLlhZVyp7vNApbsKb
=IYKa
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_17_40_14_+1100_gaju+SHAkw8a9v5B--
