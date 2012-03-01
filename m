Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2CAKPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:15:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55506 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab2CAKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:15:20 -0500
Date: Thu, 1 Mar 2012 11:15:02 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to
 reduce wait time
Message-ID: <20120301101502.GB2535@pengutronix.de>
References: <1329725656-32715-1-git-send-email-alexander.stein@systec-electronic.com>
 <20120224121753.GE2479@pengutronix.de>
 <CANKRQngWB8kUO68UdbDeWey5eGRF0nGCE341j8jyCMogvYUYKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <CANKRQngWB8kUO68UdbDeWey5eGRF0nGCE341j8jyCMogvYUYKA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Our team moved to ROHM Co., Ltd.
> So, previous email address already disappeared.
> Current my mail address is "tomoya.rohm@gmail.com".

Ah, thanks for the update! Are you fine with the patch in question now?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9PTCYACgkQD27XaX1/VRv46wCfcmM3LnEq3iH6m/OeckgAhsqb
SFYAn2fvJ5vN05J1Hgxye8oeT98vqfQ0
=83qE
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
