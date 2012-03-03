Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2CCR6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 12:58:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52844 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab2CCR6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 12:58:41 -0500
Date: Sat, 3 Mar 2012 17:58:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH v7 1/2] mfd: Add anatop mfd driver
Message-ID: <20120303175838.GA14833@opensource.wolfsonmicro.com>
References: <1330671641-6439-1-git-send-email-paul.liu@linaro.org>
 <1330796352-6884-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <1330796352-6884-1-git-send-email-paul.liu@linaro.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 04, 2012 at 01:39:12AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
> Anatop provides regulators and thermal.
> This driver handles the address space and the operation of the mfd device.

Please stop sending new patches as followups to old versions, it tends
not to do the right thing in mail software.

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUlvHAAoJEBus8iNuMP3drrYP/2xE7EAjhVP6oixGKarCF8xI
OHfyRuUJzw7I7QWwdfUBqQyKSqWgLpSpDd3b1ugkQFxUNo+06IfEIRtJv2Rz3wFL
ZyoLrmmwbD/D08fkqFdqdeU6hledkXooS/l7YtpIUoGDfNsOoPYicLx+I9OS+9DQ
GJPigrBgziPRymIaJC3FYwL5vKNUz1a5z3g93UeRB3+VvbTejczENhRY6XRWBS9f
RTbo2eEGyDofFkfxNbDs7c9GDdFSBXOVGfpLUZQFTFEp3pnVvSn123ifoaU4rCSh
t1jC8NcSp88Hf07sD0UCV9+L1JdbDyQqYS+u7laCMDlBtR2LJ6e3e477lx8VLK0S
7d1Qkx/9lKfSMC3Kn049HQ56iVsz1096WaB8zUyzcGXj/hhgzFM+iU2rk+2K21tI
jeggNYXc0/L2NkqVq9vZNJrZZaT/W18zDOKitDR8Wu8u7IFlzFWtHslgLZ2r6PAq
4CoShFsGoZLHrD25iiCqiP7yH2UDCsSw1ql/2tD82HihO1p06xQB2eWiO1cviW42
NUVlaevhymv6d/8uR5TkKcunqFu86HFjnWBdAgw7Ui7lgpE5TC10S3MN/CzTWK8O
Si3mVDHnts/DpCWG/imd3PQ0m4dVFsDe+5iIox3eTa3CZHVO2HDohkZWO297E2ob
S6Gw0qfpJr/09zmXPXvj
=b5GB
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
