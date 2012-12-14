Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2LNBoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:44:10 -0500
Received: from ring0.de ([91.143.88.219]:57371 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2LNBoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:44:08 -0500
X-Greylist: delayed 1220 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 20:44:07 EST
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
Date: Fri, 14 Dec 2012 02:23:36 +0100
From: Sebastian Reichel <sre@debian.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH v3 1/6] watchdog: omap_wdt: convert to new
 watchdog core
Message-ID: <20121214012336.GA402@earth.universe>
References: <1352746025-1669-1-git-send-email-aaro.koskinen@iki.fi>
 <1352746025-1669-2-git-send-email-aaro.koskinen@iki.fi>
 <20121112224703.GT6801@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20121112224703.GT6801@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2012 at 02:47:03PM -0800, Tony Lindgren wrote:
> * Aaro Koskinen <aaro.koskinen@iki.fi> [121112 10:49]:
> > Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
> > multiple watchdogs. Since the new watchdog core supports multiple
> > watchdogs, all watchdog drivers used on OMAP should be converted.
> >=20
> > The legacy watchdog device node is still created, so this should not
> > break existing users.
> >=20
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > Tested-by: Jarkko Nikula <jarkko.nikula@jollamobile.com>
> > Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
>=20
> Wim, looks like these will cause merge conflicts with what we
> have already queued in omap-for-v3.8/cleanup-prcm as patch
> "watchdog: OMAP: use standard GETBOOTSTATUS interface; use
> platform_data fn ptr" along with other ARM multiplatform
> related clean up. If these look ackable to you, I can queue
> these that's OK to you.

What's the status of this patchset? If I'm not mistaken it is
neither included in linux-omap, nor in linux-watchdog-next.

-- Sebastian

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyn+YAAoJENju1/PIO/qaBcYP/jSMMRZlISvcFTJDx/RUz1O+
IEwSej6v4920ji2vm5WdbbSDsGuaB9DjOkzr4UJGfIKaANIcdj3p4Acv7EO0Tpxi
eEw9fZ0Tun8DBRm145DC36PAIMEJNUe0bFK3iafnhsA/mdlLN59QWPTCLAwDje1z
DugcrqKRQZxkk8C86m/NLZ7rIt03LvcipDI+wsaPcLwVzeKhlMqyw87XHh+dnMRb
DR45EoXYFWnxgrCnvbY88kpSm0hOLii4xRDWBBBZA+IZuiFZEx1zG+VK0oo5GcWH
E7FIqw5wrm8vAQG9jbs/34HtRnwhehO1n8k5pY8mW7SA9UgMTPoqrcNljYtUfGZJ
pEY8p65URr0Dxq8qRePCiUJKpCRakklmBlA/gRnDj92eqgUTft29NymX8Haho9T1
Uyu2teTs4A65sLkXUXnmWpOWomtZ9AGmyiBIlN05l22fHAFpTwmY1+ipgNYX+bO3
eAdPbOVPnAcGnzO14ZlO1O+CBi/C8PZw/cKZrMnBMm/dwDDT1ILfIeV7Lk/PEd8H
drKOB8ff7PRJtq21JSXg9ar8+hcurTpT/FKcS8w/GndH6Bq/YJsYoPAZEfIHdHV5
JT9zV/y+Pt5Si3xuAjUVqwdeAcksF9dlvHoo7NOr8S25/vyXM3+M3iJJbm69McnO
TrT3ZVdGi5liQhnH4A9j
=EY59
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
