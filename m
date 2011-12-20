Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1LTMDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 07:03:55 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60550 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab1LTMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 07:03:34 -0500
Date: Tue, 20 Dec 2011 14:03:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:MUSB MULTIPOINT H..." <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 10/10] musb: cleanup kconfig
Message-ID: <20111220120327.GO31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-11-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Iys0Un1O+0sigPHU"
Content-Disposition: inline
In-Reply-To: <1324341747-5922-11-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Iys0Un1O+0sigPHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 20, 2011 at 02:42:27AM +0200, Felipe Contreras wrote:
> The whole thing depends on USB_MUSB_HDRC, just add an 'if'.
>=20
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

applied, thanks

--=20
balbi

--Iys0Un1O+0sigPHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8HmPAAoJEIaOsuA1yqRE7eAP/ibXFRTdgUbCeo6wHNuEtnfB
9+K+lEkiL7kPU4VA5S8wyU8+Gx0Ane8G0BZrGwdjSrzTA53tdEKxgoX5iw1huzIi
jr9coLWu6N/UqOEu1wXXqxWj+K4r1p+M/VzyUY4Zy0ib+VWF/biVsP0eOS0t+56z
7CJ3eEQSW7Hodjhx8byzg9DL2j567z7ENE3AadJu4OkET6bNDNHdJcwcc9bmd1P7
Y8PTvxHYTfMRuUnbKB2lAZfbBtn0veX3sx1dskJ7oCjx9g+o/hQ27pF5Sf4uGvji
x8WHtnzmUhL0gckIZHulaQt6FjRZdjQgFqZdkwPRryNQvZMCrZ8cGcxrevYK070z
Hy+sfe27MmFBLdLU51FSjlE9cMyMpSgtsNZIPxlKCKbf+UOm5zf5Nz25AasT+xFC
Nv7QaKSyRCvhbShO+NdUYIWfPAYhLxkC8B/qn2Weydoo7AXppeh1m3JS+nr+7sBz
X2jjm8FNA3nDAGHfsGAJJRko//4y4mTMEk0X+QAem1frk5Z+X4G1w3G4u7Eyg9k8
lwhah3r9UQM+QFDvrp0ll+46YE4RFWHVQtIEMSeByM9Gk6OTx4R1szlxuVCptiu2
E+wTT5iexpnGnQRBy6PpuB4Qk07N6SLHuBaNVMHItlticixGfWyL4l/FzAi/7dfF
msTotA6aK0+QbCIZGlx6
=pwHS
-----END PGP SIGNATURE-----

--Iys0Un1O+0sigPHU--
