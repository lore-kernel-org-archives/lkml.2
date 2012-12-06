Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423484Ab2LFV1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:27:44 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41638 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2LFV1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:27:43 -0500
Date: Fri, 7 Dec 2012 08:27:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: unusual update of the security tree
Message-Id: <20121207082730.bef9a35c7a75cc433a8a0faf@canb.auug.org.au>
In-Reply-To: <CA+55aFwJDtofV36R_ot8qj31BCGwBgDsGOKRkMRhRLamf5M+mw@mail.gmail.com>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
	<50B5508D.7050409@schaufler-ca.com>
	<20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au>
	<alpine.LRH.2.02.1212070024460.4693@tundra.namei.org>
	<CA+55aFwJDtofV36R_ot8qj31BCGwBgDsGOKRkMRhRLamf5M+mw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Dec_2012_08_27_30_+1100_syqwy+wFdjunepzu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Dec_2012_08_27_30_+1100_syqwy+wFdjunepzu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 6 Dec 2012 08:25:21 -0800 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> Have people pulled that thing into anything else? Because quite
> frankly, I think it's unsalvageable except with a rebase.

So to be explicit, I think you need to do this:

	- tell as many people as possible that you are going to rebase
	  your tree
	- reset your tree back to the point just before you pulled Casey's
	  tree (3f0cc6ae8662).
	- Casey needs to rebase his tree on top of yours
	- then after Casey has tested his tree again you can repull his
	  new tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Dec_2012_08_27_30_+1100_syqwy+wFdjunepzu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQwQ3CAAoJEECxmPOUX5FEVwsP/3cBUSlyPdHmNLFR89uUCkbB
KjxhJsBjlrQZPx/ARubrdrBlwaW1bVn4oSi6PQVTlaUEkyOtxKmuI9yIkakJm45I
Fi23V7TgSBDNO8J2XSohszAhYYo5p4pBwWfRp3ubzh6ptdbBrJzvZJsJ1Th9fcJw
lsc6zu9/rMG/L23sIlCfXYJt1K8rN4v7fVt69zL1xzzrFLju1B9cVetxrmJ55OUe
a4L7B7hmGAh95TR138AslxM3MQZC6ZlOqnrVLEZmDUma/TEUs20BqspS0/11uMvQ
719nsKHwR2HaCBF9Aq3B7/Ekn/5v2FeqnwTzllnzWcqUvwIdw021o7cy54VhdtyT
DkziV+NHxxhM1e3ho9j2GEcaAgt24hDmg6/z/Fe79sYaVv846sHo092ZddBesrV5
OQRarrsIiMPh0cJj1baKD+QFUjDvZPsX5Y1InvHGE0jz1KaEsRHesalim4YmuGnt
utTKxn2GW7LasV1WBcUVVb9UMDaX86P10E/whCj5ffGeEaZ5CNDu3tpidgmWSJQM
RTwc63MUFfk6gDRJ9+qQ4sIJxziPt3fYMBCL5CpBBN6M59SDg2vHZL0Dv7jEBEcr
uVYhD9o9eExvgIf7XcyzrqOWLt6IJVJnt44YHagC0uE/99aQ+DxiqESxtr92xfag
TCiu/rKEh/8eXfKnTPSk
=Mw5l
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Dec_2012_08_27_30_+1100_syqwy+wFdjunepzu--
