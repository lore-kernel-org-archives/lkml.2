Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1IPIkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:40:01 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33147 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1IPIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:39:59 -0400
Date: Fri, 16 Sep 2011 18:39:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-Id: <20110916183948.592834d36dfa9871b994fb74@canb.auug.org.au>
In-Reply-To: <20110916071638.GJ11297@pengutronix.de>
References: <20110916135523.01ec57f699192230272e99e3@canb.auug.org.au>
	<20110916071638.GJ11297@pengutronix.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Sep_2011_18_39_48_+1000_Vx=.WIOgQHqAPexp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Sep_2011_18_39_48_+1000_Vx=.WIOgQHqAPexp
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Fri, 16 Sep 2011 09:16:38 +0200 Uwe Kleine-K=C3=B6nig <u.kleine-koenig@p=
engutronix.de> wrote:
>
> > Presumably caused by commit 747c98a3660d ("leds: Convert mc13783 driver
> > to mc13xxx MFD").
> >=20
> > I have used the mfd tree from next-20110915 for today.
> I'd look into the issue, but I don't have 747c98a3660d and I don't know
> where to get it from. IMHO it would be great if you could push your next
> tree somewhere.

Well, you can get it from the mfd tree (branch for-next of
git://git.infradead.org/users/sameo/mfd-2.6.git).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Sep_2011_18_39_48_+1000_Vx=.WIOgQHqAPexp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOcwtUAAoJEDMEi1NhKgbsM8MH/2w+jXcIUNvoHrlmIT8yFKMS
i+2Y8uMs+zYf/QxO4bGH/Nt60i51xNVabugpxstulYDaNJ9qdaq8sXBdX0IwAuSx
ZvJFDfwSTMddtmgJ9jW2OS6J6+tXciV32FWQDXXG7Wkgv4iTov4NJwSBEZWeWfDC
rOGlEp0MaG7qYiRW9ipYDPLN4tHM7at742gKsJ0y85HyE5O4iFnBubVMzTWMpFhr
6fRF6hfJEh7HSjBbv6eoWxvXdV4GpI1m+4trLHY/X2qL3tRJdZIt5n4oaqrATD45
h4hhPKCwnYP8gYqd7Hbi7G+NRwNQ+LI3j3DhO9SsEz2Rp/Hr8yqWgezLTZrZg7I=
=X63i
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Sep_2011_18_39_48_+1000_Vx=.WIOgQHqAPexp--
