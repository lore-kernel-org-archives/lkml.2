Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1JMDBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 23:01:01 -0400
Received: from garuda.bells23.org.uk ([85.13.250.28]:38216 "EHLO
	garuda.bells23.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1JMDBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 23:01:00 -0400
X-Greylist: delayed 1581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Oct 2011 23:01:00 EDT
Subject: Re kernel.org status: hints on how to check your machine for
 intrusion
From: "Matthew W.S. Bell" <matthew@bells23.org.uk>
Reply-To: matthew@bells23.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110930235924.GA25176@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-PxF7CCuCNTn5Q9OX+Xgk"
Date: Thu, 13 Oct 2011 03:34:28 +0100
Message-ID: <1318473268.15397.16.camel@ibis>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PxF7CCuCNTn5Q9OX+Xgk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 16:59:24 -0700, Greg KH wrote:=20
> 2. Verify that your package signatures match what your package manager th=
inks
>    they are.

<snip>

> To do this on a Debian based system, run the following bash snippet:
> 	dpkg -l \*|while read s n rest; do if [ "$s" =3D=3D "ii" ]; then echo $n=
;
> 	fi; done > ~/tmp.txt
> 	for f in `cat ~/tmp.txt`; do debsums -s -a $f; done

At least since squeeze, debsums defaults to checking all packages, so
the following is sufficient:
	debsums -as

It may also be worth checking the output of:
	debsums --list-missing

Matthew W.S. Bell

--=-PxF7CCuCNTn5Q9OX+Xgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABCAAGBQJOlk4sAAoJEGR0qOlQ6NT3Sg8IAIiyU9KttVYRk0hGRFknH7QG
iud7IQ6kGdiFaDv/BL8A7K5/oByxv7KvHEfaP0pwqkmoJ9rK8Fg0uV4Ie6/E2TtQ
1FA7Tynn3W6rwlyOuksbrp+o0pCEQ86KET1UralWXr/SeD1dO7Q6/5OtaAAmaEHE
6KNzCqlp2ymgXz7AIQyaJIbHCZQYf+VMJAQoWt7B4ijJVwk4q7cxwc0F4n8XY3EI
EOTlmZ25r5LwWsvtNcjg2gyjJxJ/gehdqU98zFHttSLdnCmKN4cy1/BQOBA6V4aS
2ctpDn/AllnPNaY6SAvYIMokGY4+XhjpgYvnCLC5kCX3pc67cAUYnEBuM1MoBgo=
=2f62
-----END PGP SIGNATURE-----

--=-PxF7CCuCNTn5Q9OX+Xgk--

