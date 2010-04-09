Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0DIHNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:13:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51711 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0DIHNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:13:46 -0400
Date: Fri, 9 Apr 2010 17:13:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20100409171333.418c31f3.sfr@canb.auug.org.au>
In-Reply-To: <4BBEB995.4090307@infradead.org>
References: <20100407110035.217b024b.sfr@canb.auug.org.au>
	<4BBEB995.4090307@infradead.org>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Apr_2010_17_13_33_+1000_1dofDrD0oFxAw2k9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Apr_2010_17_13_33_+1000_1dofDrD0oFxAw2k9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Fri, 09 Apr 2010 02:22:29 -0300 Mauro Carvalho Chehab <mchehab@infradead=
.org> wrote:
>
> Thanks for pointing it to me. Fixed.
>=20
> I also fixed today a conflict that it would appear on your next pull, bet=
ween=20
> input and v4l-dvb, due to the upstream changes of keytable ops from
> int to unsigned.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Apr_2010_17_13_33_+1000_1dofDrD0oFxAw2k9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku+050ACgkQjjKRsyhoI8wBzACeJmV2ZwkjxMA56TlX27hkc0PC
IrAAnA0/QdFbO4ZS+HN9cVbzhY2VK6ZS
=u0nB
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Apr_2010_17_13_33_+1000_1dofDrD0oFxAw2k9--
