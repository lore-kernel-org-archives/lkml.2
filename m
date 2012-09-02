Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2IBTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 15:09:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61598 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBTJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 15:09:55 -0400
Date: Sun, 2 Sep 2012 21:09:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Message-ID: <20120902190951.GA10583@avionic-0098.mockup.avionic-design.de>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
 <201209021855.11579.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <201209021855.11579.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:h+lV6M1Dhy2KXe7JcIRWjzwFx3T1X1sBhpqNdQ63qge
 Jg6m9SXnMJztpQDQPkUXAdGvl9OazABXH/t0I+xHoyVQswFxaa
 AEwL/6qCBsBPywpCgWmSLDv20cZCAoO2PQ4cr6grRJkPMpyNeX
 z+miUCsHvITPy4ExbAZWyByB9j5RSQKTWdFqYli8aPuxhg+1M4
 fwSSKCw+Yz5wuMJOErUp9Hi0+SSLAUjw7mjxcOkL9HCRvaGzlx
 fjQj2ez6b/TySPrTD8hRwixqi7/N/rUETMCoJg9Dh0QGNEmCIP
 ImBQsFkqryyNmdLq3FCdioJBK4lcqXXk/ddXUyoaeI0x46MurN
 OmOPGExIdIrp/fPrPlTbHciC9rc954GT+HFY7aF0ESd7/1ucyu
 vk5v1ROo8i5gGZvpoMhxx8MUSOf8AdVRRtXdQxEFyBM/9EYuIG
 Ba5ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 02, 2012 at 06:55:11PM +0000, Arnd Bergmann wrote:
> On Sunday 02 September 2012, Thierry Reding wrote:
> > This commit moves the driver to drivers/pwm and converts it to the new
> > PWM framework.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > Note: I'll take this through the PWM tree, but I'd like to have it
> > acknowledged by a few people who know the hardware and can actually
> > test whether this still works.
>=20
> Did you create the patch using 'git format-patch -M'? It should
> show the changes as a move plus changes rather than a file remove
> and another file add.

Yeah, I forgot that... again. Sorry for that.

> The change to the common framework is of course very welcome,
>=20
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thierry

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQQ67/AAoJEN0jrNd/PrOhJCoQAKUgAtBj+hg5dYkJevNFPX5q
uvtoIqXCMATVCiLd4efQ1Ri3sXJ4xxLNfsi/prR1L/nuA2zIP2BnRcp/o99+X6CA
gpmUy84QHuuA3/7KZl4OOaKMDjVc2FPmsShc89BrM/CaurXyku54kJiqMT3teLq/
HMg0UUW8V2HyVGHN5aDppQp9vY1frT7is4AcXlzbaNwMHYwz4b8gZk+IBP0f/A0f
pWa/whSgeMTBIy7yDiSj/1NlpuT7T4wXP4fAdDcar/fJpBZk5Gf2TNtTh98Q7BPj
CrO0vqJwVCJNNNpSj10jr3YsHwM2gTZrUrXNBBvOCHiMPASPfvqtVrmNG9h1RnN/
+3R758KsrSi2TpZ/DdeAuwalQoyXmb61JfhTIVY52B1/wAGu+vU6qoeYD2TIZyT8
5cJZ1+CspvpuBQzNR2mPfE9Jaj3Ytv+UP6lALmSxn+pqxuD8JGgMFQZttfeM7uCK
ZouWiEaT5a6f/HDUG4FY1J3khk0IOwLCC3LBO1n/DN/PwgzJAMymLXBBV73Dxj57
H+9bTwIRS/ucU08MytIfYWFlyQNNA5cUtigoTofe6FG7qOXDqcTmV4ePR/R+W6Nh
mKEO6HytPuVHb+00FtqvDE8cH/BAzXr/VMlQ9/bng65+Ng5ya6GDvmAcQN8+Pima
UuQksbBCq1gf7ZJL6Tzm
=FC8n
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
