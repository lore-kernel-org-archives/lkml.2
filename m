Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1IKEXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 00:23:42 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47183 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1IKEXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 00:23:41 -0400
Date: Sun, 11 Sep 2011 14:23:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20110911142334.8df995a097763cd10f780f00@canb.auug.org.au>
In-Reply-To: <CACqU3MVbKJw5VVqnz+gfLDnQEDu9Lv4xV+7RvdD4ZbetGu79WQ@mail.gmail.com>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
	<20110825140820.GA9126@kroah.com>
	<4E56689D.3080202@freescale.com>
	<20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
	<CACqU3MUs_97=MuuKAjr-LeUT7kSRxtzSntwUeKeeH4n8s7SSGg@mail.gmail.com>
	<20110826103932.1626f1c5542b660bcd1b24aa@canb.auug.org.au>
	<CACqU3MVbKJw5VVqnz+gfLDnQEDu9Lv4xV+7RvdD4ZbetGu79WQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__11_Sep_2011_14_23_34_+1000_Y9gQR26hReL/vtTt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__11_Sep_2011_14_23_34_+1000_Y9gQR26hReL/vtTt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnaud,

On Fri, 26 Aug 2011 11:47:40 -0400 Arnaud Lacombe <lacombar@gmail.com> wrot=
e:
>
> Couldn't all the error log be public, rotated over a 7 iteration
> period ? That would be fair to everyone.

See http://kisskb.ellerman.id.au/linux-next (as stated in all my release
emails).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__11_Sep_2011_14_23_34_+1000_Y9gQR26hReL/vtTt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJObDfGAAoJEDMEi1NhKgbsNL0H/jhtlluCKcxzhlZ3EIqoNBzM
vbhxSvRJUtowUWaEUK+uNxr6K3WXpSLH8vcPPhaTo9v0GoC39qV/4pk76J2U9XuP
UQkLFg6o51LQ0swn83wNW8qpEQC2Fi1qZjZ1hvl374DpGad9ikB/c9LP3oRgkh1l
/8bXn/568WxWZUTkoYaPkiZOla9hrLu8BUZCv27L40ilR2BuVcbZoAEB8Q6boDRg
nQVygiajReyuq7L/m0iZcyjT0Zni6I3wl1cd8LeFcIbCR1Hmub6rypfOoSPBNcsL
/X2ojseAEHxcAB4muO4jhjPb/IPkjRhhpb9bmfes73CG+sJAvITR7eV4xXG4lK4=
=lnZw
-----END PGP SIGNATURE-----

--Signature=_Sun__11_Sep_2011_14_23_34_+1000_Y9gQR26hReL/vtTt--
