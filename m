Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0E1Npi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:45:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42420 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0E1Nph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:45:37 -0400
Message-ID: <4BFFC8EE.8060501@pengutronix.de>
Date: Fri, 28 May 2010 15:45:18 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: sha@pengutronix.de, Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       Vladimir Zapolskiy <vzapolskiy@gmail.com>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Fabio Estevam <fabio.estevam@freescale.com>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mx35: add flexcan devices
References: <1275046938-8465-1-git-send-email-mkl@pengutronix.de> <1275046938-8465-5-git-send-email-mkl@pengutronix.de> <20100528133424.GA2001@bluebox.local>
In-Reply-To: <20100528133424.GA2001@bluebox.local>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig167BB2E0BB9A935043A0C6E4"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig167BB2E0BB9A935043A0C6E4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hans J. Koch wrote:
> On Fri, May 28, 2010 at 01:42:18PM +0200, Marc Kleine-Budde wrote:
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> ---
>>  arch/arm/mach-mx3/devices.c |   40 ++++++++++++++++++++++++++++++++++=
++++++
>>  arch/arm/mach-mx3/devices.h |    2 ++
>>  2 files changed, 42 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c=

>> index db7acd6..0e1e20b 100644
>> --- a/arch/arm/mach-mx3/devices.c
>> +++ b/arch/arm/mach-mx3/devices.c
>> @@ -127,6 +127,46 @@ struct platform_device mxc_uart_device4 =3D {
>>  };
>>  #endif /* CONFIG_ARCH_MX31 */
>> =20
>> +#ifdef CONFIG_ARCH_MX35
>> +static struct resource mxc_can_1_resources[] =3D {
>> +	{
>> +		.start	=3D 0x53fe4000,
>> +		.end	=3D 0x53fe7fff,
>> +		.flags	=3D IORESOURCE_MEM,
>> +	}, {
>> +		.start	=3D 43,
>> +		.end	=3D 43,
>> +		.flags	=3D IORESOURCE_IRQ,
>> +	}
>> +};
>> +
>> +struct platform_device mxc_can_device0 =3D {
>> +	.name =3D "flexcan",
>=20
> Did you also post the flexcan driver itself somewhere? I've got such a =
device
> on my desk right now, and would be willing to test that. I've made some=
 tests
> with Sascha's old version, but it's not really satisfying...

It's not yet posted, I'm currently restructuring the driver with regards
to the set_bittiming and control mode discussion on the socketcan ML.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig167BB2E0BB9A935043A0C6E4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkv/yPMACgkQjTAFq1RaXHNF7ACfewI4r4qmjtcdh3d075H0oyez
uLMAnjyqg5qmEQGid8nH/KQrFRCnx4Yq
=tNst
-----END PGP SIGNATURE-----

--------------enig167BB2E0BB9A935043A0C6E4--
