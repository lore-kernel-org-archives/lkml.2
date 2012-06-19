Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2FSSGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:06:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36615 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab2FSSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:06:50 -0400
Date: Tue, 19 Jun 2012 19:06:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@linaro.org,
        lrg@ti.com, lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] regulator: dt: add policy to have property
 "regulator-compatible"
Message-ID: <20120619180647.GP3974@opensource.wolfsonmicro.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
 <1340116099-17629-3-git-send-email-ldewangan@nvidia.com>
 <4FE0BA5C.9020405@wwwdotorg.org>
 <20120619175354.GO3974@opensource.wolfsonmicro.com>
 <4FE0BEEF.4060100@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="utew04vv9FCWZJ01"
Content-Disposition: inline
In-Reply-To: <4FE0BEEF.4060100@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--utew04vv9FCWZJ01
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 12:03:27PM -0600, Stephen Warren wrote:

> So while as you say regulator.txt might not mandate that this be the
> only method of handling multiple child nodes, shouldn't it document
> this method as /a/ method in a central location to avoid all the
> bindings that make use of this feature from duplicating the documentation?

Sure, but I'd expect some reference in the individual binding documents
to the mechanism being used for a given device (which seems to be what
Laxman has here).

--utew04vv9FCWZJ01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4L9HAAoJEBus8iNuMP3d6aYP/itUra1AnnMIVLMdBgkQj6HS
TDMG93Mg2ZS3PxkNHj4S434fk9V3X/v3/flR+z/FVn0HL+WLNE1+2QCUIoOiIBUs
qUOjEKZuqxzcYhOW9RSGokhO+kLtGSOoio6fbUIMaFhG7nOW+2JdiHNe7PhRJ/gB
/kOSqiE097vhMJSCF05aWGrr1rWHEPckBQNZtmWURgEfGqaJU1VUKgWOfMu4rWwm
X5SfSoMKUsHFztVcVF8FSeP1e5KdoVolWAt8taLcYjXJhIJ69r0KX1/rejIDYm2A
9F2CYV2E/vy/73ev5K4O+9MBhnGuK5thW2q4iXGDk/u6jY7f/BdmFzncBA2ArZ+L
L1GOIgDP8OCgIehf85cxzl1HCdfrIt2+Peda7tVBeq6SsxH4Ys3MiJYAcehp5llq
XA472bf3NawfO7Evl1uqBd5ZThXSm4PwywMw2/xgW+J9u6KLWVs/O6MBJ+C8m1N/
vqndb7KNQWR0xi7SQVOoL+Lr3NzdE7YRiFu/uezbxw+y41mWH/nvf/gomMhRRDua
ya5AyTi00Aa5cDu/OZjNqj42N0YUR9+M4iNJngtEG3kdUSKAXOymeoNHdhUZbck4
6+oVv7A2Y6E8zwRYNhC2gCo93TEy0I/PvmgwvX5y5icVm+yaGwiCoru+FL/fz5z4
+CW/QOZD9riVY/zJZXJw
=F6fE
-----END PGP SIGNATURE-----

--utew04vv9FCWZJ01--
