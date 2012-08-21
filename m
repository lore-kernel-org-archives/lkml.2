Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2HUQ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:57:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48157 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555Ab2HUQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:57:40 -0400
Date: Tue, 21 Aug 2012 17:57:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Alex Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120821165738.GY7995@opensource.wolfsonmicro.com>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <1345535069.4085.7.camel@deskari>
 <1562509.b0FYTUZ1D8@percival>
 <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
 <1345539465.4085.22.camel@deskari>
 <20120821091306.GA4819@avionic-0098.mockup.avionic-design.de>
 <1345542860.4085.40.camel@deskari>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ubca5Sl/zyRO+Ah+"
Content-Disposition: inline
In-Reply-To: <1345542860.4085.40.camel@deskari>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ubca5Sl/zyRO+Ah+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 12:54:20PM +0300, Tomi Valkeinen wrote:

> However, if we already have a generic driver for that type of panel,
> (which we would need anyway for the DT based approach), the developer
> only needs to add the name of the panel and the data for the power
> sequence to the panel driver's database, which is about the same amount
> of work as with DT.

> So it's really just a question of where to put the data in question, DT
> or driver. Both contain the same data, and the data structure may also
> be the same. In DT's case it just needs to be parsed first, whereas in
> database case you'll enter the data in structs.

I think the device tree idiomatic way of doing this is to have a bunch
of .dtsi files for the panels which then get included by reference in
the board files.  This isn't helpful to people working on non-DT
architectures though.

--Ubca5Sl/zyRO+Ah+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM734AAoJEFJkBDiqVpZ4h28P/iblWU1WkmSB3gX1ANEaTXg2
MiYoBQNiUON4KY+6nOse+vEGsWlhsNaCmsxxp1zp/yNeG5zzPUhcosh6qK00IxMI
dlu1zMJ5Ng4KNq7xAVf2OisX8UAfUNK4PxdzwClGhmy7/oSN+/ojajhRDRAWlODw
4V5diV6t6USWZocfTrsIHBMJju1vMgm9H6T6JoND7azvt+mk65PQFh6IIQyMJWRx
Q4EDivYkcrLLR2cmLlPq9SAqCy0Jhym0HkL8tYNgQafu4/SjlkRTc3heLiQzMmDB
cnaPjrEkIjn3ONqBsueBismBQR6I7Q4lt3u+XVwVu8i1Cc4aOIpAelhh40ZE7DM/
+vgsQsulybCO9c+WxxK+6ZGnEsHOPIoAyJ3V4Dk4zG0+22W/JQPRl9DPfd2i96CN
W6TXAoqXhsAawCVjt/MLCzzmuxk9qX6R9+aBLQF4d2MygVLKeOm6MM9Jm/XOxf0b
BWfHADatomudMD8Ewxij+uB+4sgp+O9pzWnERASqERO06yvUWM9QO2uuNYMNNfGV
ZMtV+LPspwnZxvOtSKgG7DENcVScMq1KNJQMjrp5X6bEhaaKwyO6F0MHMYAnJmAl
nNVjct/Rbio/XYcySv2bcUln81iNu5qJCeyGVhirJNHeWFt2EnbJc5RUSZa5K7eC
+uTonIehAvqSzbGlma7H
=FIV2
-----END PGP SIGNATURE-----

--Ubca5Sl/zyRO+Ah+--
