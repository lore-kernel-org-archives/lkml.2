Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab2GEMmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:42:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33875 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab2GEMmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:42:21 -0400
Date: Thu, 5 Jul 2012 13:42:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH 6/6] regulator: max77686: Add device tree support.
Message-ID: <20120705124219.GC4111@opensource.wolfsonmicro.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
 <1341460705-10868-6-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nc+Vvx0JXuqp7Zy0"
Content-Disposition: inline
In-Reply-To: <1341460705-10868-6-git-send-email-yadi.brar@samsung.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nc+Vvx0JXuqp7Zy0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 09:28:25AM +0530, Yadwinder Singh Brar wrote:
> This patch device tree support for regulator driver. It uses the parent
> (mfd's) DT node to parse the regulator data for max77686.

Applied, thanks.

--Nc+Vvx0JXuqp7Zy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YulAAoJEBus8iNuMP3dgpQP/Rj8LwNffGCjLYr5WMmTPkcO
FL3as/XERzvei0MKroJq7TdvYMmn31/bI/4AeFbPdqp6xzGgMoRR4RAMpittpRyo
QIjymEXA8BdDToISarX8C+a7yorepMiTmOF7hA3XONvsk0LkOEMWVA7YIHVhjTGB
SJdfQ/LrApb6B5WnC3y1J1atGeyRDNmUKPt2Ft8Ix543NUn/W95XlFG7rM5M/L1C
5wZg/WLi1fmsL4fJhB44U5FNPOkg6Hn9q+scyvmTGT4yGX1boOTEpOcOoXYm+nUO
7L4FUagVtOQMK6hZ1XeWsD3Zz62ImyYci+X3y+ryk8yawj/utK1LtNd7bwQ3UsSn
g4fRBIV3SxyeXDVDWrWkMn/Al0pB4Ngcuk21vL1SFiiMSzVMqvdnqKLOS9fjzolU
afPtMrT5Tv1huGqTYMnkOZKSjsTPcjagRU47J1T9wvZSjnKifEFGfCVkI48LLD82
8YnGuCPmhVe0I7jpfon4cQKgdHtUPJE1tLzSm2h+8ThyrGNlYp6jpLpvplvNcPwn
6eKMMeNcjYB0ei1nhmeQm0DDN4C6Wqn0MJvYNg1c/6M13SEsHBOqf0pl5hmUlQif
0TWqF4kQK+f/bFwdFKdziZOhWs593cY8huAj5uHTN3/nQF5XkY561hXHLY9N+j4c
nEWo0hlKoUqimirSzoU9
=iYfc
-----END PGP SIGNATURE-----

--Nc+Vvx0JXuqp7Zy0--
