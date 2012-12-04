Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2LDJSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:18:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55305 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab2LDJSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:18:32 -0500
Message-ID: <50BDBFDD.302@ti.com>
Date: Tue, 4 Dec 2012 11:18:21 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Porter, Matt" <mporter@ti.com>, "Dill, Russ" <russ.dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] da8xx: Fix revision check on the da8xx driver
References: <1351698984-4007-1-git-send-email-panto@antoniou-consulting.com> <A73F36158E33644199EB82C5EC81C7BC3E9E10D6@DBDE01.ent.ti.com> <A73F36158E33644199EB82C5EC81C7BC3EA13286@DBDE01.ent.ti.com>
In-Reply-To: <A73F36158E33644199EB82C5EC81C7BC3EA13286@DBDE01.ent.ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigCF3063E8CEE3ADA48BCD1830"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigCF3063E8CEE3ADA48BCD1830
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-12-04 08:36, Manjunathappa, Prakash wrote:
> Hi Tomi,
>=20
> On Wed, Oct 31, 2012 at 09:21:35, Manjunathappa, Prakash wrote:
>> On Wed, Oct 31, 2012 at 21:26:24, Pantelis Antoniou wrote:
>>> The revision check fails for the beaglebone; Add new revision ID.
>>>
>>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>>> ---
>>>  drivers/video/da8xx-fb.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
>>> index 80665f6..866d804 100644
>>> --- a/drivers/video/da8xx-fb.c
>>> +++ b/drivers/video/da8xx-fb.c
>>> @@ -1283,6 +1283,7 @@ static int __devinit fb_probe(struct platform_d=
evice *device)
>>>  		lcd_revision =3D LCD_VERSION_1;
>>>  		break;
>>>  	case 0x4F200800:
>>> +	case 0x4F201000:
>>
>> Thanks for Correcting. This is the LCDC revision on am335x silicon in =
comparison
>> with to one read(0x4F200800) on emulator platform.
>>
>> Acked-by: Manjunathappa, Prakash <prakash.pm@ti.com>
>>
>=20
> This patch is necessary for am335x FB, I could not see in your for-next=
 branch,

I have only applied the patches that have been sent to me.

> could you please consider this patch for 3.8 merge window. There are no=
 pending
> review comments on this.

Applied.

 Tomi



--------------enigCF3063E8CEE3ADA48BCD1830
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQvb/gAAoJEPo9qoy8lh7172kP/Rw4A26ddBaPFd0b6ztvU3bo
KpKmCA3Ny40q88y0ulrawfKqfnbsC7fPfdUm79+ei4YlPqn3hAi8ORdZNMn0kQso
CRRkAJnCYVeQB+lydCF6FrwFFLRfgFiyK3IRKxpRWcOwRjc/ujUOTIpBm2FuBlJ2
NCHga7n4blK2OkZNxUrpKsm5+aa5u4ukKMkMfGYL7WIhQ8bOaQbS4fEschPXBPne
JsklNQG4Un72Yn+dNt6TGD73VwfESF9BGYjZ3oYcGATeFNobEZxT3lEFrRBZ71YP
EXMO0sUqtP9ngWoW9cZIqVymcdVS3nFjV/KRZX24hSI+Q4Fu0YhVIb4Ua7PDi2XC
kPctOo0y13XKoRWi5OjhLXoapJgHKKJzYZ5N+eCxMbvI2fa/0MS3SyKlvo10y1Cv
k/81AhSXa7GfIUciqC3CYwRNtp6wHgQb/Slwz1S4GRDaIgiUs0HBipW/cv+tl+Uw
0k2tUfHTPmh5cVbBtCYU4MmeJBLgDlWIrmkVoW6O5OMyQKU1vJ2PX3mmIk5FH2Oz
QdoWCcVcM5uBP4rKN3m0a7JHsdbCTyg6Pvi44iFkwrTqWSjQLR7HgaQl5UJA32nE
iiD5VXDn9XpV+guYOFcBjFQdfdGu3OGOU8q7VAPGYVvu9KdLVY29gvFUQBRYs9DO
IyQi7Iy6SklQUXndp/WU
=hzAr
-----END PGP SIGNATURE-----

--------------enigCF3063E8CEE3ADA48BCD1830--
