Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2FZNNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:13:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38185 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132Ab2FZNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:13:08 -0400
Date: Tue, 26 Jun 2012 14:13:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: core: Check that the selector from
 map_voltage() is valid
Message-ID: <20120626131305.GS30406@opensource.wolfsonmicro.com>
References: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1340706382-27297-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAF+7xWmR-ogy2k+e5D0og7gUPeb7dVF0ZE61QaVDeQV=6y+PcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4dIe/AmYstFUGHTF"
Content-Disposition: inline
In-Reply-To: <CAF+7xWmR-ogy2k+e5D0og7gUPeb7dVF0ZE61QaVDeQV=6y+PcQ@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4dIe/AmYstFUGHTF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 26, 2012 at 08:40:42PM +0800, Axel Lin wrote:

> This patch does not apply to both linux-next tree and regulator tree
> (for-next branch).

I know, I had an earlier version of the change I'd forgotten I
committed.  The final version shown in the diff is correct.

--4dIe/AmYstFUGHTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6bVWAAoJEBus8iNuMP3dCbwP+wd9W0Xv2OXQyw/X+76Jfg1I
HiDt/1V2IgEOaNvgPr70LlmV/hnTKcej223Q0s/iUXj5lk8FvtrvaHtgc4kFmS7e
XEQVuLL6fhD9qYReGHXEcVl4It3pnDvb082onZ3jP6bcWkFZ+ogC5OIGzkhCyO9b
6Kfuy8hhILe6ErkXXyIrtwcEdpkDaEPeBZnCXN65aCt2uAAHf28CSkyYMiJVeG+S
kvJ4+Hs5S546kEtnOQiazzOotx9qY0WdGJGx4WBRtO0wQDxf5sQBSbYkX/xC1ueT
Eo4RVtMPRqLe1Jemu61urY/LhAmPaq9ONgGgNZ25wqhWnges6UFj/0BYId2wVXTO
Fwe8vHilDRy+W12iAl43RF8f8f+TY89ECWUKYPbgJ2bFiiNsnx1e8ri9ulF8qCw7
ILG7JJqJj/WzIoDesi9O/qSgB9E1CWjYJ8lSDUjbN8uhjPhjDqOhF306Sn8Sc2lY
c/CtASb5xzynOE6ZuOuWauplUFyXW/12v8UeYQGHYpu5OAojVAlHF6fTZh0jHLlE
AwnEjGFDoZJ1VmgT4T2aHmVva2yt0FqIKwJ8BBI5DNROFf6GXAaH2wtdi9eba4lP
LgjNCCNj3atTvMsbBl5j3oGjYFnKy+flKiDaKpkt3bJDhUvDIxEenB76RzoXbG7Y
i0RDjlqDKlaKk+I2LUK9
=ajts
-----END PGP SIGNATURE-----

--4dIe/AmYstFUGHTF--
