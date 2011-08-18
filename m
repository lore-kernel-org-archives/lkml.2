Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1HRKzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:55:19 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38649 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab1HRKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:55:16 -0400
Date: Thu, 18 Aug 2011 13:55:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] MAINTAINERS: add myself as co-maintainer for OMAP USB
Message-ID: <20110818105511.GN14514@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313664504-956-1-git-send-email-gadiyar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yAzUYvkKIfeS0jQX"
Content-Disposition: inline
In-Reply-To: <1313664504-956-1-git-send-email-gadiyar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yAzUYvkKIfeS0jQX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 04:18:24PM +0530, Anand Gadiyar wrote:
> I'd like to help co-maintain OMAP USB support. I've helped
> out in the past when Felipe was away and would like make
> it official.
>=20
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> Index: linux-2.6/MAINTAINERS
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/MAINTAINERS
> +++ linux-2.6/MAINTAINERS
> @@ -4326,6 +4326,7 @@ F:	include/linux/isicom.h
> =20
>  MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
>  M:	Felipe Balbi <balbi@ti.com>
> +M:	Anand Gadiyar <gadiyar@ti.com>
>  L:	linux-usb@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>  S:	Maintained
> @@ -4656,6 +4657,7 @@ F:	drivers/media/video/omap3isp/*
> =20
>  OMAP USB SUPPORT
>  M:	Felipe Balbi <balbi@ti.com>
> +M:	Anand Gadiyar <gadiyar@ti.com>
>  L:	linux-usb@vger.kernel.org
>  L:	linux-omap@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git

I'm concerned you will just vanish again. Last time we tried, I even
dropped a mail to Greg explaining how we would work and you just
vanished.

I'm not confortable accepting this patch now. Let's first see how this
will play off, so start helping reviewing the patches that are pending.

--=20
balbi

--yAzUYvkKIfeS0jQX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTO+PAAoJEAv8Txj19kN1PHMH/jxYO71vXvng8kqnox9ox67I
N5ulHvVTIW2y8/uLYRejFvWbUz9HASfJZiKB/BTs1E/N32q7bEb9eGtUqj0BB7LR
M/nv7nff9UEmHOCeOD2Ju1ww804SU3hh7qVYYqUq/N1rqb4SPcLrXSb7Fg7zxBME
VGDLBAmUlrMe8GivOXO4IpRyp6oLVesi2swit0hEGkFJiRYn2tTSBJ5omuGQaRch
8cqPQkrpU3eruX99DDwbnNjcfbbaBlMS6u3H6/xp9VODciY1OG8noO22uZcy8jTk
VvA3ujiPH5OwTAsa9ghvmEYqQ0/U/OLm6k38LteYxYagKLkAst3MUW1spgDWVYY=
=Rpz9
-----END PGP SIGNATURE-----

--yAzUYvkKIfeS0jQX--
