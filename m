Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2CKMAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:00:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58002 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550Ab2CKMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:00:45 -0400
Date: Sun, 11 Mar 2012 12:00:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix missing prototype of devres_alloc() and
 friends
Message-ID: <20120311120042.GE3233@opensource.wolfsonmicro.com>
References: <1331324248-1599-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ep0oHQY+/Gbo/zt0"
Content-Disposition: inline
In-Reply-To: <1331324248-1599-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ep0oHQY+/Gbo/zt0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 09, 2012 at 01:17:28PM -0700, Stephen Warren wrote:
> regmap.s uses devres_alloc() and others that are prototyped in device.h.
> Include that to solve the following:
>=20
> drivers/base/regmap/regmap.c: In function 'devm_regmap_init':

Hrm, what I want to know here is how you're managing to build this file
without including regmap.h which includes device.h.

--ep0oHQY+/Gbo/zt0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXJPjAAoJEBus8iNuMP3dCa8P/jBjt2KZPUix/dB50izpsuWk
Xmn1KIQFLJlzrZP9yih/YUAtBXMISnAfb0Cbq4aI9mQAD0nOB/THiJVEfxOaKROm
B16TQJwkDdoR4TnJjLOZZqNroP8fvuy72La3IrAh1VG3g9w+YQCCC33mK+LMIAGb
umPwebcIEG/HOxuFOa9OF9nzCBmxPbhzj9d8N0paUErhCsEKDIzGUBFPDQKKOxtj
5T9KqMX2Ujp/4sItOZigqrE25XaUcVykUsAQTH9GeWM91QxGNA6ugQnzyGzC1fhn
iB5husIALo2UNt7aX41Gi6h14i3vopEW0mHvNNUieY1Y0SgqXXX/7PQhIQrntbhp
UFjhzeE+vtUmRxgOB3I9ehweNHf5rV+Jvs74O6sQsPPjPSPVBmfap7Ob8VEBHyg2
jffvOVJwgyHMC835wYbjzC+nhcsR4tL5fA31uekJHTQsVAO60iQfTwk5PBw7/WPG
YZfKsBr4uUjIVcIJetXLyOvKNNIwOowYfc8hO7Gw08jJTLt68xHAfPVvW+SwwwqE
qK9QpzIbpZqB0Na041Eo0EBpRBylz86VaJwAZtqhh9iPjieuLpe1MxEfLtPVyhZC
7XKLgKdHZJFxQ/cvjBLkuQp/BtoYUx95xSaflI1OMR9aXhu3IxzR2LiiLg4zLYW7
Av8ahMq3pQfP85px7tla
=8ap1
-----END PGP SIGNATURE-----

--ep0oHQY+/Gbo/zt0--
