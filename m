Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2KWMR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:17:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab2KWMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:17:28 -0500
Date: Fri, 23 Nov 2012 21:17:24 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: provide enable/disable if external
 control disabled
Message-ID: <20121123121723.GL4529@opensource.wolfsonmicro.com>
References: <1353659862-3072-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/UvyDgxjlFfP/4zZ"
Content-Disposition: inline
In-Reply-To: <1353659862-3072-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/UvyDgxjlFfP/4zZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 23, 2012 at 02:07:42PM +0530, Laxman Dewangan wrote:
> If external control is enabled then do not provide regulator
> enable/disable apis.

Applied, thanks.

--/UvyDgxjlFfP/4zZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr2k/AAoJELSic+t+oim9Yb8P/iqdbcsV84pgv0+T4uRGWC2H
EGRkEO764fcm8h+pWFiYB5Zi9SNeksgATDUnLZRDaMKjPQ/yZCTSepc3gd3AZW9g
pSM3JpOAn4ubC/OOd9oP5Qq0SJMPt7YyYiBjfHkVqWt6UWQwGNT+/qVTSu31K33t
FZAfW8MFCmJMFi/h5zDxjkFMSZCv/9LQYxcLexf6RVgEUouQcOQDDw44gC9R2VDE
mlD/Q2+Vu1PKrUdPo4TVk00RGwGqZwntb/U5UefGdpPQJ3AVb2k1JDcwFzxYZD2M
0LxKrIbcigYL/NusUzqf3/3+HEbN/Y0tlypfjhqKzDUfrS0Sw+BOnC/ngdriMgXa
jWcmkqALvMk454vRUR3sZZduO/9hltfnb9twWpvkPKn8q27GA1591dtmVE8oy5c6
rgYtem7F+8keDvX6vEuEhoQaKRIbFxKLPBQ3F9S7JxCSeUgoWkkQ439Ic7L40UCM
bouiz9lu1JCE8+S3Rt/SFGKhVRDedx9P8cTYpqLpQvA33z7Rau3vse2LDvuA8hAK
sY6OToE9wN+6e58aHEQACBHNdFK0frWKfxCrpNfYjYelWlel/hhw24LT1OuurIJd
xIrzJ0RWzCM3Kmsw/sb4FGPb81n/YduKa0dRN48d2DgvQ7CbEMmdAmI0r0qW+RVr
tWhNjFnPD79DpZy0eMQW
=AjKg
-----END PGP SIGNATURE-----

--/UvyDgxjlFfP/4zZ--
