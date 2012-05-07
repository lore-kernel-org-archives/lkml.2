Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2EGB51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:57:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46351 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893Ab2EGB50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:57:26 -0400
Message-ID: <1336355835.8274.262.camel@deadeye>
Subject: Re: [ 57/75] exit_signal: simplify the "we have changed execution
 domain" logic
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Mon, 07 May 2012 02:57:15 +0100
In-Reply-To: <20120504204229.240075699@linuxfoundation.org>
References: <20120504204229.240075699@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-O6cSPK1KT7THKsmoax6M"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O6cSPK1KT7THKsmoax6M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Oleg Nesterov <oleg@redhat.com>
>=20
> commit e636825346b36a07ccfc8e30946d52855e21f681 upstream.
[...]

This and the following commit b6e238dceed36891cc633167afe7151f1f3d83c5
('exit_signal: fix the "parent has changed security domain" logic')
appear to be applicable to 3.2.y as well.  Should I queue them up?

Ben.

--=20
Ben Hutchings
Hoare's Law of Large Problems:
        Inside every large problem is a small problem struggling to get out=
.

--=-O6cSPK1KT7THKsmoax6M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6cr++e/yOyVhhEJAQocgRAAs/88Uw/gADqeD8q6+7z057NenFi1ocNF
ZokjSBDuFtO0tsn1o2ATvLH588wdSQ3KV61J6uAT8nNbFDMbpVsuU2bXpu9it0WO
JvZNFzqoY82FTpFrbekzOmQ2KOaEeoCVsgOSWRSiN5pwnk6xa7+XusUgrAWymqHe
2dMmvH8+vNZvUJYs9HmEa2U3eydQnoVmxnxzcTYSPm4KvYjoRQsE0LPTzt+U5OUm
OmVix3HkCnrSxr8J9JjodMg1gbMqCfSFhXB+rqS7rnbqYTVNAVY8cna1oTyOT5XX
wkCDzZ/emsEY/6IRJ0gafgmy5nNh0U61b5JW+c1kGstgXPNArY37UTC5qMyLI4nI
MGh07/l136myt1SRAiEwz0jCv3UnDvCJrELgEWCwbEi1Hbijyu5ys5KpCLkWrjy/
JOdcbmhWOCygv124kCrAKGFK1a/InJwf/nKtIVDqkeNnztIbzYCqHyP66/nUnK6O
k6yBwyWTfI88wa0WQiPP2Buigeq3lR7SyJfq3s3Kn2adbqk5mq/IBRZ0qdkdvWdT
2OCIpYUyT1UB6QBrYhi7SrEpE0fsyU3Zp8ASx1VNvxmbmOGXROuano2sw5zN5VAa
PgLgTALamVhYchAQ4NQjKkV1K+bHIPg8jCyoe3upTno6d4qno9Z6HbyRvope+zev
y3hgDVHmA4M=
=M4Ya
-----END PGP SIGNATURE-----

--=-O6cSPK1KT7THKsmoax6M--
