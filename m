Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2FMR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:59:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52132 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab2FMR7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:59:34 -0400
Date: Wed, 13 Jun 2012 18:59:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: Re: [PATCH 3/5] regulator: Modify ramp_delay value for s5m8767a
Message-ID: <20120613175932.GI7804@opensource.wolfsonmicro.com>
References: <042101cd493e$6e2e9900$4a8bcb00$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AptwxgnoZDC4KQWS"
Content-Disposition: inline
In-Reply-To: <042101cd493e$6e2e9900$4a8bcb00$@com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AptwxgnoZDC4KQWS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 05:27:54PM +0900, Sangbeom Kim wrote:
> As s5m8767a is revisioned, ramp_delay register is changed.
> 5mV/uS, 10mV/uS, 25mV/uS, 50mV/uS, 100mV/uS ramp delay can be selected.

This is fine but I'll wait until the preceeding patch has appeared in an
-rc before applying as there's a code dependency and the prior patch is
a bugfix which I'll send to Linus for 3.5.

--AptwxgnoZDC4KQWS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2NT8AAoJEBus8iNuMP3d0yoQAI/OdNwmOIuEQpWVm6bXP7oC
sY6NqEV2jrW2hZpC75j2UX1z1X5JABKjgKYDejEd9FQD9laSK52bg7U7cBnr1idk
24j4jw41C2FzVijC7aBM/FYFMCJ0i7LTiVLPktsHMyG6QUEzC7GTkXD6KowksIsg
1rVvZCeMSNjrIuD1/qHZHNOFQ0Ebd0u/lidwbsocGIMQQvwHtgiL91JHRgf2VK7+
N6ZSQozNUpREn1eMD/CmwIx2JT5oqt4NTmXbw6OxISlslMOp0g3FwCEwLny8sdTd
g7PecvOFa3TTqhK/5HsCOQplnMZHHGnuyySqYTJBVw6GUcJIHlBzrXwVJw/NA8vq
uUUusntYGyXfhgl8Vd64p63ZYh1oYVG73e6UH18OMSC9iX5+XCFpyyJnWcJ8xXKp
B1rw3FtvpTKIYXNl1XpW3zhCTTzUN/KdyID2DomJoAdQoCWlcibQ9IrowLYqDADG
DfNpDsu4kiv7354VxhALeo+jBMC/wEyJls2aelsEXbOXT5YJUX03yOYc9L9XdMOC
l403a01EeolVmsCXzoJKrU2kW6EP1HwYdV6U7/qivOOvJFXgeY2SY3rrKk4lCq+N
WbumoiNYQKlRr5ePYY/ApjZY0aQTlrlvD+Q2r1p3TQbW+WBiCJi7W8M3bSzn8THs
STiLWVekXD7osAsCAe2+
=+BDA
-----END PGP SIGNATURE-----

--AptwxgnoZDC4KQWS--
