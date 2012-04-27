Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972Ab2D0R5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:57:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54927 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760646Ab2D0R5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:57:02 -0400
Date: Fri, 27 Apr 2012 18:56:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@ti.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, j-pihet@ti.com
Subject: Re: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Message-ID: <20120427175657.GP18260@opensource.wolfsonmicro.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
 <20120426191159.GA9415@sirena.org.uk>
 <CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iq/fWD14IMVFWBCD"
Content-Disposition: inline
In-Reply-To: <CAJ6a13a6WN9h1QZynpEOf-R6RXwWBZ2eOPkTeNc15JX_YfAz_w@mail.gmail.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iq/fWD14IMVFWBCD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 27, 2012 at 11:09:10AM +0530, J, KEERTHY wrote:

> Devfreq and cpufreq are related to dynamic frequency/voltage switching between
> pre defined Operating Performance Points or the OPPs. Every OPP being
> a voltage/frequency pair. Smartreflex is a different
> power management technique.

But presumably these things should integrate somehow - for example,
should devfreq and cpufreq be providing inputs into what AVS is doing,
and if so how?

--iq/fWD14IMVFWBCD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmt3jAAoJEBus8iNuMP3dwCIP/1i2rPocJbbB7yGsjpZmoc0F
b3lRK6RmOuad98MAeSv1AO7/J6QI3N7s7oVhJfkP69j3mxzXdQf2AE6DSgqbWJT4
wU1qRVsrC1WniNeDHU8ucXq6wIMalxUapfVhUJDChz4Ui04+si6xkKfWjkKHMSZa
zv+7TequN2Rk8EVmZtMdyonyBjXTNchjIJ7AREUfrXKHL1LTRn5zljr/QMb+bKiW
fN0ndG7iDizDTwDY67tXDdMN5WlIVl7FexGV/L44V32F4iENeBkOn3rfI2AzLSKX
XBpKidSO54q1s4HrrzdPBGAkV70K/BBNktQWAd85CFptQ3jP4TNTrr0FV56/URNK
waLW58bP3RfWYEQyBIsixdFVbgk6/M01FmwSUOdFf26dsQi0sDh29LrM67RkNKmt
p2O+oLuJRKAjUh5dJOtyqkXpjdSEKBcl/gmREQqdS1AGzhdaP6BZ0mN1XIuYGPi/
JsRHUbXAlFzYNc4F2dEYE5WIo1fj1q/9kWwhY8vLPvFZlCWyEr8NfgASdpY0gxbC
Hn9YjPv+fCQN6SUKaUfLiaGThTh7e5zysuvjHU+w+eGNZBNSgvZA7ofaf/TsX+Ba
ike7OfcLi/Noho5LBD2Dxsbtg/lNamL5n8pdDFu+OwCoqj64cspjz7mOFcJaaSFd
xPst2wKotL3rtuxYiVMl
=IFMA
-----END PGP SIGNATURE-----

--iq/fWD14IMVFWBCD--
