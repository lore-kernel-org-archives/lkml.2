Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2DEKhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:37:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50729 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab2DEKhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:37:09 -0400
Date: Thu, 5 Apr 2012 11:37:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Support set_voltage_time_sel for drivers
 implement set_voltage
Message-ID: <20120405103705.GK3129@opensource.wolfsonmicro.com>
References: <1333506730.15318.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQ77YLfPrO/qF/pM"
Content-Disposition: inline
In-Reply-To: <1333506730.15318.2.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQ77YLfPrO/qF/pM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2012 at 10:32:10AM +0800, Axel Lin wrote:
> In currently implementation of _regulator_do_set_voltage, set_voltage_tim=
e_sel will
> only be called if set_voltage_sel is implemented.
>=20
> set_voltage_time_sel actually only needs get_voltage_sel to get old_selec=
tor.

Applied, thanks.

--LQ77YLfPrO/qF/pM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfXWrAAoJEBus8iNuMP3dqS0P/RxawFkSJ6XrdjsDfFvD3WFo
N0B4aBLGitRjiljm1i6izhyaUJeJp14aR9CWY9KwfQpbEDtpY0/BZHhIlP4eTegt
cImLpFzyv1DKwfmaYFsEUqX5bkbrEO5QrZ8pgLzEIP999kUmmatysyGsgUpUsBEq
F99dasNYOMUDDJlUc1sVoLNNXMjO3aett0x7glDLtbgOy8NXf1EymmCbJfoI2D0I
HER/a1IyNyUekjQXbSNmoSMlsiFTqiCJeF6RJBKCXVSoAKXEEws+5YfDDEJ987sg
yyxSlJucRGKKzkdLN45Bdgh8dKT8Ght0kbX2hiean/fEW5YdgEX/qr9IYqHtVr7K
g8RI/OI4+DUcJmnrxjnKPn9jzWXx7eC+Ok8coqfABc7HwFhlGKlBy7BxoWxu8Y/U
xA9a2jVk5xJaisdm/rp3YCO/IEwYMolJ9qjK6z1NOUKV2shuMlmaNqrReyk/mMM0
mkF6mbm6+WWU+TStH+8Ig9vEp4K7lvtkrEA9GTIuoZ1R5mKywm8gilNTSIsfkN25
H7V2CSY0CHfO6vrVNvQ1P4uqxAKQ+ZfkIoXB0DQCPnHXerR62TnJNfAR+Oqsotc4
BTVhlVmFihyiUtMvcOc14fQ0CeFJar5W2aMi8B0xwryvaLE7AnwQNI+eTBqHKYA/
CzmvJ4XzDaoxzsa/R+uy
=tfIX
-----END PGP SIGNATURE-----

--LQ77YLfPrO/qF/pM--
