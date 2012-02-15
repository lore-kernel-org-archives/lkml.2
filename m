Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2BOU2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:28:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58685 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab2BOU2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:28:19 -0500
Date: Wed, 15 Feb 2012 12:28:15 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: regulators: dummy.c vs. REGULATOR_DUMMY
Message-ID: <20120215202814.GA22648@opensource.wolfsonmicro.com>
References: <4F3C0A96.3050105@odi.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <4F3C0A96.3050105@odi.ch>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2012 at 08:42:14PM +0100, Ortwin Gl=FCck wrote:

> I have REGULATOR_DUMMY unset, but still get the dummy regulator
> registered. As far as I can see, dummy.c is always built regardless
> of the config option. Either the option should be removed or the
> Makefile should be changed to actually use it.

=2E..or alternatively you've not understood what the Kconfig option does.

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPBVXAAoJEBus8iNuMP3dAggP/3+KQcloxko6PtUyucDNU63E
YfCARFZ72uoL7isQ9Nxt/A3W+GNd9eT5slQ6SUA3Jn2oH3q+kAfOCnk2In1iKioW
w9hnPfZSnnTgpsSb4k5mx3qIcl9anGxQeYmyoQ5sslI5HHcl1KfZCI1cKFbrt3Sn
qKI5zbJWxueG8cKXuVYTB5ttVzZJhAs5B9eGs+Tu9Y5OKuHHRvSzf/5JIrBIL94l
J4/bzlgjaflFvTBtwofo3gzkB7CasrJJMTi9I3ACBH5MDwT+HYZjqp30Og86DC1b
oEq4K55uFq1S2U6mTts3V/Heh/D4kJMFwySHetr/eaKvm2gYr1VAdgKnw5bAiJoy
Hbj5exgeZvAZKFzFd1R0KsxrfC6SHewx6LbbsSh5BoUFwHhdJkm+OLThdAAFvAvr
YxXdMrrT2iRCf/LK9tyJbWWOv21NvQzRREQOa1DSrsOBryWcmF29nYnf2eL+FMC6
ux8BMuTYosKgJXId5yaj2I03fIg4DXWTCHon1lfZ4vgVB2RzzBBmE3Wq/fjAGa1o
d4zVoB9oWJNyNerpJGajEmd3ZjgqFccW7GFK5XjazGdUGkIb1IVmSCSjuUwLJa08
MA4dz73Io+mrBLHe4ZFCC1za3CEaWLUQ6XhsTROOJt9DfU83kmV7MEm+7xybEi0a
jV4xb4O8Ztkh2aomY8z/
=FPCN
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
