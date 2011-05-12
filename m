Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1ELNFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:05:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57834 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1ELNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:05:05 -0400
Message-ID: <4DCBDAF2.7040101@pengutronix.de>
Date: Thu, 12 May 2011 15:04:50 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <201105112344.44171.arnd@arndb.de> <4DCB88A4.2010901@grandegger.com> <201105121454.47781.arnd@arndb.de>
In-Reply-To: <201105121454.47781.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCC74D13D42DE58C1FAC67592"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCC74D13D42DE58C1FAC67592
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/12/2011 02:54 PM, Arnd Bergmann wrote:
> On Thursday 12 May 2011, Wolfgang Grandegger wrote:
>> Well, that seems sophisticated resulting in a complex implementation
>> (may code line) also because hardware filters are very hardware
>> dependent. Usually just one global filter can be defined. I think that=
's
>> overkill. A simple interface using:
>>
>>   ip link set can0 type can filter <id>:<mask> [<id>:<mask> ...]
>>
>> would just be fine.
>=20
> Ok, fair enough. Still I would suggest you first come up with
> a reasonable user interface (the one you posted may be just right,
> I don't know), and then let someone do the implementation in the
> pruss firmware that is the best match for the user interface, rather
> than the other way around.

I suggested some time ago to implement the more-or-less standard
<id>:<mask> filter instead of just a single <id> (per filter entry). The
cost is probably quite low, it's just a single AND operation per filter
entry more expensive.

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigCC74D13D42DE58C1FAC67592
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3L2vIACgkQjTAFq1RaXHMrMQCfZRW8hn78Ku7PfDt63fmtOqlF
OjUAniY/vJwIb7SjKLLFF63Y1ZKqS3H1
=xc0D
-----END PGP SIGNATURE-----

--------------enigCC74D13D42DE58C1FAC67592--
