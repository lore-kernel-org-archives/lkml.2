Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1BPV7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:59:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51486 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab1BPV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:59:42 -0500
Message-ID: <4D5C48C4.1090403@pengutronix.de>
Date: Wed, 16 Feb 2011 22:59:32 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel@pengutronix.de, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] RFC: introduce typechecking to platform_{get,set}_drvdata
References: <1297892994-30801-1-git-send-email-mkl@pengutronix.de> <20110216135547.8940e19d.akpm@linux-foundation.org>
In-Reply-To: <20110216135547.8940e19d.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1AA2EE441CFB572FE6227EE1"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1AA2EE441CFB572FE6227EE1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/16/2011 10:55 PM, Andrew Morton wrote:
> On Wed, 16 Feb 2011 22:49:52 +0100
> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>=20
>> From: Marc Kleine-Budde <mkl@pengutronix.de>
>> To: kernel@pengutronix.de
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-fou=
ndation.org>
>=20
> No mailing list was cc'ed.

just noticed, sorry :(

>> Subject: [PATCH 0/2] RFC: introduce typechecking to platform_{get,set}=
_drvdata
>> Date: Wed, 16 Feb 2011 22:49:52 +0100
>> X-Mailer: git-send-email 1.7.2.3
>>
>> Hello,
>>
>> just found a mis-user of platform_set_drvdata(), so introduce typechec=
king
>> to these macro definitions.
>=20
> ick.
>=20
>> An alternative would be to make them static inline
>> functions.
>=20
> A vastly preferable alternative!  How's about doing that?

Sure...wait for "v2"

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig1AA2EE441CFB572FE6227EE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1cSMcACgkQjTAFq1RaXHMxVQCfUKh6DowxDq854tunLjtFdHrk
2gUAnjuoE+Ieg75quhJyI9YpwTocrzj4
=L83L
-----END PGP SIGNATURE-----

--------------enig1AA2EE441CFB572FE6227EE1--
