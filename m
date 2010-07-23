Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0GWHIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:08:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38939 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab0GWHIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:08:51 -0400
Date: Fri, 23 Jul 2010 17:08:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the kgdb tree with Linus' tree
Message-Id: <20100723170847.0020e7f2.sfr@canb.auug.org.au>
In-Reply-To: <4C490EB0.2030007@windriver.com>
References: <20100723122646.a788fc86.sfr@canb.auug.org.au>
	<4C490EB0.2030007@windriver.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_17_08_47_+1000_nHKlbRkRJ_rZKThH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_17_08_47_+1000_nHKlbRkRJ_rZKThH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Thu, 22 Jul 2010 22:38:24 -0500 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> This already fixed.  The problem was caused by the for_linus pull branch
> being out of sync with kgdb-next.

Yeah, I guessed :-)

Thanks

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Jul_2010_17_08_47_+1000_nHKlbRkRJ_rZKThH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMST//AAoJEDMEi1NhKgbsmokIAKFAfYDXkQg/QmeomFRJS9l2
ijb6dIikpPzN1qWyyjnPE77yo5fvdUBRLrTn77XKMhLvrg9u1uEnjr4/GqXBCpY9
v+re4/Ovhz2JPEJ8yA00z4TScrnHjHPetrbH4XdbbMIlIYb7sW9loEHIz1MluPOA
NHyMMB6DN/BOFv/hIvG4pswNUL2lBmbRw+HHQWKK3GjHwXd3bsFtibF1JoXklbz5
2g47crXD9bIu1UfAlm8JT8FA3MMymidgbgslFt+gcsF9GTAu0ZGv+waB7D3m9GSp
GadQcwP6WPT0EHo3tQOgUFrlL5wwODUBoCYcdSbjLn8DHASUx1FMAjaEP6Yi4+I=
=b7KZ
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_17_08_47_+1000_nHKlbRkRJ_rZKThH--
