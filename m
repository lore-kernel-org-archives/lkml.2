Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1HBIgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:36:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43005 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab1HBIgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:36:13 -0400
Date: Tue, 2 Aug 2011 18:35:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: linux-next: build warning after merge of the moduleh tree
Message-Id: <20110802183558.fda9e3b1e9f3b93a70f6e494@canb.auug.org.au>
In-Reply-To: <4E37A696.2090007@fusionio.com>
References: <20110801132359.1de051cb8a4a2bdfdad7560c@canb.auug.org.au>
	<4E37A696.2090007@fusionio.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2011_18_35_58_+1000_CmC0BMshnmKGz0Ye"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Aug_2011_18_35_58_+1000_CmC0BMshnmKGz0Ye
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 2 Aug 2011 09:26:14 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>
> Thanks, will you carry this until things are merged? Not easy for me to
> fix up.

Yes, no problem.  It is possible that the module.h split may not even go
into v3.1, in which case the fix patch will jst become part of the moduleh
tree after the block tree is merged.

Though the feedback to the original patch writer is that they should have
included module.h instead of relying on it being implicitly included.

You could include a patch to add an include of module.h to this file in
your tree - that way even if the module.h split goes ahead, your tree
won't get broken.  It could then be changed to the lighter weight
export.h later.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Aug_2011_18_35_58_+1000_CmC0BMshnmKGz0Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJON7buAAoJEDMEi1NhKgbsCzEIAJjAD+rymdtholhTSXu6/xSn
3HhTDNuGaXYD33Xg7Ajcz70kb3O0A8Oe95ZdAyc44eKpPtf7k0YQqZ7tgee6gQ3m
G93Fj5HGmJvYkOW+2jK6ZuNg/JpdH3jCeCKdiRZMkVRmoBw0hFjkWSSWGuBO5gUM
lVDyjFZpL5hkhmDMCEEoxjCE2TsS08y7m1Uv6vBDcismRSDkrrjSQ2P72ZUzykvd
GoLX/NvqAZB9O/RO0RZl3dbfXd4fGhV8EdjwQr52KroRGLC6BVinuZJVx+5SWRAj
+g9qL3NUzETa9WM0Gja2L4DIVdT6fDikp2Nk4tOmBpeiF+xJrg9J9Q+2aTOEq/c=
=7z00
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2011_18_35_58_+1000_CmC0BMshnmKGz0Ye--
