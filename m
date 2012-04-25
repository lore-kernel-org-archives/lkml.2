Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2DYHr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:47:58 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:34832 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347Ab2DYHr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:47:56 -0400
Date: Wed, 25 Apr 2012 10:46:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120425074639.GB3423@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
 <20120424195645.GB3628@n2100.arm.linux.org.uk>
 <20120425083747.466f5c98330af8964d980b8c@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20120425083747.466f5c98330af8964d980b8c@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 25, 2012 at 08:37:47AM +0300, Hiroshi Doyu wrote:
> On Tue, 24 Apr 2012 21:56:45 +0200
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>=20
> > On Tue, Apr 24, 2012 at 03:05:14PM +0300, Hiroshi DOYU wrote:
> > > The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> > > High-performance Bus (AHB) architecture.
> > >=20
> > > The AHB Arbiter controls AHB bus master arbitration. This effectively
> > > forms a second level of arbitration for access to the memory
> > > controller through the AHB Slave Memory device. The AHB pre-fetch
> > > logic can be configured to enhance performance for devices doing
> > > sequential access. Each AHB master is assigned to either the high or
> > > low priority bin. Both Tegra20/30 have this AHB bus.
> > >=20
> > > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > Update:
> > > - Use platform_device to get info from dt dynamically.(Felipe/Arnd)
> > > ---
> > >  arch/arm/mach-tegra/Makefile    |    1 +
> > >  arch/arm/mach-tegra/tegra-ahb.c |  285 +++++++++++++++++++++++++++++=
++++++++++
> > >  2 files changed, 286 insertions(+), 0 deletions(-)
> >=20
> > 1. I thought we weren't going to have any more drivers under
> >    arch/arm
>=20
> Can this driver be located under "drivers/misc"? Or is there any better p=
lace?

maybe drivers/platform/arm/ ??

--=20
balbi

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl6vfAAoJEIaOsuA1yqRE1o8P/jyrVuTWZkuqqMAI/mbLL6xo
u17mdNfmPC/wqtvbzljhdafLB9PHW0W8To4NZcXT1ojNPyMdsYeEc2zwhMDXJrj3
8cQNfI3omaPAfYrz3pdWvDpnkhWN1VPT9nM+MqcIWyVcCgYRCjMiDH5P7mWH0aIa
QCCrRuMfoSeV3GuSYDiTgeYNZgvOQwjw1pCOwF4lbCGSoT4FndulWUzC1Z2xN9/7
m3D/st8kY40hbp32viQwxPPUDQM2kJjfUCijs+RRyMPkFAVySWHUgAtbmDgS7V4p
E30ExEV5qkdzplbphtjRnkV5CnaTdl+4uFJxXuEEiB92Prirt+17xKsjMkL/MMes
uaMTNkZr4nMgvBGDtcjPWDpBzdMesWRzTz+QcKwZBP/hNy2AxYgTBNosDLw5JKeD
tfXZ58Hr42CpsRMsM2uZkBSmC+hcxFJ55JgEuWLAppOfKH1SryR9r6xZgnz7tlNC
K9HkEofj+ruz2q4uE5pHOd8X1DixGOdL0XPBdK3WIzwWc15rH8YOGI5RgJTNx6bG
VgS/M23qRCd5Ky17VZssbc0DXFc5desbKM9W0SIg9P3cM/K7oL8N0XpxlvV3rNx0
kr5QE+GPFHds8wUzAz7fxI7WWRfna++Emp/GBCDlrDUDCY0+EstNKFnAXBgiPypm
Tp2eVknArhrpJ8KQLkCq
=758m
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
