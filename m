Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149Ab2C2VTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:19:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58103 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab2C2VTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:19:37 -0400
Date: Fri, 30 Mar 2012 08:19:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>
Subject: Re: New Tegra branch for linux-next
Message-Id: <20120330081926.82702541e47b3d188ca8054f@canb.auug.org.au>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17E43DC742@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17E43DC742@HQMAIL01.nvidia.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_08_19_26_+1100_.e3SXrc3b_0gXccI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_08_19_26_+1100_.e3SXrc3b_0gXccI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, 29 Mar 2012 12:13:10 -0700 Stephen Warren <swarren@nvidia.com> wrot=
e:
>
> Could you replace the existing Tegra branch in linux-next:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git for-next
>=20
> with the following:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git for=
-next

Done.

> (it currently contains v3.3-rc6 until the merge window is over)

Just confirming that it now contains a single fix patch ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Mar_2012_08_19_26_+1100_.e3SXrc3b_0gXccI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdNHeAAoJEECxmPOUX5FEc5MQAI327kShnEM8gzA97ANljosd
/qRyhSpKDgFAKWl9DIVmJOdxT9UKy/0ZB2NEBD2mmqZfi4wHIJAWPkjocSSfpsS0
TQObM/C6vl6fmxQOof0HVQGPyKGm2kJNDfpMxqAu90jA1iMtT2px3lOPMy2zBA/z
V1co27Ix3GDvtxbFU9z3IvQypfNMow4zrvLy5LAz9gGnjPiU9ZBH7ie7QhbkZWNw
ecnNareQZE9oKlc5gP+lGpapdYbrQcMH4AIq6fPDCLZbYtAKbHbqXmkIX+Ko05bh
zKLvzUXRLT+Rg3wgqmg4b8NGEqCMppbxNVYrKgPNhCmS3kS3XM+rEgSPgKzzjEf0
4CbxDd+s//KFONFlaMrwT60GOs4r8OQPhNFt7uq0tOyBJn5Jf3qsKZnblb9+rPZz
IdVnv4D3ifU9FJX6gZ0LzBAEwYOE+x9uPfjP4WGrY8s7NO8nelf6BoIaRDX2dJfV
wvwHm2WVpzVlfTG+QmoOGhJYlpZz3f5308AbHPTQ762bhueJm9LibXEOGnGtI0x3
gaC8DrbCRdgtgTgXhEjsxOR4yD/xeru9WegXbu2sGjTCP665wssspe7rNIKro8KG
dUk5qH9wd4vr2j98XyvbmNdBECevLYZpWDGfyS8jKhJa2vF0bKcCnGijpbbsMGSa
wrqdMAZN6K0DEdn40paV
=sGCS
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_08_19_26_+1100_.e3SXrc3b_0gXccI--
