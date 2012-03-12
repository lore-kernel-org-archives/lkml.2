Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2CLQMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:12:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60509 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab2CLQMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:12:20 -0400
Date: Mon, 12 Mar 2012 16:12:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 5/5] mmc: sdhci-s3c: setup pins using pinctrl interface
Message-ID: <20120312161218.GK3110@opensource.wolfsonmicro.com>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
 <1331469965-28846-6-git-send-email-thomas.abraham@linaro.org>
 <20120312142143.GC14020@sirena.org.uk>
 <CAJuYYwQ=vhcrbH3gsMBuLG1D_p=mx_RFbN86+ETPT4bLYrRgEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dxRQSzdsN/lOP445"
Content-Disposition: inline
In-Reply-To: <CAJuYYwQ=vhcrbH3gsMBuLG1D_p=mx_RFbN86+ETPT4bLYrRgEA@mail.gmail.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dxRQSzdsN/lOP445
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2012 at 08:01:34PM +0530, Thomas Abraham wrote:

> Yes, I agree with your comment. I did refer to manuals of s3c24xx to
> Exynos to ensure that the samsung pinctrl driver is generic and
> reusable on all samsung soc's. I hope I have not missed out something
> important that would require additional tweaks in the samsung pinctrl
> driver. The missing bits now are gpio interrupt and wakeup interrupt
> support in the samsung pinctrl driver. Once that is complete, I
> believe it should be easy to add support for other SoC and convert the
> drivers to use pinctrl (other option being to let pinctrl driver hog
> all the mappings at boot and remove the cfg_gpio platform callbacks
> from the driver).

Yes, I don't see any fundamental problems here - it's more that either
we'll need to get all the SoCs converted over (which is a lot of work)
or we'll need to have drivers be able to cope with running either way.

--dxRQSzdsN/lOP445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXiBbAAoJEBus8iNuMP3dI9oP/34qglJfej0g6XSdlJvd5X+5
y03PKJQYtnY/C0DbjWs+J1xBh19JyKDQWtWgrRA8ku6r5WGXcUgCYA8GHfTUNk6W
vbo6TcUrhSTlhBHPJgpmMNK/j2ua57v95RZpfRNjDM+mnFCE3GJqx+fPQ1H4BrmU
4H7i/ZqbT0FpMBcYaS032b7pPaiPevlM8Zk8cymismLBN5L93im8TbjVkqkt7tKP
XfWAVXGB2jLqWeguOWQZ+u8B8QzBEcyeFqx0pw6iYapWAN4qfYu8DNqtEaKnDSgO
2TyKDNid6ATu27mlae9+61OM2c39VujZur4mwHC4DJ+x3pdIhzCJh0PWMyg5dUlZ
Njk4Tg6WTmw7niSze4WX2Va+Sygroau9jaZqXgk2JY4B6YBdyrMqILClRbeTFWDp
sxTWVWo32H94YJuFfSwHTUvtCStMYzURfbL46gg0IL7GGJD+a2bIeEHFgNnhM/q7
LRwmThIRiJLUNQf5+Svc0pRg+KSQMa6DVt01QkjcQN3wNA5QdsqbQEDIn1D7M9Eg
x2iLdllXbb5O7bfIe5rDuMsiWl8rU+u6VPT76dfvXBAWpMLDe5LUjXc19nxN30Nj
Oxjd2iqzpSD6S6yTpkBv8Yxhv8zTFWOLmnwEfzPws/suNTLywIKrTNRgh0L3RC0l
1TWk2fqB5dpZQ+wu9wGs
=T40z
-----END PGP SIGNATURE-----

--dxRQSzdsN/lOP445--
