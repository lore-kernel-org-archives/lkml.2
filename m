Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2K0UUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:20:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59225 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756109Ab2K0UUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:20:41 -0500
Date: Tue, 27 Nov 2012 20:20:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH] regulator: tps6586x: fix build warning in debug build
Message-ID: <20121127202038.GC32691@opensource.wolfsonmicro.com>
References: <1353971668-18900-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <1353971668-18900-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 27, 2012 at 04:44:28AM +0530, Laxman Dewangan wrote:
> When building the driver in debug mode, it generates
> warning as

Applied, thanks.

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtSCOAAoJELSic+t+oim99GsP/jPdc3YGzgEv5vyO1UWGfwMV
ijFvhYnKkrRzQiAIQhp4OPMZzDeztdRDJyXn0z6D91xrSfHVYdM9Bxz2BViMc2oY
ot0BiHpsgilxHtEiVXFRpI4osl2/rmmfPSGbuaDqCApZdDrUPq2KdtRmfHvnzUxQ
+WME+wxQLOtMjmUjv1xEYk5D96ytdtP2TeWVCTaq6mQW5br9g38aluVQLqjxX5xy
biyHH15x/h4WGhTV4oAwg4kS+OPzru9Ul04DpNRJafT4fsF1X/e10cDSrDhCbya4
pQUGlzk1Mawd2vj2d8rDKGPvZyBJOyOg0PDe9pvWAUa2K7444s9NEiKrwKPcfv5t
Bc3LXwEgEtpA7W/HGyG2/7PFZ3iEW+gItKThuZOxGwICuw4wCfm+sJfqNoFFk0Fs
B6LY/g1GYs+vyKeD9a1zzMcDPozn1W1iOjMBk5QOUfZUCpk9NNbwruzi0uPlooyo
BGm2Ep41/8RFSh2e+FRtV2kY0AwAl+rWuvb2Jo7cq1bBalkagjbNa2rxl9BT5P5T
7k+/8iRx2GIcT69pMbzPSjW6cxrbcQ/s4GLatFhuv9m39yzML4K4jQy/2T7/p14f
UVV6xNjPQLRkQcQJVw7IigEPwBmVABANMNG4mBYLYeMcH1M9MEUsWvEuGHlwJ9ry
zqA6vLsbbWbUxB8k6HuO
=Rj4R
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--
