Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2LNJrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:47:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59105 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2LNJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:47:37 -0500
Date: Fri, 14 Dec 2012 11:40:20 +0200
From: Felipe Balbi <balbi@ti.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zihan@huawei.com>, <Lin.Lei@huawei.com>, <greg@kroah.com>,
        <neil.yi@huawei.com>, <wangyuhua@huawei.com>, <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match rules in USB storage for
 Huawei dongles.
Message-ID: <20121214094020.GA15370@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <fe6cdb1d63dd.63ddfe6cdb1d@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <fe6cdb1d63dd.63ddfe6cdb1d@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 14, 2012 at 10:25:25AM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
>=20
> 1. Add a new macro define for USB storage match rule.
> 2. Optimize the match rules with new macro for Huawei USB storage devices=
,=20
>    to avoid to load USB storage driver for the modem interface=20
>    with Huawei devices.
> 3. Add to support new switch command for new Huawei USB dongles.

still doing too much in a single patch. Should be broken down. Most of
my comments weren't taken into account. Why bother sending a new
version ?

--=20
balbi

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyvQEAAoJEIaOsuA1yqREdTMP/RAn27E+hyhp4jKj3c4nE0IJ
PbSGnSVKpdksnLvviH99z474qAwutBko97/Q6tHKE+pWiXSh3Mu2WoCJoH+6ruQy
BpaEM2/zcjoC7biHfUSQaYHgiqQKOoA83KCC4AxiQHHHaabz8u7GzsNjJ6e5tWCo
BSSzN9eQMXVMnUCnD2eXqs4kLW5r8Ra88epiG15YY4cfzoN6XpToTmlJ+tGoC00H
Fov+8vDiEzgwzl70CLfu7QX4D/vH78pp/ZeLt2HTHnOyUENZZX5TfJ6UlYMHnmCs
TRU2gzY35uPefviUAMgt3hV1Txr8iRil7eEbm5tuF1Sa/ko+6vwD7sXkKTgdSsO3
AjqBB5VZ75LdNNtnOehQglAgQ/e3YXctRePZv9pGPGhFIhUVKv4jKDexqmlNH8z/
nNLB627OFV/rS41SVGfywrKFeWmpnYe8TjkSU/mEI71XhcfS7HzWFYFgBCAIwEXu
ILnsUOJNNjlU1I9zyFCxHq/nFi7jI4aNh9wIfmwrin5HAELyrN80bJLYAn20DDGU
OmzIkcSkC/fZXm+RpDIrCPeLTt3U6tXkanwQ6PNFSrBj2DOgkcTlgbUj8SERK/AT
t8OjOtKKXTYMluh+xR4hgs+rqq1Nhhd3fZfghPA9lR9luxwvDzs5tBan+unUQcoi
wsWwqmDCPX2IUT+PSF1C
=fHq+
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
