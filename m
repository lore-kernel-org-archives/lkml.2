Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2DBWZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:25:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46267 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743Ab2DBWZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:25:19 -0400
Date: Mon, 2 Apr 2012 23:25:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: Convert mc13xxx regulator drivers to
 set_voltage_sel
Message-ID: <20120402222515.GM3160@opensource.wolfsonmicro.com>
References: <1332211595.10843.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5fECsWged6836Ycf"
Content-Disposition: inline
In-Reply-To: <1332211595.10843.5.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5fECsWged6836Ycf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 20, 2012 at 10:46:35AM +0800, Axel Lin wrote:
> Convert mc13892_sw_regulator_ops and mc13xxx_regulator_ops to set_voltage_sel.
> mc13xxx_get_best_voltage_index function is not used now, remove it.

Applied, thanks.

--5fECsWged6836Ycf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeidFAAoJEBus8iNuMP3d8gUP/iaX80hQDvuYRCXCLwEfoyAI
nvjsntpW6piKyM0rl1anHky4wJfSMHdpBnIgb6YAqBU9ioKcvR7S9aamaUov4s7D
siUyM2TfRvMsf30j+dIt0r2OUZ96OlYXzgIoxQAepkEGYh2QKlQzxI9UXJffjLgP
xQGk5I8ThW5t28mz74Ny62s2BwI1iz6JUSi3cFVd4bfd1Ar4yTS90cqIYTkt8mO8
x/loDb4CjF0tZcDnKYAyXCao2jr3I1dPHbwR/EVa5SRhjAlbCT+OGuQdIlNXK2am
DFphb0XOYcI8U+gO8E7AwxyFPGhM5f2IRX5lBi6HKwCNORlV5zIplqEQpuE56Qse
eidpw24a3mSeDirG5gTsRjanmuGuyEOKHg9yrVBsdyz/5KkWbpVWlu6g91/8jWYK
svLg8oQkY8oMEVN8OyT9KYn6umFezLrii0NqKQqFJGQRIkcOuCc+qE2n2FzJVTbJ
EHeI3zezxQ+q82WoFgggmR1EzNnevy/wzU86ddnhKnpny8Vly1+QFP6InNvjgp5i
44uVcTPWrpYqna9Kd/Bx34Fp+NsvgDPZuk4iBjBpNM1IanLa+PtovkG3jmtMexpH
ZM7atcEgCx/RQRNa4YmDwjssFcwf1kBwuUQee1DOhcPb/+vwSfsS6rN1ZvMx7LtY
Vf3l9A/WXs3424mJodiB
=V5kj
-----END PGP SIGNATURE-----

--5fECsWged6836Ycf--
