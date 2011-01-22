Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1AVBJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:09:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56760 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab1AVBJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:09:48 -0500
Date: Sat, 22 Jan 2011 12:09:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Change name from swiotlb-xen to xen-two tree and branches.
Message-Id: <20110122120941.20aec5de.sfr@canb.auug.org.au>
In-Reply-To: <20110121164501.GB29131@dumpdata.com>
References: <20110121164501.GB29131@dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__22_Jan_2011_12_09_41_+1100_0lveTnDHZ_z4Fe0c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__22_Jan_2011_12_09_41_+1100_0lveTnDHZ_z4Fe0c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Fri, 21 Jan 2011 11:45:01 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> I was wondering if you would be OK change the name and branch
> of one of my trees?
>=20
> In the past the git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.=
git
> was called 'swiotlb-xen' but it has expanded since I've took the role
> of Xen co-maintainer.
>=20
> Would you be OK changing the name from swiotlb-xen to 'xen-two' and
> pulling from #linux-next branch instead of #master please?

All done - but my next tree will not be built until Jan 31 ...

> I wonder if there is a better name than 'xen-two'?

If you think of one, let me know.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__22_Jan_2011_12_09_41_+1100_0lveTnDHZ_z4Fe0c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNOi5VAAoJEDMEi1NhKgbsFckH/i0W977KxMLSeHOHfRo+liGk
VAzJs7/+/pe66Pbisy3Kii0aKFI3sLgsS63nGeOrM2z2W+lMksVgPWXq7ezpZ0CG
Yq9feve9P3ZsSd8FHX6h7/NdnVxn7Kip3rfvearA9D4GKfy2Kq14bo7IUxnetVAF
RGXvFJUmiZANn7EIx99DvRWgZQL3vztgbSQXkrYfilrDUvOxvK6mDNXJOpO/8l2T
zV5ccXjc8l2ewaMiMKBGQv53APeRs7hzsKSqa3ZD2nhjUQsSUGWdxlE2yI3JJc5H
REhxZL5VqkiI369jbI7S3vaMHUZ+k6Oq48/gYoTZRoh5W4BLZl7VEC7PXCqVb5E=
=iASd
-----END PGP SIGNATURE-----

--Signature=_Sat__22_Jan_2011_12_09_41_+1100_0lveTnDHZ_z4Fe0c--
