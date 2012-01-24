Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2AXJjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:39:19 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:42261 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755323Ab2AXJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:39:16 -0500
Date: Tue, 24 Jan 2012 11:39:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/6 v2] usb/gadget/pch_udc: Fix disconnect issue
Message-ID: <20120124093909.GU27414@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rW45g2D1DgwV0HVw"
Content-Disposition: inline
In-Reply-To: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rW45g2D1DgwV0HVw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2012 at 11:27:05AM +0900, Tomoya MORINAGA wrote:
> ISSUE:
> When the driver notifies a gadget of a disconnect event, a system rarely =
freezes.
>=20
> CAUSE:
> When the driver calls dev->driver->disconnect(), it is not calling spinlo=
ck().
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

applied all 6 patches

--=20
balbi

--rW45g2D1DgwV0HVw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPHnw8AAoJEIaOsuA1yqRET3gP/0EbeGpT65CtTQa+93LRpSej
VBvpNj10iEUbftzmSOC7VcLVzO50aNXg52nk4yG+a0rZ/7koHAXb9dFWDpqg+bpV
aypN5YnKdDE+9Qz16S8zms8IxOmxB0QSsH0XPJg4aL8GPCcvhSuKXQLFR2dQ4IOV
vFQa31Vzg3s2ZTvZROSsuDAg/nlCgHxABnI+zLCuB3fk4koHjmip+h2HD4d3jmRo
elz/GXDuvZpKExQcavcEw5+gTtKpPsTVj+RHuPum458rrrV8o/W6WypPDftAPed5
lGCdxQTtyBwfaSWLFtCSU+HdEQKrURWCrNfh98RhmnObN4T5x68fN1us5MVSAS4d
mn8/5Idg49Ze99tiD5TEKraJYY96IAWnhROf78UfkL9vTepVwnAKHjHz6hbF8hCr
Duspbq3FXGTBy1Qb261jHM2Qr7JZoCM6x5o54slEjxQy8rfR2n7BFU9BGXDEzSQe
EsBYXfWmlkfUxYT8Hpp0p1lh5Q83Y6LO9RgF7fxZ/D/UH9UD1dR6Umiq21Ua1klL
w2VpUyElE0C+dvtYRPC3v4PD//nyBD2c3uBOcLwRpGSm6P/ObZObfUc/T6TrKHP8
MfFsc+sKjriyZvfdt2uxmp2a748Sz/UDORYFLCBkzl9y0QSUw6dpqpVzlRMw1aez
Dsm/fvz81QtBwf3GXJzj
=Zm0Z
-----END PGP SIGNATURE-----

--rW45g2D1DgwV0HVw--
