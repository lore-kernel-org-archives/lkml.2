Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038Ab2FVK3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:29:32 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37462 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524Ab2FVK3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:29:31 -0400
Date: Fri, 22 Jun 2012 13:27:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com,
        Vikram Pandita <vikram.pandita@ti.com>
Subject: Re: [PATCH v2 1/5] usb: musb: move work_struct(otg_notifier_work)
 from core to omap glue
Message-ID: <20120622102712.GE28472@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1340010262-22025-1-git-send-email-kishon@ti.com>
 <1340010262-22025-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <1340010262-22025-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 02:34:18PM +0530, Kishon Vijay Abraham I wrote:
> Commit 712d8e(fixes pm_runtime calls while atomic by using a work
> queue. musb pm_runtime_get_sync call happens in interrupt context
> on cable attach case. That can result in re-enabling the interrupts and
> cause side affect. To avoid this deferred processing is used)
>=20
> While the issue and the work queue implementation is specific to omap
> (omap2430.c), the work_struct is defined as a member of struct musb
> (musb_core.h). Hence moved the work_struct from musb_core to omap
> glue.
>=20
> Cc: Vikram Pandita <vikram.pandita@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

didn't apply, please rebase on my musb branch.

--=20
balbi

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5EiAAAoJEIaOsuA1yqREQOUP+QG3kErP5qIlSbPLnZx8Xg5D
CWzJgx/Qe8F3HHV0h+VYsFsW/owdPxfN1n5t7Fm+/Aenf5hTmowvbJqRLuabb7Uu
J+4TAxIPKFx85/v2auXPq6hs+e746QvJ4RWXu+9nS2y3/qyvX+D2sT6pFBb1Ze32
guYB79hnKfl8By2JIfu//w7c1WkFlpeawsFvnFNC1JoD6uSoXW2e5xft8rYlYluZ
Rns7ztqdj0kOcq+9BF8HDBGXkDiwgk3OJ25/pL9+fM77Td8PnIS25RzLPAys285g
0a5qD1I5WLytvuOT887lwzZkFxb4AOKlXgbSLTl/VAcCsLumqGS+0IZQCv1RQ4vo
eyjNDMs27HDiOizOwPIO1cBaSOw1C0mQ8RZgzCVxziJ/Kbpn5qxCiASeAdAgyywh
9Bbnf77G40YsXqyBwl+CGiAECwkT5wnkSpdlBI1UZMSF3QFZy1piLvWo/ZjT6B65
Gbd97A5C7WzRSmaEJwaHKresczZNtUvmM2z7wLEg6uNrmLqWsUqsj/TalePkYkX7
ftenSiu3ZOpXP+7JLKOO5hGsGTiNOhQ1cxeP2J4bTsGXTyNy1kkpLa7ND9aDgtb+
jbnYo82o2benIvUUfl3m02tKaKz6YWd6cxs4lwDqnU1+T/roykFo4y+92yeD49h3
Yd0chmYjnEtvW/WVFJ8Z
=58um
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
