Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2LJOpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:45:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44729 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2LJOpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:45:31 -0500
Date: Mon, 10 Dec 2012 16:38:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Rajendra Nayak <rnayak@ti.com>, <balbi@ti.com>, <sameo@linux.intel.com>,
        <tony@atomide.com>, <paul@pwsan.com>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <keshava_mgowda@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <bjorn@mork.no>
Subject: Re: [PATCH v4 23/23] mfd: omap-usb-host: Don't spam console on
 clk_set_parent failure
Message-ID: <20121210143806.GI11038@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
 <1355134833-5199-24-git-send-email-rogerq@ti.com>
 <50C5C666.9050105@ti.com>
 <50C5C80A.3090307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IR1Y5IvQhrKgS4e6"
Content-Disposition: inline
In-Reply-To: <50C5C80A.3090307@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IR1Y5IvQhrKgS4e6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2012 at 01:31:22PM +0200, Roger Quadros wrote:
> On 12/10/2012 01:24 PM, Rajendra Nayak wrote:
> > On Monday 10 December 2012 03:50 PM, Roger Quadros wrote:
> >> clk_set_parent is expected to fail on OMAP3 platforms. We don't
> >> consider that as fatal so don't spam console.
> >=20
> > And what if it fails on a non-OMAP3 platform?
>=20
> The driver just prints a debug message and continues to work just as
> before. The USB port will not work for the user in that case. He will
> have to enable DEBUG flag to see the debug message. I see this behaviour
> better than before where all OMAP3 users see the error message for no
> reason.

I agree with Roger here.

--=20
balbi

--IR1Y5IvQhrKgS4e6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQxfPOAAoJEIaOsuA1yqRERAIQAIa92DSzixbvgeH2NVfmif3J
CE0KTv+Zl3Rq6k15D/NlwGQUBCem161usptzwgy0uk8yW/TYEpWKTRL1Vut23v4U
pyVAK/KBBsO1+Z9B8ZOq8gFfs3/8VTk1Co8GPydvcdO+JrzPkw78g0AbmpvmHiWH
im1o1Cc3mpMKRmZumCSl4S7BBtyPwSPZRpemrgsV9fy2TXumN3gFYLEz891IuVLY
/2GfLeGNAM9eo6+LI0l+CSTXo44EEHiJSM4AIgP6H6XUx3dPzBcIGCjuGvJRsTX9
oGDn4OB9EG7oe5hU0OlCeJ3SUImIOvyl4xQ8gnBDK0uC1FA3Db31bDT3LkWYtBub
YhN9gfE1VfZGDccjM2NBJioyS+0xHKMIZMAI4hf5nBG/3Ybd6moiFcLWaKXxQXHt
1VecvbRIoMFHzVSL4l83U0eYMyVXP/ylhYbi9F7U7WBFDDzOMTqu8CzLJCtFKRql
YbW334qoUhvIa/ol3gvpv9eZQ4gNQ7PLJY7r/HRVe+iEqOUhogEQds1jz11aycPB
Q1wg5LEJqfmbOPGs4CuwEDUju+o5IpRnTpFsdLydg5wGMBLv+JpoVLFjh7jJflzu
Mlbwoje0V8omZHtduqbn2VyuhJMXyfqkJidasJmAPcNUEScSbNU57P/F5uFa9PZR
A20JchdhOOZVDayAsLZq
=Hswt
-----END PGP SIGNATURE-----

--IR1Y5IvQhrKgS4e6--
