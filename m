Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2C1K6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:58:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37800 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757857Ab2C1K6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:58:11 -0400
Date: Wed, 28 Mar 2012 11:57:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Estevam Fabio-R49496 <r49496@freescale.com>,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator
 for the smsc911x device
Message-ID: <20120328105745.GH3232@opensource.wolfsonmicro.com>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
 <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
 <CAOMZO5DL8YQT2qb=vxdQtdN+zfZLK9H9_1qu5sS+1YAvSo5SAA@mail.gmail.com>
 <20120326181912.GV3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YrlhzR9YrZtruaFS"
Content-Disposition: inline
In-Reply-To: <20120326181912.GV3852@pengutronix.de>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YrlhzR9YrZtruaFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 08:19:12PM +0200, Sascha Hauer wrote:

> At least it did work when I sent the patches, but -EPROBE_DEFER did not
> exist at that time. Do you have the fixed regulator enabled in your
> config?

FWIW all the -EPROBE_DEFER change does is change the error code returned
when we can't find a supply, if we're hitting that case we'd have failed
without it too.

--YrlhzR9YrZtruaFS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcu6iAAoJEBus8iNuMP3ddTQQAJ6ScI5NizvyQQUqKEnzfMct
A2yTw/C2TPezcp9X9wyQywgSohf16MysdU0jELOEe0HMB+bySQ9Jg4paMVf8F86r
42J/xJdyUmYwahh8bXrQB2i4Yv8YU2SAR2TUO33CMSVDstznhGpPUPpkht4mItVW
edFeGhG0uJptp3s8WEFB1KSv9nB65RQZxdId0Yi09G+byLOy9yaocE1jZVNX9wxw
ziooDqFDQqd61lSTnrLWfWcYtvc807nvW3Cl0BGLjEZq0locjkxW29xo6XJyKB3T
jJ+veSX5262K95MsraRvKbMMvwtnWb0qKM3OABgA9i4ynM9V98QOHIm3vLFn2KYN
r56TXHon4Ue2e15opjwrR9bco59zoytT5xhvrpK0MbS64Fjdc+JOxuF8e0GmQFoM
PPHDQA7eCPIhBmns7bEvJkBLUoLv9SCxsPcwPBqG3ZR8pC+jiIlPQ5/rE10vWcXL
9lituuLWO4qtPCx5R7MXBpf6bPpmGJDBMeDuaBAQh9DWuBbC3rflxaX/Jgq9tQmB
pRqfQpTNi1VujzRWZN9dJzzMRr2eCAyWhLKldbeORDJMNfAQbhIda/WTeSGjP6u6
77olvBrlkefVvIyBp23AmLA0Bl1rLUA3/lnAIrJtzWrrLoyeavyui3k/jDNd0Sm2
sghhxegxpCRfPEf+STr5
=zFdV
-----END PGP SIGNATURE-----

--YrlhzR9YrZtruaFS--
