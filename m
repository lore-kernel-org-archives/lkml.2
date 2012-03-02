Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394Ab2CBIsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:48:37 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab2CBIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:48:36 -0500
Message-ID: <4F508962.1070108@nod.at>
Date: Fri, 02 Mar 2012 09:48:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] OpenRISC: Export memory_start and memory_end
References: <1330649715-32438-1-git-send-email-richard@nod.at>  <1330649715-32438-3-git-send-email-richard@nod.at> <1330671102.19557.100.camel@satguru>
In-Reply-To: <1330671102.19557.100.camel@satguru>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig352BBB95792A175B4FCF08B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig352BBB95792A175B4FCF08B8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.03.2012 07:51, schrieb Jonas Bonn:
> On Fri, 2012-03-02 at 01:55 +0100, Richard Weinberger wrote:
>> At least virt_addr_valid() makes use of memory_end.
>=20
> virt_addr_valid looks broken... it shouldn't be comparing a virtual
> address against memory_end which is phys_addr_t.

Then it's time to implement it correctly and match OpenRISC's
semantics.

Thanks,
//richard


--------------enig352BBB95792A175B4FCF08B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPUIliAAoJEN9758yqZn9eHaIH/148DiUuwkceMnu3+TzqeX1R
ZkeTyZ2fcXwVTPafC9au+0z6P47vDcmO+2djoy6C/r/cbRBMsLcBJr/qxQXO1d2s
Jw7x/I59Y8ILrq2RGFPXQsLxRX1Yq6oLePc+gih7ursfLvVStjVFH9wPLo1VauGu
YSrIcB61woUHnHpCFjiLF34ckmmUTrZnfiw1IFL3ggzIH5m99A/8jKqBNyycOBM9
au+xklJnpht9l7AqXRIF5j1OT/BI4I6azvMNtBt2VhCWdMVhfBldgVAtSBqPSRpA
npajUgNH+olWVBgVCfCxoeN2dEyQxyy/eoFZRDIDrqp3OSabBd/fRQi01epBS84=
=p3+a
-----END PGP SIGNATURE-----

--------------enig352BBB95792A175B4FCF08B8--
