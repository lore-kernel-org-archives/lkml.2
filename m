Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2FTIbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:31:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58148 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2FTIbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:31:40 -0400
Message-ID: <4FE18A5E.204@pengutronix.de>
Date: Wed, 20 Jun 2012 10:31:26 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
CC: David Miller <davem@davemloft.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "federico.vaga@gmail.com" <federico.vaga@gmail.com>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
References: <20120620133348.a9ff31a72ffd11818f574fe3@canb.auug.org.au> <D5ECB3C7A6F99444980976A8C6D896384FAA275CA8@EAPEX1MAIL1.st.com> <20120619.213703.513466167861199217.davem@davemloft.net> <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FAA275CBE@EAPEX1MAIL1.st.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD2BF30344E566AB65597BECA"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD2BF30344E566AB65597BECA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/20/2012 06:45 AM, Bhupesh SHARMA wrote:
> Hi David,
>=20
>> -----Original Message-----
>> From: David Miller [mailto:davem@davemloft.net]
>> Sent: Wednesday, June 20, 2012 10:07 AM
>> To: Bhupesh SHARMA
>> Cc: sfr@canb.auug.org.au; netdev@vger.kernel.org; linux-
>> next@vger.kernel.org; linux-kernel@vger.kernel.org;
>> federico.vaga@gmail.com; Giancarlo ASNAGHI; wg@grandegger.com;
>> mkl@pengutronix.de
>> Subject: Re: linux-next: build failure after merge of the net-next tre=
e
>>
>> From: Bhupesh SHARMA <bhupesh.sharma@st.com>
>> Date: Wed, 20 Jun 2012 12:27:11 +0800
>>
>>> clk_get/clk_put* variants are usually used by ARM platforms.
>>> Protecting their calls under macro 'CONFIG_HAVE_CLK' should solve the=

>> problem.
>>
>> No, we don't pepper foo.c files with crappy ifdefs.
>=20
> So, whether adding a check in Kconfig for HAVE_CLK be a proper solution=
 ?
> But that will limit the compilation of this driver for only platforms w=
hich are ARM based.
>=20
> One may need to support this driver on x86 like platforms also..

I think the driver is currently used/tested only on ARM only, so what
about adding a HAVE_CLK dependency, until Viresh Kumar's patches are
available in net-next. Later we can remove it.

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigD2BF30344E566AB65597BECA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/himIACgkQjTAFq1RaXHNu1gCgk22xh8KDyfQfaT7v6HtFg15E
WNoAniuhRzJ1KBkQoXiPO60lqwm+YDrT
=n41d
-----END PGP SIGNATURE-----

--------------enigD2BF30344E566AB65597BECA--
