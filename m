Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2FHAzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:55:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58731 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064Ab2FHAzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:55:20 -0400
Date: Fri, 8 Jun 2012 07:27:08 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120607232707.GN14525@opensource.wolfsonmicro.com>
References: <1339034714.7309.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BjavXC7V3ilNTWHC"
Content-Disposition: inline
In-Reply-To: <1339034714.7309.3.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 1/2] regulator: core: Allow uV_step to be 0 for
 linear mapping if fixed voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BjavXC7V3ilNTWHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 07, 2012 at 10:05:14AM +0800, Axel Lin wrote:
> Fixed voltage is a kind of linear mapping where n_voltages is 1 and uV_step is
> 0. This change allows [list|map]_voltage_linear to be used for fixed voltage.

Applied all, thanks.

--BjavXC7V3ilNTWHC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0TjCAAoJEBus8iNuMP3d130QAJuoJ2RDDxoKwlD55HG+yM6p
JLYW/Uaj6kRhqFUXPNK3QReT7v148beqK+PM488PT+TPm9UROXZi8wgWPz4POLoQ
vyJ+Agzawtu0XbGz07ynsDd6d0sVivIiawZa0X/BiDXC0u4lhCPMa0vqfFU6VFmw
Q+dnDVmuNOfnAI4mX+Lj3Ef/dAYIC2SjEjwCuDjvTVOVBNzsJ9QP5VYtb1cBwiCr
jwc5m/DD7MlaoRjOAr3zxEJFNvf08is64P+N5R9XiOIwt5u5z+jrTAi5V0gfbNHc
fm916bFbjqI9enbmZJfjB6jJkNOjY+AdSrq/IC8tUikcUj3rVZOCc1+GbsmlM+xA
i+UBQTijcrn3DpjeYHI7WxiFrHdCKWFluHqPxt46rIGYmcsQzPmYoC12UuvIvx+v
ZrgGiBKZ6ARxZYnggkGEg3l1oXDOxT2a8EnPpxMVz6laICQQyFU9Rp/7o4oONDPh
RnXsBb/yPmXEBUSZ2RkJGGp2ok3azG1rMQmMfzk9eOKAnfse58EXV5HHbuOPboPJ
Nsn/wtN75QK+0zOYwOQ3DthYoajjEJgMmBBbNq3Ca5q7oApSSWoq2nOhXrHcw90w
4vATE+IVbu8kpuEiISa4bToLj2l5dl8eE6+JC4SQ66BQnDC2/43yNiGEMO8FG74k
0nE/oGiZND2PzcZ/vOrf
=68Mz
-----END PGP SIGNATURE-----

--BjavXC7V3ilNTWHC--
