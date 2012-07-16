Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2GPLj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 07:39:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2GPLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 07:39:26 -0400
Date: Mon, 16 Jul 2012 13:39:21 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Adding support for configuring polarity in PWM framework.
Message-ID: <20120716113921.GA3015@avionic-0098.adnet.avionic-design.de>
References: <518397C60809E147AF5323E0420B992E3E960B0E@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E960B0E@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:uXE0iWeQuBr7jqbKEmVL3SHJfeyqAKS797F+dLidrah
 ZjkNtWhaQo4QpH5AQhRXWunCJ5bln98rNJU9pGvl5MNjwpkXFR
 sf4t8quXTXxfw3nCBqx7BYi3pjb6F4l4SwmqjPonfrzQ73YyRv
 KPo/voS7g1K619yq/sERnHPCqJ/wMi/0kRBrOMHuY8YuuhsLPH
 Meslnr+BBxsT1KcEYIynBulu1Nj/YYxvU/4n2EKPzjMHXZwNjM
 tzJwy+jN0AtYeYM+6j8ckr9uEmqKydoj3t9io7VYQWN0AYCMec
 NJJWu5fqcDoei0bBheEQXADyQVDojeipFvKHKd408zJN1Yyg9A
 Vpp+2GsGpvqq0FlR2gLXdqMbBNvIX3ViXHpMqMpGMwQUgqERR7
 YugRoTYp2t3SiZPyGFm8vDu8g6/O4lpQxc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 16, 2012 at 11:15:50AM +0000, Philip, Avinash wrote:
> Hi Thierry,
>=20
> On one of the custom boards we are using, uses PWM to drive the backlight=
=2E However, for
> this device, PWM signal needs to be inversed.
> So, we need to a platform data to indicate this parameter.
> Current PWM framework doesn't provide .support for setting polarity (or i=
nverse polarity).
>=20
> Have you come across any such requirements? If so, do you have any plans =
to implement it?

I don't have any plans to implement such a feature.

> I am planning to add support for the same but want to avoid duplication o=
f work.
>=20
> If you have no plans, then I will send a patch to support the same.

I wonder how you want to implement this. You'll need special hardware
support for it and you may be able to implement it in the driver itself
instead of putting it into the framework. Anyway I'm interested in
seeing your patch.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQA/1pAAoJEN0jrNd/PrOhhQgP/1X717Rvzk76o0wKPtkKa1ID
gdR/YzqPO0m4GJJwKOEUQ2cNkpwZfHQDGVbLERRxh3JHi+znlwInX61eNCqEArH7
F7M+3cNcdSOmZxhKPXYvbFRhIF009BtL1Tf8F0xlEkgIve2Q3s1Ms80r8I7E9fF6
5J6DPCTrmjbplM3uW//oOtQeUMic3VM0P9lVSPQoonjdMjfsTWPG8gBeQrntHZa6
1aDsWm6MfxZhv4m39C75Uek4KQBn/cxP2MVMTY5oGMmHPVqrUcfRsOlKIuFQ4mhl
R+oGtcAroHLP0PTT1jEc5r0AjLO9snFkXi6RskytcKeNVLseMWsko5xpI+O9KlN8
d/Jx9NPUxDkVbD/aMmmKDCp+19vHFDu1wF4X3cpuejqry/ZlG3NuhnESJbNyX0oS
pAIbNDYgieSKEbPaFhjU6PUQFF4N43oaGjccfPX55OT18INP/rROK8QVMC8VbTlX
sNUjZUIEmahfv3b0mhDmBwYLJYA1unsxx4KPDZF2k0ibGOKn+//NWxV5zlUjatKn
0Ez+LpZ9wbMnXOwcyo4srKK8bQdrx6lSMRy364it8r4z4qkYZYAg1uUQaH6QC5BM
OCBcYNYRZumQuhvJqxbEGSpw2LNk4MAqsDmCI1jJraZXLMWZyOOKaJmcteRD5n6x
1uZt5Rh3SxoIU9TYGZt8
=p7jS
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
