Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0DMNYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:24:46 -0400
Received: from gold.linx.net ([195.66.232.40]:49084 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab0DMNYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:24:44 -0400
Subject: Re: Low-Level and Long-Term Battery Control
From: Tony Vroon <tony@linx.net>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <w2r45cc95261004130535y80da503ev5389bb4a97bdd58f@mail.gmail.com>
References: <w2r45cc95261004130535y80da503ev5389bb4a97bdd58f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ovJgtpTMr3ddQyI0dzE2"
Organization: London Internet Exchange (LINX; AS5459)
Date: Tue, 13 Apr 2010 14:24:42 +0100
Message-ID: <1271165082.3529.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ovJgtpTMr3ddQyI0dzE2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-04-13 at 14:35 +0200, Mohamed Ikbel Boulabiar wrote:
> I ask if the kernel can do such control without the user intention and
> in an automatic way.

Battery charge control is generally a function of the system firmware,
not of the operating system. You might be able to disassemble your DSDT
to see if there is any control of the overall charging schema.
Most firmware does not expose this though.

> Some BIOS provide to the user to select whether to block the battery
> I am not sure for the MacBook side, but it seems they don't suffer
> from such problem in the same degree as other laptop users.

It sounds like those MacBook machines have well-written firmware in that
case, at least where the charging of batteries is concerned.

> I think it is a serious problem because if you keep you battery on
> power for one week you will detect it becomes holding only 50% of its
> energy compared to when first bought.

I would suggest contacting the manufacturer, overcharging of certain
battery chemistries can be a safety hazard. If the machine is in
warranty, it sounds like time for an RMA.

> Thanks,
> Mohamed-Ikbel BOULABIAR

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-ovJgtpTMr3ddQyI0dzE2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAkvEcJoACgkQp5vW4rUFj5qgfgCeOfQSKREBlTrY5rT1m5qiMH44
46cAn2g6bprW6q21VXCAWL0CzNVrEy5o
=pdCt
-----END PGP SIGNATURE-----

--=-ovJgtpTMr3ddQyI0dzE2--

