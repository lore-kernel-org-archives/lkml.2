Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0KAV0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:26:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49406 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab0KAV0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:26:47 -0400
Date: Tue, 2 Nov 2010 08:26:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: michael@ellerman.id.au, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iSeries: Remove unused mf_getSrcHistory function.
Message-Id: <20101102082634.65342ce6.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
	<1288609842.10671.7.camel@concordia>
	<20101102071025.2fe5e6ca.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Nov_2010_08_26_34_+1100_U=uMosM.7D1l0yWN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Nov_2010_08_26_34_+1100_U=uMosM.7D1l0yWN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Nov 2010 21:06:23 +0100 (CET) Jesper Juhl <jj@chaosbits.net> wrot=
e:
>
> Remove unused function 'mf_getSrcHistory' (that will never be used ever=20
> according to Stephen Rothwell).
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Nov_2010_08_26_34_+1100_U=uMosM.7D1l0yWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMzzCKAAoJEDMEi1NhKgbsKmsH+QEPkwGHkXRBXloJgEw95dOI
m8BvAkU4uA0+n/ZHJw/LFoSdCj3oD2uI/RT+p9rHXmkIgAa9kFbEY9VHyDD2L3DY
oWuLFNpbZm0xyOJ/U+WKxz+CgEqB3hcfg3A8VZ4X2mDC/YuT73CbP0NBldDNOpTj
crAsfSgwEp7/Prodnrz/RZCX6Zpkwqn2zlph7iR6w0RRRtqouu72507rBAvo9/Tt
YqZQVw2MOkZB0WpHZjzS7QWhWqMlYFCwQZ+JkL/+gQLEUezPnfwVQgp2vsPzeCwm
Dan+O9XfajsWlICgHzRM/1P6B7quQHttxNjUbLFpoNKoSsmS9NPYfrQU0jcCBkE=
=MynW
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Nov_2010_08_26_34_+1100_U=uMosM.7D1l0yWN--
