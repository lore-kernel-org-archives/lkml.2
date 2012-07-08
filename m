Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2GHViM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:38:12 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2GHViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:38:09 -0400
Message-ID: <4FF9FDBB.8010702@nod.at>
Date: Sun, 08 Jul 2012 23:38:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: daniel@caiaq.de, rusty@rustcorp.com.au, mchehab@redhat.com,
        axel.lin@gmail.com, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: input: eeti_ts.c build error
References: <4FF83E48.6060303@nod.at> <20120708010520.GC19007@core.coreip.homeip.net>
In-Reply-To: <20120708010520.GC19007@core.coreip.homeip.net>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig14E9AB125CA5C982B36A3E7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig14E9AB125CA5C982B36A3E7C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 08.07.2012 03:05, schrieb Dmitry Torokhov:
> Hi Richard,
>=20
> On Sat, Jul 07, 2012 at 03:48:56PM +0200, Richard Weinberger wrote:
>> Hi!
>>
>> While building a kernel for an ARM board the following build error cam=
e across:
>>
>> drivers/input/touchscreen/eeti_ts.c: In function 'eeti_ts_irq_active':=

>> drivers/input/touchscreen/eeti_ts.c:65:2: error: implicit declaration =
of function 'irq_to_gpio' [-Werror=3Dimplicit-function-declaration]
>>
>> .config is attached.
>> Happens on 3.4.4 and Linus's tree as of today.
>=20
> Could you please try the patch below? I have had it for a long time but=

> could not find anyone to test it.

I don't have such a device.
The only thing I can do is a compile test.

Thanks,
//richard


--------------enig14E9AB125CA5C982B36A3E7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP+f28AAoJEN9758yqZn9esmsH/iCjS4pkHD6IC2kRvUms3OSa
IFzJ2ZX/0lj3fiYjccKCzRBFCoPE5SfClbYkkWtBHaLXg6vOFqCVaSOugcs7x6eZ
61Vy6pQkMxwKWpwEjqgSMIATmAVt5RAFiywlrRDFz4jKYj3Mu1T4Zgi7xUiNHEip
eJkVHmW37mUZpvfEhvgndySWiDif9sisVrllPUt4L6R5VmmBOSGPt2CE2sde1aLN
2+cmtRpA5WhJ2+exrqcW+yeCHixN/MlEioYGiVbHPrkLtCPXbbs1aghdKlpAGgk5
d1XQ0sVMhjv2Lndaw0n/b7KHp1ks6uKOFlyGgn/uDwV81NzuwR1qFUsHEcjyPRE=
=mEpZ
-----END PGP SIGNATURE-----

--------------enig14E9AB125CA5C982B36A3E7C--
