Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0G1Bbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 21:31:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41105 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab0G1Bbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 21:31:45 -0400
Date: Wed, 28 Jul 2010 11:31:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: Make jz4740-fb depends on MACH_JZ4740
Message-Id: <20100728113136.97942d63.sfr@canb.auug.org.au>
In-Reply-To: <20100727055546.GA5469@linux-mips.org>
References: <20100727111422.673b4919.sfr@canb.auug.org.au>
	<1280197979-24307-1-git-send-email-lars@metafoo.de>
	<20100727055546.GA5469@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_11_31_36_+1000_QRn.UWOrPY1cWeZQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_11_31_36_+1000_QRn.UWOrPY1cWeZQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Tue, 27 Jul 2010 06:55:46 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:
>
> On Tue, Jul 27, 2010 at 04:32:59AM +0200, Lars-Peter Clausen wrote:
>=20
> > The jz4740-fb driver should only be selectabed of MACH_JZ4740 is select=
ed.
>=20
> Thanks, folded into the original patch.

But it didn't make it into your mips-for-linux-next branch today?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_11_31_36_+1000_QRn.UWOrPY1cWeZQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT4h4AAoJEDMEi1NhKgbs+IUH/RwtjP2QaoJhGABTSKNd98tO
b44AaeBViZcClLAtgxSL8/Z1NUP9qHHRU8xb5tQcOf41rCMOaFDvr/0UPCE3OrZA
my+7KgOSTztz0LBPQ39Vi0T6OoDSYkrK15n47CTu+EH/P2HTOeTAj7OWMYzlub6S
dI2to99SubvTN9QAwSK77R2Xw20wIDIkWqwzr89+L4lX/q5pHg7dtcS3z3a4qioW
Qm4yukWM0USP7YAB2ah9HQ8olgWQaE5Y5CkxxbXKf4CmP0Jf3aMqnmcE/YmcdH9W
d2Bjnhf07TqCV3eGf34euzyA88AP5NV01jB0v54fbK6KKxHnRcyxp54CAEv6L1w=
=QXq2
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_11_31_36_+1000_QRn.UWOrPY1cWeZQ--
