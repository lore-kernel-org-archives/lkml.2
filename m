Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2BIH7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:59:20 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49833 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab2BIH7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:59:18 -0500
Date: Thu, 9 Feb 2012 09:59:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3 v2] pch_udc: Detecting VBUS through GPIO
Message-ID: <20120209075913.GL1121@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328254526-9447-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vTfKKTivj/mQoluA"
Content-Disposition: inline
In-Reply-To: <1328254526-9447-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vTfKKTivj/mQoluA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2012 at 04:35:26PM +0900, Tomoya MORINAGA wrote:
> Problem:
>  In USB Suspend, pch_udc handles 'disconnect'.
>=20
> Root cause:
>  The current pch_udc is not monitoring VBUS.
>  When USB cable is disconnected, USB Device Controller generates
>  an interrupt of USB Suspend.
>  pch_udc cannot distinguish it is USB Suspend or disconnect.
>  Therefore, pch_udc handles 'disconnect' after an interrupt of
>  USB Suspend happend.
>=20
> Solution:
>  VBUS is detected through GPIO.
>  After an interrupt produced USB Suspend, if VBUS is Low,
>  pch_udc handles 'disconnect'.
>  If VBUS is High, pch_udc handles 'suspend'.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

applied, thanks

--=20
balbi

--vTfKKTivj/mQoluA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM3zRAAoJEIaOsuA1yqREbCoP/3/h785TuQLE3aomOzi5NB+d
eUNrnANo7XomxIfesWfJK3y5Mc9gG1jd80IiazIjehkqVRQDJ1NIrqewCXVM1hm6
CbtDKWnBPVN5vQC6NuYdfkCC83lF78Ij6KNZ4zE8mdP18YjEsnwvXQ4laBqbUSth
mg2DL77rMVTB6HX8T+v+P5od09VkA8duMvNz9zePLZOi7Q5TyQDaDnKiwPaqafus
UJxcKRTi29YelCK2HAa37SzbIGI03u28tmov1PTd79Q8AoVwbqfu1y65F6eaneJx
Pogn3fqRpnugT04Gjoxvjy+FnbnydnWB2kfAnVl1pYOFjjVSLc/KuxZ/u42Rd+N0
ZCvXJp79C6pVKrDKuVzFfFjpxR8goBsqe3dZWjiQ2rhptzcIdbcz8j8MsSVxTsul
4SGq70XlIL1qKW2K4WGYU5KKdtZBIK9EESYuDwaRI5sGacXYQtMldGynIyxQxObB
3R/cqk8TUksy7tuJUnfs8K+ULIokKwH1ur26AcK6qfDcAoZUn61M05/sN8QL0v15
nFc80HEAuL9AAYXa+mJX4KDVFASorplFCQpDdzut1aEOBW0Vqe7R8FMiVGp2DZdk
bH5KS26MNomA9kEnhVE9sZiN1Y0w/BZuy2WJGooaZtZvGpZJB62sgcbL+IiPF6LB
Agh5w6eOdei4dZ0qOwqs
=2sns
-----END PGP SIGNATURE-----

--vTfKKTivj/mQoluA--
