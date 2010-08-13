Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0HMH2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:28:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40979 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab0HMH2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:28:06 -0400
Date: Fri, 13 Aug 2010 17:27:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: geert@linux-m68k.org, heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
Message-Id: <20100813172752.4acd7089.sfr@canb.auug.org.au>
In-Reply-To: <20100813154056S.fujita.tomonori@lab.ntt.co.jp>
References: <20100812075532.GA7814@osiris.boeblingen.de.ibm.com>
	<20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
	<AANLkTinnLY4LZ-3xbKEJVR3Qjw5xghRZ6i=tWfw8hJHH@mail.gmail.com>
	<20100813154056S.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_Aug_2010_17_27_52_+1000_tt4O3sC_AJ2BUEg/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Aug_2010_17_27_52_+1000_tt4O3sC_AJ2BUEg/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 13 Aug 2010 15:45:31 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt=
.co.jp> wrote:
>
> Any chance to test the -mm tree on linux-next compile platform?

We do, I just have to remember to import the -mm tree manually.

See: http://kisskb.ellerman.id.au/kisskb/branch/14/

Even better would be to get most of the -mm tree into linux-next itself ...=
 ;-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_Aug_2010_17_27_52_+1000_tt4O3sC_AJ2BUEg/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMZPP4AAoJEDMEi1NhKgbsUpgH/i+rOsQBjUb1fMM1fCAsri88
kplvk4N69NuBC3CCYJYjaLIrM0Led7eTxyymPr+46fcTmqU6epmyyvsuMs5vJT+R
BGg+tEP3NwE0T5skBzy9ov82a/ZAmTlghggPuBz2tyJnJTviScTzp3Y3HE4lmzjq
Ir+oxJWxI0d7YoFVrdY2WCyU3036MHzpXOF7bFt3GMQkKtYZTLH3tItBEtuxSzmU
YfvBBXeTo6JBO1KS4bbzONLp3hR4vOK1qw3fiEZ+nt9GUanC21FGLlriesUzoizc
7bcxkr3imJ93bSBgYFCfpn4sIteyW2HMwQJipU/xexyPbZFBxXIm9mMaf5GSKyo=
=dwTS
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Aug_2010_17_27_52_+1000_tt4O3sC_AJ2BUEg/--
