Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2FTXhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:37:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54191 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758563Ab2FTXhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:37:17 -0400
Date: Thu, 21 Jun 2012 00:37:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Laxman Dewangan <ldewangan@nvidia.com>,
        lrg@ti.com, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120620233714.GD4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <4FE229BF.4080109@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline
In-Reply-To: <4FE229BF.4080109@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 01:51:27PM -0600, Stephen Warren wrote:

> At least, I don't think it's common to refer to nodes as phandles;
> phandles are usually the values used at "client" sites to refer to
> nodes IIUC.

Right, I always think of the phandle as being the label (which is
present at both ends of the link - the client refers to the handle the
node provdes.  Though now I think about it I suppose it might be
Hungarian with the node having a handle and the client having a
phandle...

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4l6jAAoJEBus8iNuMP3dUfAQAIea3c18F4APsF1IRUrtZ0+G
HwmqSgz79fhZ6WN6xDQVs2GzqAaisqelA0cqy2tkgdrSoM9P3zaQ4nRNBW9FuYMF
Mo7C1PbHPllN0xgmFSTvhTxCd5yNE9XEFkJi+e0KLQJrxHdcpCfbFp9lk4zrQJJ4
Tf7QbDhk4f29nmuU7wSy2IHWuBUXJ9IWwBaih4iyTUhRMZegDGnw9kpHLqzZBZzI
e6QgRag+g3dO6nTpGTGgjnxjcWpXNVmfQ9VoPGKKOxuptaNW0It2Shkg2xZHSX09
ZVc7bcwZj6xubTOkrTJZahXjROSdHP1OCsDbxRlFJVYYBLC67NkplRglyJ/xCt4o
gavnlWYxTfvUywHWgj0ChbxGr4eWJxU3O+ymFSGH3rSl9lHe2Yc8JQn5OltHK/jL
8n3Tl2KeGA/i3HLKb/85wWtkjHDUl5RonIQA2TryhNgPPwYJ97Wr60FDFnCR6kD6
d9+8qmlFgTKMGD1CI+bax0kgsOZ98mNJkiXfUBpq0r2wNtmp6my10V5fIFmcFrnf
GGKu2+vxmvqzAzNVR4GVsgZUMoGl/hy3ppsgx9AC9rOcPJvO9n6ufBpJC5FR7lfV
AxO0T75JNznxPh/xrsi2f4L9W78f/f04MUcdPpnpaBRA5u45LoM1zKUPaFYDghiX
9WNV/Zq98T6Fvk21VUXi
=ED36
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
