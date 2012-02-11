Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2BKXFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:05:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab2BKXFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:05:50 -0500
Date: Sat, 11 Feb 2012 23:05:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, lars@metafoo.de, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3 1/2] regmap: Support for caching in reg_raw_write()
Message-ID: <20120211230545.GG3745@opensource.wolfsonmicro.com>
References: <1328889628-13151-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ulDeV4rPMk/y39in"
Content-Disposition: inline
In-Reply-To: <1328889628-13151-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ulDeV4rPMk/y39in
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 10, 2012 at 09:30:27PM +0530, Laxman Dewangan wrote:
> Adding support for caching of data into the
> non-volatile register from the call of reg_raw_write().
>=20
> This will allow the larger block of data write into multiple
> register without worrying whether register is cached or not
> through reg_raw_write().

Applied, thanks.  We really should refactor later on to not do the
encode/decode dance if we don't have to but this is fine for now.

--ulDeV4rPMk/y39in
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNvP8AAoJEBus8iNuMP3dYuoP/0bY2CZQ3WI7nFOWrYijdEPa
Veg1+VTZtYEdXgrtZ/7ByEjYh9QnBf9gz5pzsf67Od51EJh7fJeRRhXreUXZ00aK
e4Lxm/rfGz6wnkPEnJSqBulLHXWQhrHP1ADB89fuT151HujKB8+DJXxHl+/bokMl
NlTu61JM3APtlj3SZ9lF7eFE0GQUMkjgaqipTdYEJ2bE1W6R2b9Otmg99GOWhVTd
wismNgu0INp+RIUXFeQNkIa/HJUCCGhlR3xkmV+x/gJk/AsYJqBhacqVwwceCbCc
Adm2IPuzFucwuf2A+x2m3zgABObLgINYgshFSQeIOsc50kVMgM93L5Sq8o6C7sT8
5Axi7IGADygag89dxcA23Nf+Szq5B0r8/MIYtRv9ALLPrI/AzdAkndROiLfj0kyg
Ne1UX+lETjLgYkP3JbizIhxkV4jyUchTiSpKNlXylfj1JrOAtr/qvGZddiPx/LxZ
uj2iCBcVkCI/+pjm+SxMDonEmiv/6yhFSnQoTNWm4zKXRj2EcXjgGcBAQ7iP6E13
IdIYRylSv6fcNHr5bV/U+NnCQQLnRkuzBefM4fYzpHyP7Th9RBD0IE1PbwoQa9ap
D+1Hr06Nsg9at/RECR3SUkc14QcFT8PSc8v+qsnrsyHY25i1Coleoz6xbVCUHD7M
Fy5zuyqFZvtjq+3k/RZI
=ZNEh
-----END PGP SIGNATURE-----

--ulDeV4rPMk/y39in--
