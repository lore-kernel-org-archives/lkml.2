Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2CZNAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:00:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38377 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155Ab2CZNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:00:10 -0400
Date: Mon, 26 Mar 2012 14:00:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120326130005.GQ3098@opensource.wolfsonmicro.com>
References: <4F6BCF47.4090200@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IjNIXuzrMEaOuFwn"
Content-Disposition: inline
In-Reply-To: <4F6BCF47.4090200@codeaurora.org>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IjNIXuzrMEaOuFwn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2012 at 06:17:59PM -0700, Michael Bohan wrote:

> I'm curious if there was a reason we didn't standardize on a binding
> name for regulator supplies when using Device Tree. This appears to
> cause duplicated code for regulator drivers that support devices
> that may or may not have supplies specified.

Supplies are *always* specified using the name from the part data sheet,
anything to do with regulator-regulator supplies is a Linux
implementation detail.

> Also, I'm curious why we need two pointers for the supply name.
> There's currently regulator_desc->supply_name, recently added for
> Device Tree, and then the old init_data->supply_regulator. Is there
> a need for both?

We can't just break the build for systems using supply_regulator.

--IjNIXuzrMEaOuFwn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcGhCAAoJEBus8iNuMP3d7jEP/Rp+GPrJE8oyBhkupgUK0nh1
gf1z3VTyAdMDca+Gh5M0165SCBvwLQm7Cv/cy5Xn16WR1roLRuX6X0ohAaNOTNbv
pV/Hnz/zzlxk3F0m9idM18HiKsTV/tvVPhKSYPcbp6VXiqXzCT6hxUlpczc5hi31
pHM9/PgnHAwcD2ojPUc6JcoFTMs1XwajVPWk6K6/I6UBSoZBBoAoq7k6q4BAFWSd
Udinm0yqJunKJWu5pO2aGmyZu2v+mMMIIwWNupsqozZZXApERG+gcVNVI6uZg+az
R8YA9OtTjySN/KCxOdTsLHHBVwkrZnRShw8lhDLHf0OAcfQwvsk39KYVG5KQI4Jw
5Of2CNRDQ3HjMR3Q+sL6uXG5Jb6DqzirBfN8Ztop7GeSMF5L3DUcZXjp2IVPvsb3
eIqhQIPFQgoJ04LV9IAiFiui00BbZNAhxmDVZXOBDIYLw+GtAEU/fo8EKRR56Zo7
4V5AYxd1M+U9rstZxEwVTmuBOrtcgZJFYGxGXH5u74odMmyf2jx8s/vSuVcQLbzI
kskZ32cXLNUcuKgFUYN16lxwvHCJZk95+qsseeThItR4GG2HTahR4gSGu4kq0zzM
lxfcCaHNqxoMIlb6ezV/FqUd3s0gMFFukUY8/z0591JVlKzVOhv0LPTmADF9IUH/
ryQY93HDUmLwgc7Pd7Ru
=7ar7
-----END PGP SIGNATURE-----

--IjNIXuzrMEaOuFwn--
