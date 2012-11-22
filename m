Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800Ab2KVVnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:43:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2KVVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:43:29 -0500
Date: Thu, 22 Nov 2012 22:43:25 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH 0/3] pwm: lpc32xx - Various small fixes
Message-ID: <20121122214325.GB14771@avionic-0098.adnet.avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline
In-Reply-To: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:M63gyiojN198mm6qLxb8ue9AQqld4FzntGJOl0c3eM1
 Q1X6LtPk438+X1I2q/zTt3EhCXsdId0W27IRWM3y7Yiy65BKSS
 VQVXabyufNOqqVPCBIh1tOUr2vXJWShxkG4VK6tjp92UcuADU2
 /nU8FmNrDKvGzWwCgZFtqSfGrRuawDsDm2N4B4dCKZTCdCspps
 6qkhiNDsLGmgQ1Iai7oyWi20A7jDz7rkcMQ18UY5pBtC+TAzWv
 bBIbBADW8mxw5pyzR2m7a0sorYl/YaqzNnAHy75DYxs6r56xy7
 QON1bQt65njGfULR3y/UghErLt3n7QBjKK93zBTtCRDGEI+cha
 o3IFx5758YOjccIyNltwQaLa4brUuJX25Zef29RYhQRvwIZ2oZ
 tqqmzb+Zpdt1tILwrNHutKmcl9hdlg8pa9llu+t6JG0kTlpAwJ
 JBXEG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 12:58:12PM +0100, Alban Bedel wrote:
> A few fixes for the LPC32 PWM driver:
>=20
> * [PATCH 1/3] pwm: lpc32xx - Fix the PWM polarity
> * [PATCH 2/3] pwm: lpc32xx - Properly disable the clock on device remove
> * [PATCH 3/3] pwm: lpc32xx - Set the chip base for dynamic allocation

Roland, Alexandre,

can you guys take a look at these? At least 3 is very straightforward
but I'd still like your Acked-by or Reviewed-by on the other two. Are
there any potential issues? If Alban doesn't resend, I'm tempted to make
the stylistic changes that I requested myself and push them for 3.8.
That is if I get an Acked-by from one of you guys for 1 and 2.

Thierry

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpx9AAoJEN0jrNd/PrOh4oEP/0kH9Nb8wYv4cVA5TWWgROmE
IbhQOEquNcu0jVerelhHRN5F09Vt05CYzOD4+gFcPg9PIp6f7YZ+0m5B5HA19Itl
edd8lsJjP1xXo7AwmByNbVYAymSGq/E6dS1MUgokkzz0zsUOPf7Hudwi0xt3FcJL
vSdNj9u+59O967RmOoCOoRK1cEyrooWlewEs7nfOdAfzVO3H/ZB7RYHISqzD84ya
L95bOEF4+ViSSwXiVVpft2cv+w4/5Kkafc/ohCxXhb4C5KCppsaYq4udex34M1za
dj3tUkVjbtP3l+SDG356XHUpFQRsTFf1WRwWxwD/mNdRrDCKSLwetlL05OPXy7lv
9O28eM3IsHibbc0/ga9I7moBxdaDli+1AMs8AXGy6ac1bnOXnrD0CY4FeSLaX7Hz
TU7Cidrv2WY0nWhJy0TaHEZe3zQJTqKPcWXc16W0sqbQVtRG9fl1rC1TGCPISRFW
bxsc0WUq/Mz9aIHG0sFu79238rcoR4AcM20O0tw/eJSVzHb4g8gnzlit7hB4G4aA
hjnD2h//s9JxdRk7BG806C/a9rf3oAANnWIFPWeW4gNY7pEp+4FOnt0vqIeo5Y5S
Oc24uXqUgg4e5+LC+HW+4ZZiNyYxTX3/hCUercqLxi/aCMb2xdZdtUCvJTSwzdJA
tS8Aujrsm2k2mAOIIvqF
=JuNo
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
