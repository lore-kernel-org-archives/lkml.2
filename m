Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2ASK4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:56:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43527 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2ASK4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:56:47 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: bq27x00_battery status report issue
Date: Thu, 19 Jan 2012 11:56:43 +0100
Message-ID: <10055259.ygSgKeUM8f@pali>
User-Agent: KMail/4.8 rc2 (Linux/3.2.0-9-generic; KDE/4.7.97; x86_64; ; )
In-Reply-To: <CANOLnONB5m5iNbWy1=7WWN7T76S1vACbWtJu+KGyhqw2-cA3sw@mail.gmail.com>
References: <CANOLnONB5m5iNbWy1=7WWN7T76S1vACbWtJu+KGyhqw2-cA3sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1371874.K37iOL1yTG"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1371874.K37iOL1yTG
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 14 January 2012 23:10:05 Grazvydas Ignotas wrote:
> Hi,
>=20
> After 270968c0984ae "bq27x00_battery: Fix reporting status value for
> bq27500 battery" status doesn't seem to be reported correctly when th=
e
> battery is close to fully charged state. It reports "Not charging"
> while in fact there is >130mA current flowing to the battery accordin=
g
> to current_now.
>=20
> This status report seems to be based on CHG bit in status register,
> but looking at the datasheet the description says "(Fast) charging
> allowed", which I guess means that the chip recommends charging and
> not that charging is actually going on? If you check the bit while
> battery is discharging and it's not full, the bit is also set.

Now I do not have device with bq27500 chip for testing. I read datashee=
t again=20
and I think that your interpretation may be correct. Can you write patc=
h for=20
this problem and test it?

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1371874.K37iOL1yTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk8X9usACgkQi/DJPQPkQ1Jf0ACdEWtWh6K7y9LaiUbLZgm957iB
kTgAnAnMDNoxid6//UDqoUv5r+Ue5HMH
=laL/
-----END PGP SIGNATURE-----

--nextPart1371874.K37iOL1yTG--

