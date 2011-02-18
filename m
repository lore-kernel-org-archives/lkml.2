Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1BRIgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:36:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1BRIgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:36:33 -0500
Message-ID: <4D5E2F86.1020400@pengutronix.de>
Date: Fri, 18 Feb 2011 09:36:22 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: Wolfgang Grandegger <wg@grandegger.com>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        CAN NETWORK DRIVERS <netdev@vger.kernel.org>, nsekhar@ti.com,
        LKML <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>	<1297435892-28278-10-git-send-email-subhasish@mistralsolutions.com>	<20110211152026.GC373@e-circ.dyndns.org>	<32A5399EB727427C98185089E5DBFA65@subhasishg>	<4D5E2570.10108@grandegger.com> <184FA07B783D4F5FAAC09D5C11737A3F@subhasishg>
In-Reply-To: <184FA07B783D4F5FAAC09D5C11737A3F@subhasishg>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig29289A3F93AD7CE69E97EE56"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig29289A3F93AD7CE69E97EE56
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/18/2011 09:15 AM, Subhasish Ghosh wrote:
>> On 02/18/2011 08:07 AM, Subhasish Ghosh wrote:
>>> --------------------------------------------------
>>> From: "Kurt Van Dijck" <kurt.van.dijck@eia.be>
>>
>> ...
>>>>> + /* register interrupt handler */
>>>>> + err =3D request_irq(priv->trx_irq, &omapl_rx_can_intr, IRQF_SHARE=
D,
>>>>> +   "pru_can_irq", ndev);
>>>> you're doing a lot of work _in_ the irq handler. Maybe threaded irq?=

>>>>
>>> SG -Ok, will do
>>
>> No, please use NAPI instead.
>=20
> We are using h/w filters, so the number of interrupts coming into the
> processor are not hogging it.
> I feel that we may not require an interrupt mitigation.

As davem stated the other day, all new drivers should use NAPI.

regards, Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig29289A3F93AD7CE69E97EE56
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1eL4kACgkQjTAFq1RaXHOVkQCeK+Zl73Wk6m1Xb2aOmDaPynho
/a0An230G7HFRSAi0jqrt47PEQyCNbGd
=n3+U
-----END PGP SIGNATURE-----

--------------enig29289A3F93AD7CE69E97EE56--
