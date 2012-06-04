Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2FDRLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:11:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60873 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab2FDRLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:11:33 -0400
Date: Mon, 4 Jun 2012 18:11:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: wm8994: Use irq_domain mappings for gpios
Message-ID: <20120604171130.GB23408@opensource.wolfsonmicro.com>
References: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdZJPH__FzsUmKnQhTOtJ1EstJ8K5LzhTXGUO_VSzrjLew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <CACRpkdZJPH__FzsUmKnQhTOtJ1EstJ8K5LzhTXGUO_VSzrjLew@mail.gmail.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 07:08:43PM +0200, Linus Walleij wrote:

> I read some drivers/base/regmap code and I think I understand this stuff
> now, but seriously, it's quite hard to see the forest with all these trees,
> and regmap is actually one of the finest new things in recent kernels,
> so can could we create
> Documentation/driver-model/regmap.txt?

Of course, someone can!

> I think this document is needed... I would write it myself if I felt I
> understood the regmap overall concepts well enough, but I'm
> certain to get something wrong.

Well, there's one sure fire way to make sure you've got a good
understanding :)

More seriously I'm not sure I could readily tell what's non-obvious and
worth writing a document about.  Personally I always just read the
commit logs for Linux stuff, they're some of the best documentation I've
ever seen for software.

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzOw3AAoJEBus8iNuMP3ddpYP/isv6dKbzhfvnc/luvnG9OxG
VNIr5pEl8rKsHBxcNvsOuoOL4C+M9q5AbEQ1YrV4v1gXF0/ND/+fuudUDo1rxPRo
gxO+GfyEzl6A+mpOB7pL8gc0zyJii3Nuks0F5RsjaNav1fk2oq22wVRD9sfn5cxD
ZGM7NcIkuIZz+HqNMxSTQHXD0iJoW4BanyrY82yYmcOFG3O6lpBhI2rcHilxFiE+
2r7NqxgfbZqob0LxkhSjBtfV2un8IDqQp0NoMYmg6HsmCWRcNJ0z8dPcVJKoxjpY
pVVcQQOm1yq1qmYW9AJfFrJCy2oDZRErS14JE/EFR6iXh/eIb5+0xNc8JVqhjEWC
G31jJ6IyBR9v6K3iVSaIcQKT4k3Yg3vEfvUsv586t79wbYX1xSWhrvM9q8vkXVnG
gbTC8C7B0WcsWlzD1eTFaqdo44KWRwn0hIySflm5jZczPOyNDPiZLnzyh4eNyuDl
ttpKRg2JMDoCSQoQS3H314A7cXxdgStLZ2jiyddCzo3d+SFjlDaqv4aLhL3vVnCS
+zP7mYO9c3455W6MLt8jRzHBB4+ybSHdYAi9/S8kQ38KlRqLJyoh44bz4bO41CIs
wwaUslKvYiAXdvJBn1RPPCPSebx9RVTpfL8fR3/6CPauYnGCXf/dcx9vLKU/mryv
FNZ5b/zj6eZjCJvDabj7
=mrDJ
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
