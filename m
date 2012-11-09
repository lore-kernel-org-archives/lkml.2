Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2KIRPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:15:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896Ab2KIRPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:15:07 -0500
Date: Fri, 9 Nov 2012 17:15:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] regulator: tps80031: add regulator driver for
 tps80031
Message-ID: <20121109171505.GY23807@opensource.wolfsonmicro.com>
References: <1352118699-24602-1-git-send-email-ldewangan@nvidia.com>
 <1352118699-24602-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ONmcTkPhtkbQYSLg"
Content-Disposition: inline
In-Reply-To: <1352118699-24602-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ONmcTkPhtkbQYSLg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 06:01:39PM +0530, Laxman Dewangan wrote:
> Add regulator driver for Texas Instrument TPS80031/TPS80032 device.
> TPS80031/ TPS80032 Fully Integrated Power Management with Power
> Path and Battery Charger. It has 5 configurable step-down
> converters, 11 general purpose LDOs, VBUS generator and digital
> output to control regulators.

This looks OK but can't be applied as you're updating the header file
which was added in patch 1 - can you rework so that the header file is
added all at once rather than incrementally please?  For new MFDs this
is easier as the individual drivers can be applied as normal without
needing to all go through one tree.

--ONmcTkPhtkbQYSLg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnToPAAoJELSic+t+oim9L7UP/3k+HSBsdW2XyTdr0YlUDH2d
W6BA3LACCTVU8uFIVuDk36VeDD0OlQtYo49K/VpKyI/81F7bZljq28eTid1v2zf3
nkFsW/4pPeSaurH6OL8CD6laxLZDkLAGe0dzGkIJYn8HbN+ZzFl++eYV4Z4ZpYfd
3apWOeysLQFytbLPufEpDs26WD4gySeSaN/xRZFx3313WxRxypINQsuYI7fxBFg8
532ZfrV1OnkrSedrjBD/Tfx12auqPo+IRBl2Y4A14PZ21UgD7ZGph2O/OSsrpIxL
+du8VeK0plODNToC6Q9DBwvsQMRdBIoTNoS+XOhT4ZSCe2l5FAeMDTil7txoKbBs
0rjnn2VZH1vON9FQHcFXLiYOszi2v46dYYV24XQunc4NNjscMd/MRypHTIjHiLZj
+oqtV/l2wMtrCMF1mQtBfe/iTbttEeDwkm/0ju/RW0yLb1qpsboj/IGtpsKbNBdl
T9bt0g0jTbJ4CJSEV4v7iOPz4J6FVgC3TMLIBlom+ZHCzO7IAMJDdyWFtIdeOl7/
pc5ojb7dXhs6EN/zEH4swAMuoxE3qAPHMU3+JZCLUGq/xyFZs6rhAC7PO8oILe0O
vY5rnnbBABSChOrE7x29wKLmv4CT5Kp4wwNj5Uv4FPb0MLx4smiNdPwmPtq5Ifb0
hpfXaOmJwHcviBnU4hzW
=QEbG
-----END PGP SIGNATURE-----

--ONmcTkPhtkbQYSLg--
