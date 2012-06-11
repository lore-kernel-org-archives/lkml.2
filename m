Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab2FKDhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:37:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46352 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2FKDhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:37:17 -0400
Date: Mon, 11 Jun 2012 11:37:02 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Message-ID: <20120611033701.GC4218@opensource.wolfsonmicro.com>
References: <1339148851-19289-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
In-Reply-To: <1339148851-19289-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regulator: core: Add regulator_set_voltage_time_sel
 to calculate ramp delay.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 08, 2012 at 03:17:30PM +0530, Yadwinder Singh Brar wrote:
> This patch adds regulator_set_voltage_time_sel(), to move the commonly used
> code by drivers to provide the .set_voltage_time_sel callback.It will also
> allow us to configure different ramp delay for different regulators easily.

Applied, thanks.

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1WfTAAoJEBus8iNuMP3dQzIP/25paFB4MvDnKsZCpXKywouS
yKXV62l5NhBkMaSFjnMFMxbLqDwDJrOhOcNySUONYVQDMuO/eO/BfOAMO4ZIzvr2
eLsRmDVUvZr4UKYGgzXpuwIHBwa3pqnDrpHHobnYqSGp4BmXmhDV8rfPovdo9a6b
W6e5GQwz33Eid4Hd3SHC6sE8uk/LXzSg6DhpCnuiN/CmXAmhcnaa4okHthKRlDbG
7GuG2gchOOhAhH6+wBuMGM/kYqsBMoS9YpqihihQs2hDcb9AaJVvVBRofi7I3qGF
hPu+eUdpDoj0Pmb6N8ua5aEQhEjADJhieg2aHV7nSGqHfP347+qm3qhTGSuE0AUJ
tRd+CARrGt/MSfnmM9x0sXEj51KyGxPulJvoa3Wl5U5lBhhjutBqAK0TtMIbeVMo
VSeqAXDZGTlDTDxjvftmLfPAoh05VK+OAOeLK9XCzk8mr4U3vSaF48CbULaJR18K
7nZK2Gykx1PnFBrB8JZyAAIatSYzOacBcHM1yfmZigiVjFtzsvGHbX7jsDg/fQOW
QxdyJZBvG0Ku2MCV34HcOtPnYXzGq7icnD4Kuo/Yr7inUzdRmibn6PFcSg6D+8ST
eM69pdrACCGjuIQ9Xg/2Wqh1n10jPJHSk7cmQbmiViRlQlexPYKmTXPPYg/Gupye
IYEAMLKcRp74LqIIW7ZW
=UOpi
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--
