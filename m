Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2C1LpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:45:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43880 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab2C1LpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:45:16 -0400
Date: Wed, 28 Mar 2012 12:44:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/4] regulator: wm831x-dcdc: Fix the logic to choose best
 current limit setting
Message-ID: <20120328114449.GQ3232@opensource.wolfsonmicro.com>
References: <1332832646.9942.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BouVgDkIlpb7X6Bk"
Content-Disposition: inline
In-Reply-To: <1332832646.9942.1.camel@phoenix>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BouVgDkIlpb7X6Bk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 27, 2012 at 03:17:26PM +0800, Axel Lin wrote:
> Current code in wm831x_buckv_set_current_limit actually set the current limit
> setting greater than specified range.

Applied all, thanks.

--BouVgDkIlpb7X6Bk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcvmeAAoJEBus8iNuMP3d7lkP/1DI32BxeORUAP4TNP2meXhD
ojPl4m3ftDsHcoifCOLsfdvQWLW0hawNqr1Tw3wwewZ954DmlwM15WzFSNfOwczz
8rA02B0HmPW5pHA72GVmuj8EJFT/qzq5kKbLw3kChtHVO8IO8twQmNccymZUWJkb
0uK+oDoov+B9EVHS+36StwBEvu8M7mtMLKWNaKLbNU48Ce1iD4sEXGYDKjWN9Xb8
uOgo73pgcBnpiJVVnKtIk0ai41hSSXVJyt81XcEOBe8tOGnby9s9mBTdAenwvZwz
FIGKW17wv5xB8oSj/i49B14za1cUqaG2ZZ9IVxrwPxImwUyAapeEs8zg78rGSV8B
SgzEYnTyZrfYqK1UqsHl+8oAo6f6dy2YcnxzGGq7ZFAOduYnmFBMK/ZeBfJWIMQ/
wJYqdEE05SZJHQm1P8JbtKeuWvS7Xp5MqWjsfVTWDejdoLUuro24jWLGFKWsrgw+
Kv/mCMgN8ALS66QfZBSEifDQtrn7gkKgXIYSeVQTvihkt7ImKre2HXIBOHSUBuui
wW32IEWi8c/cTEN/KwNdA3ex6bFmIwYh9b9U9zEFCIU8d0q7tgQa3eWnPepoFK3Y
6GW2nxgZxaP69ewT4qraKRn07R7SgYnfp5zfJosqLSLMkOWmv8vbQG3yTfZFap5w
jjgMDnuYkW2IBEgJoqs1
=5zB4
-----END PGP SIGNATURE-----

--BouVgDkIlpb7X6Bk--
