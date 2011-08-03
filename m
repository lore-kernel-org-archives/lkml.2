Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1HCNnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:43:12 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:44149 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab1HCNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:43:07 -0400
Date: Wed, 3 Aug 2011 16:43:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, stable@kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: cppi: fix build errors due to DBG and missing
 musb variable
Message-ID: <20110803134302.GP11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312378755-7919-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7kD9y3RnPUgTZee0"
Content-Disposition: inline
In-Reply-To: <1312378755-7919-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7kD9y3RnPUgTZee0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 03, 2011 at 03:39:15PM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
> Replace DBG with dev_dbg add fix invalid access of musb->controller.
> With this patch cppi_dma builds successfully.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Cc: <stable@kernel.org>

applied, thanks

--=20
balbi

--7kD9y3RnPUgTZee0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOVBmAAoJEAv8Txj19kN1gKYIAJmc6OE2mIyEcbRnXM/fmFCN
wAQB7xZGDHGcKScMVmL4hJKms1jhVCGaf06Q4WtR+OAe/Xk24YNd24it/O4PAy51
lwXEE2YOYNPtUL/Au4vBuCiX+C7GdqvIoXsF/F583l3pnrqH+aRFklMw4IrRJBXc
8d3LtkzKhZojhP3foiCc8MTr5Q4MR9341vhKK/7rz+ctRniclWX4jlaaECrTTgYy
qUxwOdF1O0/KFQbSnPURmznzakL9TfdCQP19/Ib7fBnT7m+v0WQTQvbTjd0Cu3lT
mjM+D4FVL+9Ej87+lUtEDuFfkLr5MGoZ8BiP01v+TdyqSgSsmZXIJMDh5BnL+vQ=
=9Gqu
-----END PGP SIGNATURE-----

--7kD9y3RnPUgTZee0--
