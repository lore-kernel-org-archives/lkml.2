Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab2CGTa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:30:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35478 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab2CGTa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:30:26 -0500
Date: Wed, 7 Mar 2012 19:30:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: tps65910: Configure correct value for
 VDDCTRL vout reg
Message-ID: <20120307193023.GC3107@opensource.wolfsonmicro.com>
References: <1331118545-26514-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nDtE8k2pYjsRXajv"
Content-Disposition: inline
In-Reply-To: <1331118545-26514-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nDtE8k2pYjsRXajv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2012 at 04:39:05PM +0530, Laxman Dewangan wrote:
> As per datasheet, the voltage output is defined as
> from SEL[6:0] =3D 3 to 64 (dec)
> Vout=3D (SEL[6:0] =D7 12.5 mV + 562.5 mV)

Applied, thanks.

--nDtE8k2pYjsRXajv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV7c5AAoJEBus8iNuMP3dTYsQAJGhTczM5fCNZVROihrgoU7O
7SmouS4RhEgkZIcutO78BkvGiRbU7w5bmWNUaTRthPcenNK++wQn3+GvWqCoLz4K
dEWBn2/AZOF13FwaLZNZxqL73tbh9rCgI/sYIqiwwd1FZylSp6tIf2s2WAXq/mGU
fJGzymdslcohjn4xMi3HEdYkFFRUT21HI5J25JvISpiI70JUVtXYALjb0bShgCVE
YYjyt9jCmeoyma0LWS37vVnk6FnPWMgqBK4QE7HCOyPntnnmg9b+FMyjWFmRBbNt
PdwlCkp5hunsE6df6Tm/PdJ4Mc6rJfWfk3E4zNw5zitm/uScn5snx+mTxK2tf5D9
KSrUN7h+nMWsrnhU9k4VoATT3HZ+8g9k6K+39giFe2JJeBmJeMtGqRebmaFd9Jlw
4k4e5q54LcOP1YKDgEM2hFxHAbWYQBsOCIE9i9tQxztMy8yjfMtmuWrk2Ug4/869
dKEcbkTKoWAfs9VKYWo+QLgC0ppAAkF4um7HY1l1jGHqzJ3rN3ZHviZWtgtPNvC7
avBXypKIKr9h9wyuebHCdJ6/fy38Rne8fIZCZmNhmzdhg7uLvmNs46l3Z/DoCwNL
VmJhF2T1CFGPGbVzUp2J2NmcEcgDk7l2rS7TuXgSV0Ttu67duYYfKewmDd4hRSkV
qJj3JQqGsKJlxxJbsmLv
=hM0g
-----END PGP SIGNATURE-----

--nDtE8k2pYjsRXajv--
