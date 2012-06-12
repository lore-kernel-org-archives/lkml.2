Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2FLJpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:45:51 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36158 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab2FLJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:45:50 -0400
Date: Tue, 12 Jun 2012 12:43:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Felipe Balbi <balbi@ti.com>,
        trivial@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: treewide: remove extra semicolon added by
 module_init/exit
Message-ID: <20120612094349.GI9770@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338990069-6627-1-git-send-email-balbi@ti.com>
 <20120606083119.0d0a0029@nehalam.linuxnetplumber.net>
 <87zk8bhfds.fsf@rustcorp.com.au>
 <20120611142028.380c5a61@nehalam.linuxnetplumber.net>
 <87zk89nznn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="81JctsDUVPekGcy+"
Content-Disposition: inline
In-Reply-To: <87zk89nznn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--81JctsDUVPekGcy+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 12, 2012 at 09:56:36AM +0930, Rusty Russell wrote:
> On Mon, 11 Jun 2012 14:20:28 -0700, Stephen Hemminger <shemminger@vyatta.=
com> wrote:
> > Given common kernel practice and the fact that only 16% of the uses of
> > module_init/exit are without semicolon and that other kernel macros don=
't
> > include semicolon.
> >=20
> > I recommend going with the majority and common practice...
> >   1. Fix the 636 places that use module_init()/exit without semicolon t=
o include semicolon
> >   2. Remove semicolon from module_init()/exit()
>=20
> Um, yes.  He should do exactly what he did.
>=20
> It's a wart, let's fix it.
>=20
> Thanks,
> Rusty.
> PS. CC's chopped; somewhere in there is a bad address...

let me know if you need me to update the patch.

--=20
balbi

--81JctsDUVPekGcy+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1w9VAAoJEIaOsuA1yqREtK0P/1KB7cC3X6YrRdu0Olxc5kaH
PxpYj1/WZPF04o9W6xWXN3IQcZXw6H97sJXdhtISuFZN+rOsdxvJhUlOfYKZTAwQ
DyoIrRMvw6S8bw2PD9jKCQ4uZXbIsyvEg1iGt9nOEANoBbI7tea3NzQIVIWtYzGm
A8q6X2ARVNM/xecJsIiyup3V/ERrsHxBgbTXeE7ah1jALAsSGXX1ytlqMKwn+dHC
YDOORpd5xb90GCYVlMBNOiSYuvN52O3SqoJWyj/o/2NQlRohfrFbM6RmQ0sqoAD/
cK+dMEa+ufu0rvzm1ojFU6WN9r81DUZYeAwWqxzg+lJFvWa/W06sC47w9Vv1IT05
eiuHQqAY3k/6HL+YHH/v6GZfntwGvbAGXIav/3H7trAA5U78oDHPgCdvpiHxZVtO
lKCdx/fjqlE3+ud+xBMFojHIzzXWkBCfvnUnvzkc1Jz/qD9/DzkeieSB+PN8IdYf
JNP8qDuDiBhkv0QasDUWnUkqW4Y5Rf6Wv3sw/3XScZ3HxRgn3z8SRHSEUi5Ha6oo
Zch4M+Nx4YonPtAQt5aify3yq7n0GUY4XieVBW+hdU/CPjKqmNLG1kSaL2vl/hyo
ZybVhxJ0WTd37pRQuW47tZ89r9OBSaVVtmWW519QD1yccZuudxqgAXdYJN45Jj3s
k8901G/VUx5Uowxgjj4I
=nC6Q
-----END PGP SIGNATURE-----

--81JctsDUVPekGcy+--
