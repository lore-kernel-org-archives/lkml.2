Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030875Ab2CNOVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:21:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964781Ab2CNOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:21:14 -0400
Date: Wed, 14 Mar 2012 14:21:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        sbkim01@gmail.com
Subject: Re: [PATCH 2/2] regulator: Add support s5m8767 opmode operation
Message-ID: <20120314142110.GR3133@opensource.wolfsonmicro.com>
References: <06ad01ccfdd2$63ee8fc0$2bcbaf40$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dO6Thh8T/cwyDjv9"
Content-Disposition: inline
In-Reply-To: <06ad01ccfdd2$63ee8fc0$2bcbaf40$@com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dO6Thh8T/cwyDjv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 09, 2012 at 05:55:34PM +0900, Sangbeom Kim wrote:

> S5M8767A has 4 operation mode for BUCK/LDOs.
> This patch can handle opmode for s5m8767a.

Applied this and the preceeding patch (which is fairly trivial platform
data so could easily have been squashed into the second patch), thanks.

--dO6Thh8T/cwyDjv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYKkiAAoJEBus8iNuMP3d/dEP/2q6d10M0B9PM1sUZwAJeJ/i
gjSGPPilr+PhiNMkwjSKtl321vqOGImuKg4FflvscmAsSBJCrJoFVB5Iih++24oA
H63jzRsr7PbhaDQC9YVD44GsHpA6YVNqZdQ42w53YBst1D2w6j6AUVACT29j5QP/
jac97w3DE1pghix3eJEAhTZnu9Bl1sku+MGJoxB+D5PORtHzUk/6OIym+SAbMHAY
4/9cqKVfohd78Z1KvQ8rvDUttGcmXKm6sLmV2qgO+pKdSXOyHeYhoxayzq0LSbUw
/1QP4xMjeW6cY4xUYO4gBGo1ELHhWqfXxg5aoj41slKjiyPEZKskQrwTzFCKbv0/
ycZIhai6kAYFXLc97vpSnfo4ujIJTPa5bz5QBIyt9in3hDrRDA5fkHhuMhjxdHb7
KkFKhSW6ZgCtFBY9JKE+vxFgt6S9Jvkb5XQH9umlTkseyE2w7lUJkJ3MFlyQOP/w
P06GQuNJQlvdD8pC9BUEGsbk1qmLPfurhaMrj5yGuQ00RjBaPPQ4uqPulrJcgVNI
MThBXDSE63HjkZFWbTExClLx5vFPY08aaPKHi0xRN6bkIa/Epg7s+MuUXQtYkeAc
dgmPPxv8Iaa1giUXjSit1n7Zlfz8WMZBysWj3Q27oFljwjQO+TGlefaZ4eCwxF2S
0HdKYgxqJ2kCNV552aVG
=iHD3
-----END PGP SIGNATURE-----

--dO6Thh8T/cwyDjv9--
