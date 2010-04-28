Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0D1BHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:07:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53587 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0D1BHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:07:16 -0400
Date: Wed, 28 Apr 2010 11:07:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20100428110710.cec8acdb.sfr@canb.auug.org.au>
In-Reply-To: <20100412124041.4876c3f9.sfr@canb.auug.org.au>
References: <20100412124041.4876c3f9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_11_07_10_+1000_lWsK8B=J/FImEYD8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_11_07_10_+1000_lWsK8B=J/FImEYD8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Mon, 12 Apr 2010 12:40:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the v4l-dvb tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/input/input.c: In function 'input_default_setkeycode':
> drivers/input/input.c:691: error: 'keycode' undeclared (first use in this=
 function)
>=20
> Caused by commit df7ad46fc171965103f02649f6c2f02c6ca8b331 ("Merge branch
> 'master' of /home/v4l/bare_trees/v4l-dvb").  The merge resolution is not
> quite right.
>=20
> I have used the v4l-dvb tree from next-20100409 for today.

I am still getting this build failure ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_11_07_10_+1000_lWsK8B=J/FImEYD8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXij4ACgkQjjKRsyhoI8xVSwCaAsOXXQciqAJ0/GFDUj0XZAQu
jW8AoLNATvR+a+5ZFFa1uBgL+NsWFAN8
=Hf7O
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_11_07_10_+1000_lWsK8B=J/FImEYD8--
