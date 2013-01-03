Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3ACLbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:31:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43047 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874Ab3ACLbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:31:14 -0500
Date: Thu, 3 Jan 2013 11:31:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] lp8788-buck: fix a parent deivce in _probe()
Message-ID: <20130103113112.GG4627@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E11005@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Enx9fNJ0XV5HaWRu"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E11005@DQHE02.ent.ti.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Enx9fNJ0XV5HaWRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 03, 2013 at 06:31:02AM +0000, Kim, Milo wrote:
>  The lp8788-buck is a platform driver of lp8788-mfd.
>  The platform device is allocated when mfd_add_devices() is called
>  in lp8788-mfd.
>  On the other hand, 'lp->dev' is the i2c client device.

Applied all, thanks.

--Enx9fNJ0XV5HaWRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5Wv4AAoJELSic+t+oim9ubYP/0vsnfe/uAFwIii+5BiS3Kik
xIvmJez11dDHOaLoP6mCMSUxhuvYU9f1Xt14b/OrqQNiFFczmB15bS66DIuYM43N
25aMmaPMTb/4WPHojaRovtLewBQp7Tv+Byf0yGwjF5Nqkt1H4y09eX+/S+w1/Ku3
ajKxmeVg77WZ/Sjt+UrAUbBUgtjhsSoYiYJTqfDe3QcXhZMpMizsxUgNddIZRJRo
M4PSOb0dxdrfHIv1QKk5FF/dmUAJzJX6NZWVhzKIQVu22315X6xfe8Q1uOSxn5Aw
tMMEapuGBgQ+ncjc2Z2ahY/SKIQTwSG3//q1eWsnlAD9eQqGkAWARO/W/f21yomJ
rU3CvsfONbPgWDLGA8VQP7xzZE74Kc9a37tOFRs5QMma/qXV/dml3Fb9CfQfZqJA
5kd/SG+eVt8G3vM1ZNUXYmyz+zMKzv3dBa/hL7u58CHVLEG48yxQ11XwfkSiMBbG
gK7woqj7lX2Yck7WPvsvf20O/oCSm0SQ65WAV2/AsqfF1SSz7wd1t/dXB+feim3p
Ov9SZT0CZPxdXvUiufuyQd1KbS5LLffsATzQCXy3sDhUgP5lwxzBxh/OI43rIUXV
iqsEB5kleJ7HZ6J5KS8yvwVACq0sLW8R8HaSndUvvlB17I5J8ueHsqGRwT6wskOf
fY/pEiayHOz6NZ6593yC
=TvAv
-----END PGP SIGNATURE-----

--Enx9fNJ0XV5HaWRu--
