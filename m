Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1KIQRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:17:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57941 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1KIQR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:17:29 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>, dhowells@redhat.com
Subject: Re: What happened to vcoalesce?
Date: Wed, 9 Nov 2011 11:17:26 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <4EBA40E3.60203@metafoo.de>
In-Reply-To: <4EBA40E3.60203@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart20018144.HQBcaIqvjQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111091117.27481.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart20018144.HQBcaIqvjQ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 09 November 2011 03:59:15 Lars-Peter Clausen wrote:
> I'm using the kernel firmware loader on a blackfin board. And this
> currently doesn't work with mainline since the firmware loader uses vmap.
> In the ADI blackfin Linux tree there is a patch written by you, which
> fixes this.
>=20
> What is the status of that patch in regard to going mainline? I found a
> mailing-list post from January where you tried to submit it upstream, but
> there was a minor bug in the patch and so the it was rejected. In March y=
ou
> posted the fixed up version and from than on I couldn't find references to
> it anymore.

my patch had a bug in the MMU case, so when David pushed it to Linus, Linus=
=20
got grumpy and rejected them.  i think i need to re-convince David to push =
the=20
patches again now that i've fixed that bug.

David: could you comment ?

https://lkml.org/lkml/2011/3/24/386
=2Dmike

--nextPart20018144.HQBcaIqvjQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOuqeXAAoJEEFjO5/oN/WBe0gQAIr+LfEFyp7WSKamzgtXt1FA
qegJULvJnFuEjGtRR3FjZQOG+cMkjQIJ570VpfHKugzIageANy0jaqT3ShrHY88+
7vbND/snqk8/di0q7RA0MC/oVe6clgi6NFli1C8LE7mc1K2tTK3xS4NP6NhUzpj9
IQdGY4MbSWMRtoh+3X75L7zJAWScZWh8+Az72L9mBjVMZA9ExblLwemVEU5QUIYe
QdXkU/4kOC98nrQps8QEAnauTNoPnq+fx1bMqN3D+LpucpdAzk9keNdESKfEE+P9
hdDzBwsZugLTivKDGZzegD+o4O6hV3p5de8yGWxjSVV4PvAqs346v+x5eA7N+W7W
T8a39pPG5VJNPgrkmILdxM38ELddmg3pkLHHPCzO2CWUULDUx+Esfecn0zjm04Q8
jX8DAionU2swSzpCh4f2Lh0xzIgQ1H8z8GB9Vfm0DKHhBKs68PrkP6yy2hPGdKT2
p/jvXR4L+5DrDE1tfIGtff4jU5fUlidg0jKFD0ek4jIYqB0prp89MzjNmSBGJ8Xa
Xq8zJYd8btKFUzgtcQ+qHtY/G552rGNLZEbSTph4+lGsvMBHScq1C2Hov12n90RE
46CHEA4MVHgjNqHa+00azREJUmFpaDjmOXA60E60GtxaGBDAro2vVqWRZoTkHi40
j6hLm3kD4JXIK5yeZBZH
=8xWj
-----END PGP SIGNATURE-----

--nextPart20018144.HQBcaIqvjQ--
