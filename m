Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab0EXDzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:55:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55075 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983Ab0EXDzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:55:47 -0400
Date: Mon, 24 May 2010 13:55:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jassi Brar <jassi.brar@samsung.com>
Subject: Re: linux-next: build failure after merge of the async_tx tree
Message-Id: <20100524135541.e49d043c.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTilefCp0WI-gFvuuXM6qrCO98I3GPJdN0UO6hfLI@mail.gmail.com>
References: <20100524112405.3c62d22b.sfr@canb.auug.org.au>
	<AANLkTilefCp0WI-gFvuuXM6qrCO98I3GPJdN0UO6hfLI@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_May_2010_13_55_41_+1000_VYJZjGsqThjiSyyO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_May_2010_13_55_41_+1000_VYJZjGsqThjiSyyO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Sun, 23 May 2010 20:42:38 -0700 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> Should have caught that in the review... changed the 'select PL330' to
> a 'depends on PL300' and pushed it back out.

Thanks, I will pick it up tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_May_2010_13_55_41_+1000_VYJZjGsqThjiSyyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv5+L0ACgkQjjKRsyhoI8wk2ACgpWLOK/jDKSUswhoy6J0vQol5
AkgAoK1vFa2KJoMx7BlOuULZ7978amzh
=EL0y
-----END PGP SIGNATURE-----

--Signature=_Mon__24_May_2010_13_55_41_+1000_VYJZjGsqThjiSyyO--
