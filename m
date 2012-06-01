Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430Ab2FAQVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:21:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43239 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965382Ab2FAQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:21:21 -0400
Date: Fri, 1 Jun 2012 17:21:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        H Hartley Sweeten <hsweetn@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
Message-ID: <20120601162118.GA24139@opensource.wolfsonmicro.com>
References: <1338541736-2978-1-git-send-email-jonghwa3.lee@samsung.com>
 <201206011613.33706.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L+ytD9kXoSFEJYhc"
Content-Disposition: inline
In-Reply-To: <201206011613.33706.arnd@arndb.de>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L+ytD9kXoSFEJYhc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2012 at 04:13:33PM +0000, Arnd Bergmann wrote:

> You should also have an of_device_id table so you can match this driver from
> device tree definitions.

There has been...  some discussion on the value of doing this for MFD
cells where the MFD cell has no reuse capability (eg, when the driver
has very little abstraction from the top level chip binding) since we
don't really get anything from the abstraction if the driver can't be
reused and may limit ourselves (and others) in future.

--L+ytD9kXoSFEJYhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyOv4AAoJEBus8iNuMP3d4hAP/iNepqdkXzbbbKGOL1OVBsrL
SyBCpdCpVG04IeMA86g1mWekXYwdxvFwdcBHtA9CBfI8e06XhNfsWL1Ef9u9rTLT
hWSDNERWomxD0/Lp+ueuRisgCLD1uNueEc9GWbtXmdpWTaiwoiFro1i1RZota4gL
MtE1AbXekyHQvnB+A9F/wibjbqQFqu0Zt3AwlWXyzJh9jnvTGQeErMSUqailiERQ
8NheliWMcdFI+mcFrQVo5HSbU2iVrQmqs7OHvnQYMlWp01z/JxOzhUJ2KLZhziUz
A8FS9Gq8zfR6N6lTJBmERwyrWLy5mGO71Rt7Sz9whyqBgjXkl7wfa9CBzTK6lrkN
cHHIBFmkBUH+kmQ2FRNPNZOAzc+op2JwVSAeiyQcUBScXcwuRYx+bBj8JpHybk9E
8LToloKRim5CR6U+NAJCMyU8Hy+vv+EBKxymAb3KCQViN7NhzOMkG5a18hGlQw18
h8wjseHmtV4SMEeHSxjwpEcpb1c2Ll4vpaAAr7s2TR/TtgAeDJWnj+vW1JUeEn8J
3Ii9XzYbNz4n9GgQF+WiPJ93oANOMW+SA1hu3gLqVBcu8sm4OjySSdfSP79TlTq4
st3Z+QrssNgAg4YOjglLUSI8SWZhJc2srGwV6L8C4fCtJVAI6FuaYeFXIUkOXHLu
EdHUpuPalN18CqOLMVzv
=LcQ5
-----END PGP SIGNATURE-----

--L+ytD9kXoSFEJYhc--
