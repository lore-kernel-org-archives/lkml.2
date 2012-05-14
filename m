Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2ENQrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:47:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33085 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756954Ab2ENQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:47:47 -0400
Date: Mon, 14 May 2012 17:47:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regmap cached only when write happen to register
Message-ID: <20120514164746.GD25668@opensource.wolfsonmicro.com>
References: <4FB135BB.2020001@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <4FB135BB.2020001@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 10:11:31PM +0530, Laxman Dewangan wrote:

> When debugging  on register caching, found that register is getting
> cached only when write happen to the register otherwise it will not
> get cached even any number of read happen.
> Is it by intended or there is opportunity to enhance it so that
> during read also we can cache it.\?

If you check -next you should find that the current code already caches
any single register read.

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsTcrAAoJEBus8iNuMP3dhqwQAIKPCCtRkQhb+RvD3rxL2QAg
EbEan8mrWKShr0OfMbm5fcPEPSYULRQp8bqILS9QTcCTm7cxGOvqzjq5gwazI5gY
mdgJMtfFNy5K0jsfDohGPVrYJiMpbLcE5cVO9zcP2ibU8YBjxXPA3cXUfbszIbsa
zcWTHMO3+xu3q+K+3XqKb6z55zce8WgWCPh8C9OM4StGJiO43k39G8/ObE5VKVxz
t6RLG3LXp090NlMsNzaDej9CFwMCb2q/ky5LiZHh9ZJcnT3YgV4ZzI0uzkVBG1TI
lEFrsln+VBGI3GFmjicfjEYUnJRsk3vzbnH0uLuMobUcVqd23x8kZPFf5CllJoXk
fOlf2QQmY3QXG3JCxun7gdxiu8Vi6wxC5DhrcrryBMYto27pOpgc/jov/5fzo5Zy
SpnQWP4eHcu+Z02NgykrkPR3DIX0oaE7Nm2IIKmE2oZ43AmNs74P44qJzNtnWvRC
apuD/PpdVeY3+fgPg9XWeUwMJydLZDm8KZsdrFK+uStH/64wrRTx6HSeY+uCXMAq
V9Kus7QKGtQE8LM6IptA//ZMU8zBYjVImzlL9/tP5eY/mJPVECvyiVLnmjqlSqET
OSlOtM12irEeg+QoCtieyRwQdoFisXeqjspEuP4Sht6Ft9eQ4wroe6BoAQcLPAD3
G2438h2I6KgiyhALKqYS
=harJ
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
