Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2HAMas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:30:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44009 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2HAMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:30:46 -0400
Message-ID: <50192171.5070701@pengutronix.de>
Date: Wed, 01 Aug 2012 14:30:41 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v5 2/2] can: flexcan: add LED trigger support
References: <5018F8B3.6080404@pengutronix.de> <1343821782-1346-1-git-send-email-fabio.baltieri@gmail.com> <1343821782-1346-2-git-send-email-fabio.baltieri@gmail.com> <501918B2.6070703@pengutronix.de> <20120801122443.GA1311@gmail.com>
In-Reply-To: <20120801122443.GA1311@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig142C0572C1C4953FB28615DD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig142C0572C1C4953FB28615DD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/01/2012 02:24 PM, Fabio Baltieri wrote:
> On Wed, Aug 01, 2012 at 01:53:22PM +0200, Marc Kleine-Budde wrote:
> [...]
>>> @@ -635,6 +638,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev=
_id)
>>>  	if (reg_iflag1 & (1 << FLEXCAN_TX_BUF_ID)) {
>>>  		stats->tx_bytes +=3D can_get_echo_skb(dev, 0);
>>>  		stats->tx_packets++;
>>> +		can_led_event(dev, CAN_LED_EVENT_TX);
>>
>> Should the led blink on TX or TX completion interrupt?
>=20
> I'd say on complention interrupt, together with can_get_echo_skb().

Yes, good that we already agreed on this :D

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig142C0572C1C4953FB28615DD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAZIXEACgkQjTAFq1RaXHMkygCfYZDzF+0I2QvKlUnS1svMPQGp
b+MAniMbi57KUVVfG05IJfrfRU70apg2
=1q2G
-----END PGP SIGNATURE-----

--------------enig142C0572C1C4953FB28615DD--
