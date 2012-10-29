Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2J2GU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:20:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46387 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2J2GU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:20:27 -0400
Date: Mon, 29 Oct 2012 08:14:27 +0200
From: Felipe Balbi <balbi@ti.com>
To: Constantine Shulyupin <const@MakeLinux.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <tim.bird@am.sony.com>, <pandaboard@googlegroups.com>,
        Tony Lindgren OMAP <tony@atomide.com>,
        Santosh Shilimkar OMAP <santosh.shilimkar@ti.com>, <nsekhar@ti.com>,
        <balbi@ti.com>
Subject: Re: [PATCH] Add FDT support to Pandaboard initialization
Message-ID: <20121029061427.GP17570@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351363800-28744-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <1351363800-28744-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 27, 2012 at 08:50:00PM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
>=20
> Problem:
> - FDT is supported only by generic OMAP board initialization in arch/arm/=
mach-omap2/board-generic.c and lacks some configurations, which are not yet=
 configured in FDT (USB for example).
> Solution:
> - arch/arm/mach-omap2/board-omap4panda.c supports initialization with FDT=
 and without it.
>=20
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>

NAK, the whole idea of DT is to drop board-*.c. It would be best to see
the "missing initialization" being added to board-generic/dts files.

--=20
balbi

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjh7DAAoJEIaOsuA1yqREOGQP/0+3Up8ExM94GhgldMoKYLEx
1WsAMRReXR0QDLe+rJDxfzHoICgz1Mc7QzsammNU6q9va6q4pLt6Mq+v6VibsfLe
FWiejPJCUixvklmy25FZ1Vq8Cb4NTQCIgubBK26Bpxd9j6wZFNz33ygFWPw1UPkb
pVgsLlpkViiilLrrrD8f8ZHQy7H7EajiwtrC0d1WV6N7LaXsNeKFuML/TfJrqNKY
9iUINrTf+OC3G8tS4UFuGesZ3dt+MWVNoJKCV9z4xeXOh7wgah7LX51DKW5RWtiF
31Tpcyp1DBxzvNzWm5Xdl/OGXJBOc/SaTnJu9Tm/RwHG45W8HMadCqWvW/TOg+Vd
k1oJr7+BNebKkFP/Uq/zB0E6jem+C2tmiWLXdq8LnYbc8b8DfqLYHD9D4A3pyB/m
FTwWqPoJQttUSnE9YqXDqQwM6XLH511LdzivYq3n+JSUvcv5BqGp4bly8NiZeFCO
99DDUiYrrLDI/fNGuP046uJzo/M3UpSUtmLsNGnZ6DmlHEd+euRBuuiGVR2bwWZZ
9FsyA+k1tRc/qcVhKLOq9LnFNqBLovhSGxN5bJz6beAy+pgcfNQftQbl+Qu8Um0S
CVNQMWq0f9c+FoIataBNTW/XYw3dXB63KRaax83uehOLME716JBIjyn19jVMTMpN
Hq3AOUmK+xRRb9H8S0W3
=3EdU
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
