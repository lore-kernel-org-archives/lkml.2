Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2IVB4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:56:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35538 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2IVB4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:56:16 -0400
Date: Sat, 22 Sep 2012 11:56:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2012-09-20-17-25 uploaded (fs/bimfmt_elf on uml)
Message-Id: <20120922115606.5ca9f599cd88514ddda4831d@canb.auug.org.au>
In-Reply-To: <505C865D.5090802@xenotime.net>
References: <20120921002638.7859F100047@wpzn3.hot.corp.google.com>
	<505C865D.5090802@xenotime.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__22_Sep_2012_11_56_06_+1000_gg_wJpkagHAqLOhL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__22_Sep_2012_11_56_06_+1000_gg_wJpkagHAqLOhL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 21 Sep 2012 08:23:09 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> on uml for x86_64 defconfig:
>=20
> fs/binfmt_elf.c: In function 'fill_files_note':
> fs/binfmt_elf.c:1419:2: error: implicit declaration of function 'vmalloc'
> fs/binfmt_elf.c:1419:7: warning: assignment makes pointer from integer wi=
thout a cast
> fs/binfmt_elf.c:1437:5: error: implicit declaration of function 'vfree'

reported in linux-next (offending patch reverted for other
problems).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__22_Sep_2012_11_56_06_+1000_gg_wJpkagHAqLOhL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQXRq2AAoJEECxmPOUX5FEnckP/jqf5Om/h6Ec2MJPm80IFQcW
rz9ie+1q3IZXSHzayUfpbRMzol5OWKvVNgyZxEb+Y9MhTEcheZRl10K3XeDNB9vm
8nboFy+eWiYPdViIZ2qP2spx+NLzBOdUHmw7keY/KBgp8B266yHhIaWFHHjESS2M
+B0sQ3TzV6mfqiN5y7n6mfIMpRCtzlpYBJz4YDCzVyaNH8+UHcYYzOLLZi29gy31
Dh+LzRGeEI7aqpI9CGRRa24L+rq4S6zoFWRoyWt+nMNuPilyypEAtVSzptxdfwZw
n404X6hROrExvhejl7iVIzNCtyy22RNesucwWTM2VMMIG/v+Za679+T7zmpLdPIp
gAtCRTCSY7+FYNaFHF5V+z55AIPkw7zbCSSM5aUUy4zcX+isD0SIq/V3Vo+2X/02
0b4iKfiSnC/bl1Pnjnsa0+wfMK6C6JSXoSfP0bEV73Qf+lQ40yAEYJ254r5TIZpy
koi5IuAZW6Tbbw+iBCBnN3KVh8MUohUQh7rNp9y7ZtztXFpb1nLUq+hMpbw1yag5
pKLaxGw0szDGcggSvM/mjPmGQ1lCjQp+i+w6M+QkDM1x7XaTF1ts7jLGGIT/OBjj
4IlWlYNU2lDZ1SnuwrBt3b7NtrYp4kVciBx9UQ0irOAgKBDwAOCQTs3TFnw7GS+4
EKyAfOBGzbRu0BxOL7OG
=icDK
-----END PGP SIGNATURE-----

--Signature=_Sat__22_Sep_2012_11_56_06_+1000_gg_wJpkagHAqLOhL--
