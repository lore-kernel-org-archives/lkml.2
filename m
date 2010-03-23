Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0CWAKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:10:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46502 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767Ab0CWAKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:10:10 -0400
X-Sasl-enc: 7tFjXl/9WUw4FkbXogTH0ee0BUTTd1ZIct4rLYfgEZC5 1269303009
Message-ID: <4BA80630.2020100@imap.cc>
Date: Tue, 23 Mar 2010 01:07:12 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: pavan_savoy@ti.com, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers:misc: Kconfig, Makefile for TI's ST ldisc
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com> <1269292756-7469-2-git-send-email-pavan_savoy@ti.com> <1269292756-7469-3-git-send-email-pavan_savoy@ti.com> <20100322213530.GC420@suse.de>
In-Reply-To: <20100322213530.GC420@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9EB0D28FB5A731A74E33AA56"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9EB0D28FB5A731A74E33AA56
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 22.03.2010 22:35 schrieb Greg KH:
> On Mon, Mar 22, 2010 at 04:19:12PM -0500, pavan_savoy@ti.com wrote:
>> From: Pavan Savoy <pavan_savoy@ti.com>
>>
>> This change adds the Kconfig and Make file for TI's
>> ST line discipline driver and the BlueZ driver for BT
>> core of the TI BT/FM/GPS combo chip.
>>
>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
>> ---
>>  drivers/misc/Kconfig        |    1 +
>=20
> Why 'misc'?  Why not 'char' like all the other ldiscs?

Not wanting to nitpick, but the majority of ldiscs do not live
in drivers/char. There is a whole lot of them in drivers/net, a
handful scattered over various other drivers/ places like
drivers/bluetooth, drivers/input, drivers/isdn, drivers/pps,
and even one outside the drivers/ tree, in sound/.
(Leaving aside the one in staging.)

HTH,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig9EB0D28FB5A731A74E33AA56
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuoBjsACgkQQ3+did9BuFtD6QCePqs3KiogPrYx3lwu1Uj4ySeu
U/YAn1dFV0/71gSx3b8wsAMbn2cXI4u6
=To5A
-----END PGP SIGNATURE-----

--------------enig9EB0D28FB5A731A74E33AA56--
