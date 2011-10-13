Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1JMLAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:00:08 -0400
Received: from garuda.bells23.org.uk ([85.13.250.28]:52223 "EHLO
	garuda.bells23.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab1JMLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:00:04 -0400
Subject: Re kernel.org status: hints on how to check your machine for
 intrusion
From: "Matthew W.S. Bell" <matthew@bells23.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110930235924.GA25176@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-/lguYKdMhFokqHngoRMk"
Date: Thu, 13 Oct 2011 11:59:56 +0100
Message-ID: <1318503596.15397.27.camel@ibis>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/lguYKdMhFokqHngoRMk
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

--=-/lguYKdMhFokqHngoRMk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABCAAGBQJOlsSnAAoJEGR0qOlQ6NT3/eEH/3u4Xdt/ELMiEPfdR01hIqke
TqGPYB4oNmSI0iLHKWJzm2kzpCrDVODIAz95NHP9LwXtJG3gqdQTcTV2FqAHE7Le
dwjKU3H3IM6r33NmSou1Hban7R+MUXnw33lqmkOHTiHqoH5nnyykrLzYfItHZorH
I+o7zB+cLoFsVZnVTRAcgwgj44UPtktEqpgqwMnvnGgs3s/m34kSujsCK+tYGacB
0x+R1l7+3XtP5CZKQ8T02gBS2r12ooLSlRzOLM3gQ91Zngs3SD1grPxeBy8TTaBb
Ctifqo0sLdFAt/GIoMtVAZv4+Laf2d68aehsAZIuzQ8RhiTsdWLIxU4NpOeVH5k=
=gpE+
-----END PGP SIGNATURE-----

--=-/lguYKdMhFokqHngoRMk--

