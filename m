Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1ERKvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:51:14 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48843 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab1ERKvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:51:12 -0400
Date: Wed, 18 May 2011 13:51:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com
Subject: Re: [RESEND][PATCH 3/5] arm: omap: usb: device name change for the
 clk names of usbhs
Message-ID: <20110518105102.GF13908@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305538681-21062-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b8GWCKCLzrXbuNet"
Content-Disposition: inline
In-Reply-To: <1305538681-21062-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b8GWCKCLzrXbuNet
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2011 at 03:08:01PM +0530, Keshava Munegowda wrote:
> device name usbhs clocks are changed from
> usbhs-omap.0 to usbhs_omap; this is because
> in the hwmod registration the device name is set
> as usbhs_omap
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

applied, thanks

--=20
balbi

--b8GWCKCLzrXbuNet
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN06SWAAoJEAv8Txj19kN1o2kH/jTQWuRT3fObcPSzeeF/8FgA
tIwwcEdelSnZD7gGn7nJuwFXEsAERWivwBz8MvqJ6J0Qg3OpNKyM7oWDQx6HbF2M
op2J/LlR8qvGsc2Saw1PYHMbu9qxuqrvQz1FgzRQ95+O4SmL0gGAs5W+mx0niS3H
KLib7XkoHO2meNyd7v5s7RQXK0Weah/7Rs1wWTUIiMCta7AcvzYTYnuBc/vaGI2E
xCbpo45nErnfiI5jg8J3HbGg2lV1RUMvMhWxRbOP0PVjPiHusTZrjCJ80tyJrwS9
9X951X88tsTR7CTbo2qcMEtbYu4BKDESePsPXaAVtvo1H0jSEwfbGOs+RQajmCM=
=Dj9P
-----END PGP SIGNATURE-----

--b8GWCKCLzrXbuNet--
