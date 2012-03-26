Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2CZLAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:00:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51228 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757183Ab2CZLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:00:42 -0400
Date: Mon, 26 Mar 2012 12:00:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
Message-ID: <20120326110039.GK3098@opensource.wolfsonmicro.com>
References: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <D958900912E20642BCBC71664EFECE3E6DD312816E@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zPXeIxDajdrcF2en"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD312816E@BGMAIL02.nvidia.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zPXeIxDajdrcF2en
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 09:21:33AM +0530, Venu Byravarasu wrote:

> > CONFIG_PM also covers runtime only PM.

> As CONFIG_PM covers both runtime and full system suspend/resume
> activities, I do not really understand what we gain with this change.

> Can you please provide more details?

You've only got system sleep PM operations, CONFIG_PM will leave them
built when CONFIG_PM_SLEEP is disabled so you'll get build warnings.

--zPXeIxDajdrcF2en
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcExLAAoJEBus8iNuMP3dyOwP/RCy0jBQqZij7vkhy1jpycR3
hxBCG1vX7XYBixCw9xipIXuRD/GUpw36uE5+EINrR0ffDfhebBMn/4yEA7pIoQ8b
82LZ8+Ce5uhCc5OswAcY9ZfEmtFx4f5JKMNw4aR12U9uZ7h7C9G+RpVbHon9yBCK
kpV2or4lFnlNZ/sPtqR0n3dDo0tHcDvlUDQKt0T7YKJikTRx/DEGSDnbYLQyv48T
d6PSG7YBjzkqoesxiuLVGMlymR/BIuNyw9mRnmvvcdrdltp1XkjfHrxEdpcBXUDF
dHl0vrCKSVkpbHwKbd7T7TLg+sLhRaDfW4gDhaOC6J5re7w4riSvJ3pAj2SASP7r
oNhfRTQ+j9jPPhmJXE4pE+4O7p8YYCTyFdUKAyly0ZdqznKnIwyWjlCBxHvuJfdj
lEgfmuBs3C4Pyx+YpFxjQwL3YQmFFN/kWtHfIHynHQKdp9omfHOQ9F8wcmwZOc5G
dIytwU6kGZ/kzph4hkcxGR0uQjJPUfum7OrzBjKDWZGTS6stznB4g0kNcgwQR5Xq
0pA29Kc7qDa3KJwLAq1DafC8hhTotUpd7jaILxrf7/FNDz+qiyhzrbrFmn6bdPnd
HkJlgQWBi6GJmfWXhdQhtwLhmXm024BO6jL82xjiQGvWfpJa4FVzQTj6Zl7VRZjG
JXi8KeBJnF/hGi9LuBD0
=nzQp
-----END PGP SIGNATURE-----

--zPXeIxDajdrcF2en--
