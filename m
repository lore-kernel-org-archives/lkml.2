Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab2LKXqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:46:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39214 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2LKXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:46:43 -0500
Date: Wed, 12 Dec 2012 10:46:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        fengguang.wu@intel.com, julia.lawall@lip6.fr, jiang.liu@huawei.com
Subject: Re: [GIT PULL] VFIO updates for v3.8
Message-Id: <20121212104632.b01520d6015486dd3ae507ef@canb.auug.org.au>
In-Reply-To: <1355252887.3224.176.camel@bling.home>
References: <1355252887.3224.176.camel@bling.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Dec_2012_10_46_32_+1100_lM7a/UePMOkjkiEF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Dec_2012_10_46_32_+1100_lM7a/UePMOkjkiEF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 11 Dec 2012 12:08:07 -0700 Alex Williamson <alex.williamson@redhat.=
com> wrote:
>
> The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c6=
0e:
>=20
>   Linux 3.7 (2012-12-10 19:30:57 -0800)
>=20
> are available in the git repository at:
>=20
>   git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.8
>=20
> for you to fetch changes up to a9e3ccfa452c8c5bac49637fe6ece1ac3246d312:
>=20
>   vfio-pci: Enable device before attempting reset (2012-12-11 11:25:37 -0=
700)

This has been rebased from what was in linux-next yesterday onto v3.7.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Dec_2012_10_46_32_+1100_lM7a/UePMOkjkiEF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQx8XYAAoJEECxmPOUX5FEyDEP/1Ns17BSbmuqnBmsNIE1Wq+f
GCr/EBvRAV7iRgZ6jagRwzTJ4ZEQby0fKForvaKJa+mjdXzVljIFB09qnT3NDR8P
Zh3UJdXEIDyQ8ID5GdJXcwlrlNIBVtxGTiUGOIdQZKS/JesJavWXUhJcnXyjJWrW
gInHXwv3wRAs1Ne8hPo7Cy2Fvy2bxC7e2jlNReLeUBceLPZHP3q4sU24mic7rFVN
QCDIADD9nwzFZmFFlf5KkVFMhHx0uFWIf+qim5PiS8pwsSK6/uU1BobSLLLHEaC7
NZEHZzXRxhI3wA0BfBks/Uw/Te/jbrmO14+EKJY2h0fPDnIIsJrm+mAAk5uu+cIa
X/YwwDCOznsyl8Xd50EEqSwV9Ac3+YY9+qVIbCYCU0Mqva9aJltdgEv8idfv1jdv
/ViDDcrPTHZL7YywZV/GsYVauFNHYWoV3clHsQC1xmnsev3pne9vUr5tm5A25O3p
m3NCPgJPN9JQz2aCJu9eTYnlyjOvoZ7CrQUsTIQsz8Uy6K/knL2Yrue6j0LLIsaW
Vy0xUgKbsBsKdr4R5Aa3Jl/l/KrF9FRFHG6mHdEI+57LwS8fLKRxAlllgFvJsCVF
iq5B9CkLthvb2O5E/fn23Vmjf1WuPd/HFzoAbuzEih+O8zkj/j+J4YNXBXLw6EG/
P3kPZrngrnIkLgX4fTnP
=tpwl
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Dec_2012_10_46_32_+1100_lM7a/UePMOkjkiEF--
