Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab2CBIvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:51:33 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab2CBIvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:51:32 -0500
Message-ID: <4F508A11.9000405@nod.at>
Date: Fri, 02 Mar 2012 09:51:29 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OpenRISC: Module loader broken
References: <4F501C7A.30307@nod.at> <1330668690.19557.91.camel@satguru>
In-Reply-To: <1330668690.19557.91.camel@satguru>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB1EFCE28C1A1129B4463BD7A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB1EFCE28C1A1129B4463BD7A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.03.2012 07:11, schrieb Jonas Bonn:
> Hi Richard,
>=20
> On Fri, 2012-03-02 at 02:03 +0100, Richard Weinberger wrote:
>> Hi!
>>
>> The OpenRISC module loader is broken.
>=20
> OK, that's new as we've been using module loading quite a bit on this
> platform earlier.  Where did you get your toolchain from?

I built it two days ago from source as described here:
http://openrisc.net/toolchain-build.html

Thanks,
//richard


--------------enigB1EFCE28C1A1129B4463BD7A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPUIoSAAoJEN9758yqZn9eWLIH+gMLqCd9mtAehp1kKRk3PBt1
qcvIcMO//OIa29xnWG8M3lJh3qyXslIej1y1hc2PRuE5xPrWbgQfH4TCJdt5Xamp
4hACVNrMlI8r3lrIbr/zWh6mJpPXJgjoSzSgTyyfECSBuOzAQDL+kReK5BOm4Ivx
3md951CaZ43iNNUxcDIHH/pplDrwHNqqm/Ohaa1xTjed8GuBjNAtUoiFXXo6h/Tv
1YJBYcCWIjEAixtCmFD5W1QZTD2Owa5YLCdIDEyFAGtyhQvkAkghLVf5vkI2ccWj
PJ0dZA6iDeBi5RsWAJexOFEsXILIM0tASEMyuooeufTE699Iqil29DFelm47+2A=
=SE3S
-----END PGP SIGNATURE-----

--------------enigB1EFCE28C1A1129B4463BD7A--
