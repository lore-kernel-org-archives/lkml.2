Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab2DJKn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:43:28 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:34966 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757911Ab2DJKnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:43:25 -0400
Date: Tue, 10 Apr 2012 13:42:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 09/13] usb: gadget: f_fs: Remove lock is held before
 freeing checks
Message-ID: <20120410104227.GK20616@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
 <1332895637-32572-10-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCF9ydJxlAJsfRTu"
Content-Disposition: inline
In-Reply-To: <1332895637-32572-10-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCF9ydJxlAJsfRTu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2012 at 05:47:13PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> lock debugging already supports this, no need to do it explicitely.
>=20
> Cc: balbi@ti.com
> Cc: gregkh@linuxfoundation.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

since this is part of a separate series, I think it's better you carry
this with the series:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--FCF9ydJxlAJsfRTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhA6TAAoJEIaOsuA1yqREVJQP/iY7u6gL+jfooipvczhahdoW
MDdGxmZLG5J7ky8tU7ZSzOvLzoMFAMKgY6X0TZdrNayFW6llZFaiSSxikHQRRY7z
uF5MqjTfVHs3el9ILWo5KaXFo9lmUYeY4v/tF8QEnkXwANBpW1vY5H6GDOwiZQJx
8I8ibVv0L45VXtVxpdSER7lxDPiTO0tXc8oXrB9z13/DP933LmHMmmYS4dPZQPNj
ws2aYZHpkybJsZJY9yE/e2ulcXctvqT0NL5L5J6BfExuYvXgy/oFWgpnX98pADH/
Wmi8usF4HMOUOPvBa2RAWTdHGyglwFmFcdQjRct7OxF4DbIcPp8LusE05/Cl6Sde
qsskftDwCmOh1GMPF7IUYQ3RkZnekwKTbEPbnSN/EQRV6XqGkOQHshGB9/XSVC3Y
cgi7FxlUqh1qMpI/ZwuCD3XEKb5RwbltL1+OeBSWnTMOAvgKX+HQAe4dQvuUCia6
oKReY1zCz0GCnI0vevAf2gTM4MOOD6XTAalm8xzwsFn2sl+5UFRfr1VZoioDMxxw
fCpo7PUx7fImHA1XW1uk1xmGaerBGYBtiz+e6dgHCvJejplk6otY8sLN7Yaw5xAR
MYyrDwCM2H45N1PCCCZ38FUSfPZuKJOt7VJ8HyxI9pd2b/8FfieXSbKJAme6J4AR
jTLfG//fnHbocS1wCd7K
=f3Oa
-----END PGP SIGNATURE-----

--FCF9ydJxlAJsfRTu--
