Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2GEMIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:08:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33773 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910Ab2GEMI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:08:29 -0400
Date: Thu, 5 Jul 2012 13:08:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v2] ASoC: siu: don't use DMA device for channel
 filtering
Message-ID: <20120705120826.GU4111@opensource.wolfsonmicro.com>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
 <1341484183-10757-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+1hRa/9CwYN9i9M"
Content-Disposition: inline
In-Reply-To: <1341484183-10757-3-git-send-email-g.liakhovetski@gmx.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+1hRa/9CwYN9i9M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 12:29:38PM +0200, Guennadi Liakhovetski wrote:
> DMA channels are filtered based on slave IDs, no need to additionally filter
> on DMA device.

This doesn't apply, please regenerate against current code.

--m+1hRa/9CwYN9i9M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YOtAAoJEBus8iNuMP3dVRkP/iSlIm0435e5CiJPlx+S7Wqw
63HfOLlMh0pbwb9fQdanjdtGFzPJkjddoBjyTP+Heqf9XAvhfkSQHouRNbswMNRm
fWhQyoleD2p3ZIOvCBLyvrdKszEzpwerd/F2Ht5vmWuVU/SahNTWBbqQWgMIXuAi
Wv1G3iGnpA5IxLt4UtL2xpfoE16AgVRv/OW+BpWYrhAYWBQmsrdXV1BAnf1j0vHT
VgjXPJNhHvHW1N6EKNoBHVrHZiJWcYZr5JX73NCA4o6yLtwfhgLfbeEhRrAJFXi0
HP85ex/OWPcoIuCRfENQi3RWSV5KEq4i2AtvxUiftVqfC4sJ76f59eZlZ8DgILRS
0JneWDlYM4IxI4qmiufgCdWAfn8hZ1PZhXkY2irKEfPyMEU+3HCXQpxu8NEL7Ks2
isuu3qEBUKZvlf944kEryySLYiD0FiVKfeLNdi4RRCfXuqWmv3CJE7ioSXvq5xRh
eN5Un8xHq0V4QBykG0QYOv7AhhkgOk1m3A/ky0qeKnRoqVdWeYwVB3iHbQxmjn/E
q6iE960zPVRkJyzC2KJyQJ+ZmGaxIXln3fKuHBXJssdL2OrYUePhK/nuHwELIa88
t+DJ/GgdR6FuuBuyisSBXBGsQCJCLbMkLJmCHCjW3ExiCD6zLhPet6iwEIQNHn4R
GQqAmbJgxYN76QxaB2KE
=2YUn
-----END PGP SIGNATURE-----

--m+1hRa/9CwYN9i9M--
