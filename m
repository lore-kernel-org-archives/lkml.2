Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2J2OwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:52:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43499 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689Ab2J2OwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:52:18 -0400
Date: Mon, 29 Oct 2012 14:52:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 2/7] Regulator: DA9055 Regulator driver
Message-ID: <20121029145215.GA4511@opensource.wolfsonmicro.com>
References: <1349950164.7957.23.camel@dhruva>
 <20121027215850.GI4564@opensource.wolfsonmicro.com>
 <1351512478.17695.14.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1351512478.17695.14.camel@dhruva>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 05:37:58PM +0530, Ashish Jangam wrote:
> On Sat, 2012-10-27 at 22:59 +0100, Mark Brown wrote:

> > Always submit patches with subject lines appropriate for the subsystem,
> > this helps get your patch noticed.  People do things like search their
> > mailboxes for subsystem prefixes when looking for things they need to
> > review.

> In subject line apart from "regulator" I will introduce "next" too.=20

No, that's not going to help.  You need to actually include "regulator"
in the subject line and not a variation like "Regulator" which you've
used this time.  In general if your commit log looks different to all
the other commit logs for the subsystem there's probably an issue.

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjpgCAAoJELSic+t+oim9j1YP/0Zo/vhRGmYTnvr0oLdLWSGX
3otEwlukLlEXob4taczr7i6wy8pnBg0Sl0WLccI4DlqZCiF2vshtUq7j5BL3ytGu
BvUV16i4nq8sk+H0BIHe3Wu0mohTevYOxvFa/ykXiGeIURlmHL4V/uEMz/Q/cOKT
WgteE2g9m/lvGCQFpz5JepuR4AC3VKHrQdtreCm/hFQV5VH5tT7osplzm5Rxa0kd
qKGlRXhmJznINRsjW8AVZIXKtmH9HUqLwM2cXM12yPowBierV+aN72spDG4oR3kj
tIGVWE7K2EzkQjwVrPOpCQhIK5LU26WGKezGDS5gbkapNSCMBKCmj8IdJb+OW4Qx
+6SA5AwytocvFA645krWjrdVCTsppzfeZ3VuxFjMCd6Bxc4gbyisYoN/bJI1N7g5
ErzYvkgwMJ8tzJ6UpjshciF03R2/UMdvGhS9z8x0E5/kgGoGDAgFqawo08p7Cerp
gYP7MxQp0rc/9pNicLN86tNR58nyYS/Hwxo/wIWkyM+iB4Eppe8zhr3Pvr8z1HEy
Rx0ntnHQUlbpNTrNoUPEKTIcNDdLNE7qpnENk5QuWo3vfIrJmCry3M5Fd4uK4/g7
4qbWIIoF5/sWaEXsBtOd8XClYWh7mOE4eHOP5r4h0pzRNPCQm25ZkhfS3iFUxugU
WEHjtnivsm32shCBXrcN
=uBoM
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
