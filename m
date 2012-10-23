Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708Ab2JWXQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:16:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:34931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965108Ab2JWXQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,637,1344236400"; 
   d="asc'?scan'208";a="209725104"
Message-ID: <1351034166.2252.5.camel@jtkirshe-mobl>
Subject: Re: [PATCH 083/193] drivers/net/ethernet/intel: remove
 CONFIG_EXPERIMENTAL
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Date: Tue, 23 Oct 2012 16:16:06 -0700
In-Reply-To: <1351022666-6960-84-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-84-git-send-email-keescook@chromium.org>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-U508rRb+m5SiG8jiH7FN"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U508rRb+m5SiG8jiH7FN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-23 at 13:02 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>=20
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
> CC: Bruce Allan <bruce.w.allan@intel.com>
> CC: Carolyn Wyborny <carolyn.wyborny@intel.com>
> CC: Don Skidmore <donald.c.skidmore@intel.com>
> CC: Greg Rose <gregory.v.rose@intel.com>
> CC: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> CC: Alex Duyck <alexander.h.duyck@intel.com>
> CC: John Ronciak <john.ronciak@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/intel/Kconfig |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)=20

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-U508rRb+m5SiG8jiH7FN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQhyU2AAoJEOVv75VaS+3O6s8QAILOGXF6/YjH5E3HZReiwjMp
m+Ur+nPyixHMCqqTbI7vxIEkvxcv3FZrL2JX6M5fMmGElAxe9mmXbB1Rz2ekOueV
Hy/VsVa+uK9ufFNAm44F8uV/2Kq7JJoY8G6OkJlnZXXu+al7PyecMB0pzrYIzgPN
FnzBGpZYGOHLqedesdSXSNU6xB/1y1GShHSUssVmRECR7JprYcYUX6WNGaTQK1Oy
zF37EX3sHTjw11OoI266BGc9oGvOZufKNVTUig3NopRxztBs9GZgqyVaNrvaqquA
XPZTxKBiU3G9kLDdkjaIC0sv/6tb33O25e3IgcJ4+uw/mWz3G068rDbtFamt/3Hg
YaiDX0Q2h/TdeePHjaA8yrKSA7JqB0Xq8chKll8jw/diu9xpIgQsrMVK7Q2aCisD
qm+sCkE3CrtX8o1gQV8xys8uoUxAAv+t8CWpjtFoV+fhpvqbop6fg++Y0SFpaFjO
HmvuUCMj2oVHETcKIUjdNQUMT8Gln5Dh+fCSli0PRsar8UdMyNiX/1+OB+V85iNY
TPxLsBTgoEvpRMOjVRSH+PGoJKSOGZ+JqRST4QeaQ0rmOjOSwTbkkGo1Ctd3UOOc
bAImmfPqcIIHXTbLqHqtmeGoe6N0KmeGgDHfW7C4ECD8mEkiLJL7mL3Zh07vShBr
bsiodWHWZ2cVSR09YExA
=oSPN
-----END PGP SIGNATURE-----

--=-U508rRb+m5SiG8jiH7FN--

