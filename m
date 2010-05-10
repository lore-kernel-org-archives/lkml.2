Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0EJPx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:53:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0EJPxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:53:25 -0400
Date: Tue, 11 May 2010 01:53:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the rr tree
Message-Id: <20100511015319.24a07e09.sfr@canb.auug.org.au>
In-Reply-To: <201005102203.54784.rusty@rustcorp.com.au>
References: <20100510134409.4bbf1873.sfr@canb.auug.org.au>
	<20100510134620.2e06495b.sfr@canb.auug.org.au>
	<201005102203.54784.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_May_2010_01_53_19_+1000_S+QaYzv81S3nc/Fi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_May_2010_01_53_19_+1000_S+QaYzv81S3nc/Fi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 10 May 2010 22:03:53 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Thanks, these are harmless, and I had followup patches outside linux-next
> which resolve them.
>=20
> I've now included them in the linux-next part of the series.

Excellent, thanks.  The problem with "harmless" warnings is that they
make the important warnings harder to spot. :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_May_2010_01_53_19_+1000_S+QaYzv81S3nc/Fi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvoK+8ACgkQjjKRsyhoI8wEvQCgn+d7jA8ElNqcEZ15sEDz413t
xksAoJvmThJWu4dxc5nzZTymJ5u+5XYI
=xolY
-----END PGP SIGNATURE-----

--Signature=_Tue__11_May_2010_01_53_19_+1000_S+QaYzv81S3nc/Fi--
