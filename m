Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab2AECQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:16:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53439 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2AECQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:16:24 -0500
Date: Thu, 5 Jan 2012 13:16:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20120105131616.27011797fc72a415ddd335aa@canb.auug.org.au>
In-Reply-To: <20120105110712.2666364926458942240d6534@canb.auug.org.au>
References: <20120105110712.2666364926458942240d6534@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_13_16_16_+1100_9.XsQSiGVIrjJV4t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_13_16_16_+1100_9.XsQSiGVIrjJV4t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Thu, 5 Jan 2012 11:07:12 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the pci-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> arch/x86/pci/acpi.c:81:46: error: expected '}' before ';' token
>=20
> Caused by commit 4c33d0af35ba ("PCI: Add Dell Studio 1557 to pci=3Dnocrs
> blacklist").  Please build test your tree ...
>=20
> I have used the pci-current tree from next-20120104 for today.

Of course I got the same failure in the pci tree, so I used the
next-20120104 version of it as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_13_16_16_+1100_9.XsQSiGVIrjJV4t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBQfwAAoJEECxmPOUX5FE8iYP/07rSq+hezC/YJ3o5yqbJMTA
TwfCzfhJ4qmVPx/wZYy2PwCATxqq3MnacwepFNPwcwnJbVLJ6+waMKMeTmFjo6TT
RVcytSyl9+q4h3OETc2YRXd0vJ5BpWjvw/BCNFNUIrF5bbGGwZ3lgUEkH7h1U+r0
I0ZDMKCmJoG7Kdypey7oCVY0dWWAj2w2xks7m1VUwK8ZShd3HRlrY9jehLh8RsAi
x3HnC8mjPrP7zRxOFRpmE9yWhei6jxRXzTGIAwmX5OMOlEY6fGGaSyPDG+psMza7
/ekBhkCtfrbkE4oLaIvLgf0IoFHfXMsCIH8X/s8zuyUcjD5CDuscVU5J/IGrBipF
+vrBLDl+whBvApn0J2X8sB7MEVi81oMAswnXNtyfjzGJnUHKuYg84wJ89eiAlDRG
U/Mvzf8UTdeljIlGcBSaIbW7fTX78wSQRAzygzD9a/LBDjhJqZQo7XnJOA/COywV
yZE7fizqy2CGLi3zP8wIvE9WKupC89J+eqef+JiDzDFOb8Kp8tqbhlPDfGe1R8Dc
YMbiReLZr2zOsmy53Yk4qfUn2KIGeryx6pDhiUePLY72oWt8P97lkF0M83ifPT3w
/qeHzBQV1NhXgAKDODe//ta8cZoUEagCevhKap1NBCRBafu2I57YC63O/J8jPdNq
NP4+7CIgOCgitXNWFWF4
=kZte
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_13_16_16_+1100_9.XsQSiGVIrjJV4t--
