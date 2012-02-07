Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2BGLfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:35:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49064 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab2BGLfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:35:37 -0500
Date: Tue, 7 Feb 2012 11:35:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix getting voltage in max8649_enable_time()
Message-ID: <20120207113535.GH3332@opensource.wolfsonmicro.com>
References: <1328584375.5528.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MP5ln1Rcf9Bvi+ZW"
Content-Disposition: inline
In-Reply-To: <1328584375.5528.3.camel@phoenix>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MP5ln1Rcf9Bvi+ZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 11:12:55AM +0800, Axel Lin wrote:
> Current code takes wrong parameter while calling max8649_list_voltage.

Applied, thanks.

--MP5ln1Rcf9Bvi+ZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMQxFAAoJEBus8iNuMP3dvsIP/ja4+m28ihwjYkfAtYbxEJF8
ffSHMIHmXq1ElJ0ZLLBbIqPXA7V+507+UfFFrWtgUTovw9Jbe5M2/gBENw1C90sc
MtpJoPgnPILqmi3wp2m7zd9ePKWPRd72qo7yR3ckg6W9UN3muXNcEdxVHe+Uldlg
BmWPRx/ZtsVZ4adPqJ0Fv3v7StLaIZgg36fzuN3e/JiirXRD2LQ9PI/Y6rkRDnQ/
soRQQxxy1u7zqtB6WKrrfB1kgXAhvvAYDBueX7gVVNlf/nD36W+/PpYjQg5DujOw
QWPC0l81bm6zBO6UTYrWJOk/fJUu//HiGekGGqL+42z98gtNDW4w9fV8HhFoFo7z
py8jco3Iuo7v1ii8SpAwnv4XCQ6xGhuwwHd0YLwsx++xmHRqrZrNsBgDRNjHKJzr
hVQEhfkrV0UwcfHbRCfa8P8lmNvMR6mPBf0igljuBEgCCiyI6tMLbSJuoBJ5xrli
IR0S3BHxKM4b2qc2IcaY/Sl5T44e7coZCFLoVDhFJtDdq/P2nVTd0TuFNbNogoCb
X8MiJb7KhMTbfGBdRWKzByaIt4+zgPBqx2OnaTMils4xtbKvgfcb1/ywNDOXdhaw
3lZ1DI+IigATHrznMWgT/mt4WZi2tvHokjPb71t1TU3Rz4zVNzRBMcSUuLGw3RyW
pZEgEXOZiu0yxbgtHMfd
=kmQl
-----END PGP SIGNATURE-----

--MP5ln1Rcf9Bvi+ZW--
