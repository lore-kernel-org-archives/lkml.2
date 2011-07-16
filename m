Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1GPQBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 12:01:15 -0400
Received: from mail.southpole.se ([193.12.106.18]:34232 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1GPQBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 12:01:12 -0400
Subject: Re: linux-next: manual merge of the rr tree with the openrisc tree
From: Jonas Bonn <jonas@southpole.se>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110716181723.08d5a7b96cca094dee74f825@canb.auug.org.au>
References: <20110716181723.08d5a7b96cca094dee74f825@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BftSC4ePodWVm8672H8F"
Organization: South Pole Consulting AB
Date: Sat, 16 Jul 2011 18:01:08 +0200
Message-ID: <1310832068.14168.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-BftSC4ePodWVm8672H8F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-07-16 at 18:17 +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the rr tree got a conflict in
> arch/openrisc/kernel/module.c between commit 07319a81a55f ("OpenRISC:
> Module support") from the openrisc tree and commit 7c71b2f8e35c
> ("modules: make arch's use default loader hooks") from the rr tree.
>=20
> This is an indirect conflict that turns up because
> arch/openrisc/kernel/module.c is based very closely on a file that is
> modified by the rr commit.  I have just used the openrisc version of the
> file, but I assume that much of it could be removed.

The OpenRISC tree should depend on that patch from Rusty's tree and the
file arch/openrisc/kernel/module.c should be a bit simpler.  I'll push
out an updated OpenRISC tree this evening that has that fixed and we'll
see if the conflict doesn't go away.

That said, I don't quite understand why there's a conflict there at
all... the OpenRISC tree should have been independent of that patch in
any case.

/Jonas

--=-BftSC4ePodWVm8672H8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk4htcIACgkQ70gcjN2673N5ywCfSU3N6+JeSw6U6e1cYMHoaXuC
lCAAoMx/xr8pEV6OsaWtOTqhopSmJ3qQ
=X54U
-----END PGP SIGNATURE-----

--=-BftSC4ePodWVm8672H8F--

