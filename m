Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761015Ab0J0L67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:58:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0J0L6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:58:55 -0400
Message-ID: <4CC813EF.4030408@pengutronix.de>
Date: Wed, 27 Oct 2010 13:58:39 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        andrew.chih.howe.khor@intel.com, masa-korg@dsn.okisemi.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        socketcan-core@lists.berlios.de, kok.howg.ewe@intel.com,
        joel.clark@intel.com, morinaga526@dsn.okisemi.com,
        David Miller <davem@davemloft.net>, chripell@fsfe.org,
        qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix	buildwarnings
References: <4CC61B1B.3090602@dsn.okisemi.com>	<20101026.105206.15244527.davem@davemloft.net>	<20101026.105545.200376685.davem@davemloft.net><4CC71DA4.3020600@grandegger.com>	<4CC72360.1070608@pengutronix.de> <008201cb75c9$f27ff720$66f8800a@maildom.okisemi.com> <4CC813B9.3080506@grandegger.com>
In-Reply-To: <4CC813B9.3080506@grandegger.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1D28B4BD9011CA4ABE93FA5D"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1D28B4BD9011CA4ABE93FA5D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/27/2010 01:57 PM, Wolfgang Grandegger wrote:
> On 10/27/2010 01:27 PM, Tomoya MORINAGA wrote:
>> On Wednesday, October 27, 2010 3:52 AM :  Marc Kleine-Budde and Wolfga=
ng Grandegge wrote:
>>
>> The following is some inarticulate points I have for your questions.
>> Please give me more information.
>>
>>> Do I understand your code correctly? You have a big loop, but only do=

>>>  two different things at certain values of the loop? Smells fishy.
>> Uh, I can't understand your intention.
>> Please show in detail.
>> This processing does configuration for all message objects.
>=20
> Not all, but just a few of them. We believe it can be implemented more
> efficiently.

I misread the code...sorry - I'm just writing a longer answer.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig1D28B4BD9011CA4ABE93FA5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzIE/QACgkQjTAFq1RaXHM64wCeLi5aG/VvvhsC0kfOPgSOtBBI
gswAnRrGtfoJvQqemB06JlOpN44psMnk
=kSXp
-----END PGP SIGNATURE-----

--------------enig1D28B4BD9011CA4ABE93FA5D--
