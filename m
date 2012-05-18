Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab2ERHgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:36:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47999 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759356Ab2ERHgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:36:08 -0400
Date: Fri, 18 May 2012 08:36:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] regulator: ab8500: Split up probe() into
 manageable pieces
Message-ID: <20120518073603.GC4073@opensource.wolfsonmicro.com>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
 <1337262323-27692-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <1337262323-27692-10-git-send-email-lee.jones@linaro.org>
X-Cookie: The time is right to make new friends.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 02:45:14PM +0100, Lee Jones wrote:
> ab8500's probe() function is becoming quite large, so in the lead
> up to Device Tree enablement which will fork the thread of execution
> this patch splits it into 3 main areas; basic error checking will
> remain in probe(), but regulator register initialisation and regulator
> registration have been moved to their own functions which will
> be called in sequence by probe() and the DT equivalent.

Applied, thanks.

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtfvcAAoJEBus8iNuMP3d0uEP/2rJkLZYjOfYCsV2qNMkUJ3h
9SM6VKC/SA95bcGIN5/lj/rlENInMXaxV6yHb6oEiPu1FDsLQQIubRVW7tCe7/+J
UFf+gkNB4ICJJnXzym/et6i3zr46d8+eXbmPj2tvWKZ1IiKT16aOZ8xH5DW0rw7I
+fHALiQrRYEk4PerW+n0zrFw5E0v+9Feu0gv2nRXdW47Ojtv783Tb4ZeBjShZdf5
lnLrkdQYMHdfZJcxOIrT8JU9r6nz/BRMnVZL/X8upY/356TVxBBwuI22tSsP/MlL
WGrknpggrsBS1l7KFXUeYpmyRMyj/cuznd9xbX2vKygVmHHDbvOndzotBLCvtPHY
ykDEjbkxmW7b46vhdYtc+++umloMoj1YL9Kf+rJ8zLSPVRj2v/6wK+3qT7RV/j/Q
OFyKdrjlYnGcR6skwWdXaVxRJd3vAWv1dfgOuhPtOMzLSJ+kxU/8zt4RTCCkJw82
MIllH8byAQc2NgjF45YF112Zw7jJ40pjAwT8pXgoynn70aNJLXvNEbsvqViIJk2I
45+lfnPfvZTv548ra/28CPHY+8wDp+Y1hGJju9aZmLE4y8rYBzQwjBbuxmAyiXNY
gTV5JXnilV7rQ+bTFRfT+HkC9hYWUfpNCqy4s8I4aCZ2+yl567ciqnL1gCADGgpf
nnVx2VaQfxidFhmaRxXO
=qWIo
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
