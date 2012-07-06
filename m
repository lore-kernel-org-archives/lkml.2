Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab2GFLGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:06:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45519 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933199Ab2GFLGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:06:44 -0400
Date: Fri, 6 Jul 2012 12:06:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: regulator: Does it make sense to set the same ops for
 [en|dis]able and set_suspend_[en|dis]able?
Message-ID: <20120706110641.GA4017@opensource.wolfsonmicro.com>
References: <1341542187.5303.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1341542187.5303.1.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 06, 2012 at 10:36:27AM +0800, Axel Lin wrote:
> Just wandering does it make sense to set the same ops for
> [en|dis]able and set_suspend_[en|dis]able callbacks.
>=20
> Or these drivers need fix?

These drivers needo to be fixed, using the same ops for both is actively
broken.

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9sZrAAoJEBus8iNuMP3dwz4P/ig4qH+42gTWkcO9/i24sGMV
8MtIyCPw0pZHeiiSKO0NokFXXMHGgpzu+F9lu/sIgUh8uzhXxpeBDnVR3M0kIjcf
xB3cHPWNe/EZnx5Rh51ZUon+aygpfgYmJZcHeWIo+iUoNExl53W9Ky7EtjI04R6W
uY1F5pdsSXiOYcQsSPnZ7yDEOAi0Yn0srs/toMAlgciNVava9nTo7zMhxsQ/mtMe
9AlFfp7Kznx7g+KLDKmQyP9b6tcTbu/iSQfTcfyYQyH44HJA5ZCQaJrXBw2sDf0H
1T/DgrHWW8s5u5sTPD4o4dfhEcZxcBdMcSgCK75/I+N4T9/l3a0aiwi5Xsy699Co
8zWPPkjeem8gvUZGrLplWSaqRRUvXz9xLq4uw5Ccp4qZyaVD/jtE17O1bsoigepM
XzA6WeimcyiNvmW2leYQKdngJ9WvPJPRlG4V6+Sj4aRzYcy2sxaR9UidCfO+o6ZD
ZKfv5KKEXe0hYPSpbgq43MnzGyxu1Amks/0aWYUWEE/tb9uPokjuUPnAbBUsKizM
K+ZIRf8n2mItWyBeB8vOagHfhNJ0lz7cTEIjGHuuNgeyvXWYAqZgEuiplF+mlc8i
szHEc+z2syGVrY53HpGH3J2hLriE06lIccq6sgXu8Sn3oV8OGCw/a8Eiuxxs3YMz
u3etrZYSFAskydIYR32L
=NU61
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
