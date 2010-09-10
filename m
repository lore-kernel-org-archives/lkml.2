Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0IJXsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:48:54 -0400
Received: from vps.mortis.eu ([79.99.135.181]:36829 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0IJXsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:48:53 -0400
Date: Sat, 11 Sep 2010 01:48:52 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add f71862fg support
Message-ID: <20100910234852.GB18142@salidar.me.mortis.eu>
References: <20100906132434.GA17730@kreios.titan>
 <20100907131837.GH6114@salidar.me.mortis.eu>
 <20100910090301.GS354@infomag.iguana.be>
 <20100910232407.GA13116@kreios.titan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <20100910232407.GA13116@kreios.titan>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 11, 2010 at 01:24:07 +0200, Lutz Ballaschke wrote:
> On Fri, Sep 10, 2010 at 11:03:01 +0200, Wim Van Sebroeck wrote:
>>> Given that the F71862 has *two* pins assignable to the WDTRST#
>>> signal, please document that fact, and the reason for choosing this
>>> one in the code.
>>>=20
>>> Perhaps it might even be desirable to insert a printk there.  This
>>> to make the user aware of the fact that this driver might not work
>>> if the pin configuration of their hardware doesn't match the
>>> assumption you make about it in this code.
>>=20
>> I propose to Document it in the code and add a module-parameter so
>> that it is selectable.
>=20
> I agree. I will post the patch again (missing parts will follow soon).=20
> I placed printk in watchdog_start(). Since this means printk output=20
> everytime /dev/watchdog is opened I'm not sure whether i like it there.=
=20
> Maybe it fits better in f71808e_find(). But this would require
> additional if / else and stuff.=20

Can't you fit that printk in the switch(devid) block?  That wouldn't
require additional logic.  In fact, if you make the selected pin
configurable I wouldn't consider a printk explaining the current
policy/config assumptions necessary because that way there aren't any
policy-related assumptions made in the driver anymore.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"It would seem that perfection is attained not when no more can be
 added, but when no more can be removed."
  -- Antoine de Saint Exup=C3=A9ry

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyKw+QACgkQZBYm/87l50J9lgCfYoGK7MFL7mPu7rFK2yazOBn4
jVwAoMhRJM6vrC5a+/R+Q8AjOrFlGYoU
=FwIZ
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
