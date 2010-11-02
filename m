Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0KBAUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:20:55 -0400
Received: from ozlabs.org ([203.10.76.45]:44856 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab0KBAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:20:52 -0400
Subject: Re: [PATCH] iSeries: Remove unused mf_getSrcHistory function.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jesper Juhl <jj@chaosbits.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011012218420.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
	 <1288609842.10671.7.camel@concordia>
	 <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>
	 <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>
	 <20101102082634.65342ce6.sfr@canb.auug.org.au>
	 <alpine.LNX.2.00.1011012218420.12889@swampdragon.chaosbits.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eOCPNPdZIoaSyHjGARJV"
Date: Tue, 02 Nov 2010 11:20:50 +1100
Message-ID: <1288657250.16790.4.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eOCPNPdZIoaSyHjGARJV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-01 at 22:20 +0100, Jesper Juhl wrote:
> Hi Stephen,
>=20
> On Tue, 2 Nov 2010, Stephen Rothwell wrote:
>=20
> > On Mon, 1 Nov 2010 21:06:23 +0100 (CET) Jesper Juhl <jj@chaosbits.net> =
wrote:
> > >
> > > Remove unused function 'mf_getSrcHistory' (that will never be used ev=
er=20
> > > according to Stephen Rothwell).
> > >=20
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >=20
> > Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
> >=20
>=20
> Ok, so if you are the (unofficial) iSeries maintainer and you don't merge=
=20
> the patch somewhere that'll eventually go up-stream, but just ACK it=20
> (thank you for that btw), then where do I send it to get it merged?

Here. ie. linuxppc-dev.

But, while you're removing it you should remove the #if 0'ed callsite as
well, see mf_src_proc_show() in that file. :)

cheers

--=-eOCPNPdZIoaSyHjGARJV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzPWV8ACgkQdSjSd0sB4dI0NwCfTXSXao1Giw2lp56QfPOY6Q9J
jR8AoJYnOXUTU4jBSlCFRJ9V6CMeIT5B
=732g
-----END PGP SIGNATURE-----

--=-eOCPNPdZIoaSyHjGARJV--

