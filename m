Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2JXVBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:01:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:44786 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2JXVBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,642,1344236400"; 
   d="asc'?scan'208";a="237834981"
Message-ID: <1351111870.1917.4.camel@jtkirshe-mobl>
Subject: Re: [BUG] checkpatch.pl with commit
 058806007450489bb8f457b275e5cb5c946320c1
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 13:51:10 -0700
In-Reply-To: <1351087936.18179.9.camel@joe-AO722>
References: <1351076421.25066.14.camel@jtkirshe-mobl>
	 <1351087936.18179.9.camel@joe-AO722>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fls861xKKLRc5f/KmKZV"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fls861xKKLRc5f/KmKZV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-24 at 07:12 -0700, Joe Perches wrote:
> On Wed, 2012-10-24 at 04:00 -0700, Jeff Kirsher wrote:
> > With the recent commit to checkpatch.pl:
> >=20
> > commit 058806007450489bb8f457b275e5cb5c946320c1
> > Author: Joe Perches <joe@perches.com>
> > Date:   Thu Oct 4 17:13:35 2012 -0700
> >=20
> >     checkpatch: check networking specific block comment style
> >=20
> > We are seeing false positive warnings.  Here is an example of the
> > code the would generate a false warning:
> >=20
> > #define foo	0x0000 /* foo comment */
> >=20
> > checkpatch.pl generates a warnings that the */ should be on a separate
> > line, which in this case is incorrect.
>=20
> Sorry 'bout that.  I believe it's fixed by:
> https://lkml.org/lkml/2012/10/14/267
>=20

Yes, I confirm that the patch in the link you provided solves the issue
I was seeing.  Thanks, has the patch been accepted yet?  I see it is not
in Dave's NET tree as of yet.

--=-fls861xKKLRc5f/KmKZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQiFS+AAoJEOVv75VaS+3OduYP/3Oy30QZVmNq4ubv0qvjtRkJ
enOM/tbOMxEGcUMMaQ+PHoOKYSOhtC4Kwnvnol51aoutdghRMo51Lc+jnEzoa4WC
SpOfmMPnEOtegjF9RsNQPoGs3OIWaCW2uELI7UOGc4Cup7EkOX4eoBq34AONm83r
y+r3sHJZMIA96Gl1a+8P95wWIbYGjZOAlyTVLmt5NgjwQ97xj0rLEKEICGFIZqfB
DtuOOX8ip6jn9FVUxlbo6ywtAZ/8JEzrO1IQ1UcU48a0qcRRkNAgk0CfJy7JUmz8
ftA8LgaeHrmo7a9MSmxh24QnWvjV4kmKRfq69I6N7bJLrqzRfGNz8NDqf09XjFrZ
ahgO4Kr4T+bpiYGVBPwF5umpTnbZSSBpKGAbzKqvimAWzDfF1L6C45/IP67wLM3M
LpRfIU4jrT08YT1S5sYmpP1G8UG2xDvOFA1EC/brBVMY9tCrVwsvPKNVjQ7bmPem
J/gagM1J5q3vFziRpnYwo4yxVgJQ6Jd7B+sVpVpD26l+pzPxqwYXx0W7+iw5w6j/
Z+EiEpjPx5Bgeq2cTPv30zYkcPhAnCvueVe0xRnuo/Bi7l/Xx5VGiOJd3y5AkIMS
V4OkwzDuc7sX3C+3fwSfnhvFSKkdq8xk3EQb7iVINZvagq/+tXPVCl0D5Cn4U2td
b9PvgMDWK8i1W5pmWrcc
=oiB4
-----END PGP SIGNATURE-----

--=-fls861xKKLRc5f/KmKZV--

