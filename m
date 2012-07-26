Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2GZPMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:12:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49099 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab2GZPMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:12:22 -0400
Date: Thu, 26 Jul 2012 16:12:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
Message-ID: <20120726151217.GO3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-8-git-send-email-lee.jones@linaro.org>
 <20120726113204.GY3099@opensource.wolfsonmicro.com>
 <50112C29.6020606@linaro.org>
 <20120726114215.GB3099@opensource.wolfsonmicro.com>
 <50115961.6060509@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rdeY6f/ml8+xnc5C"
Content-Disposition: inline
In-Reply-To: <50115961.6060509@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rdeY6f/ml8+xnc5C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 03:51:13PM +0100, Lee Jones wrote:

> I don't think we want to use regmap at all, but we're forced to by
> soc-core. How do we over-ride that behavior? By writing some
> nonsense into codec->control_data?

You should use that for your control data, yes - you're not forced to
use regmap at all.  Like I say we've got a bunch of drivers doing so
already.

--rdeY6f/ml8+xnc5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEV5CAAoJEBus8iNuMP3d9PMP/0wH5OQjI/xPStJ6xFo/dICo
vm0H1jWcWYo9HNi2ZxhqD0hCGUvKnvaWFF545ZsfiC4x1ePG2cmrd9I1rQUiKMKO
Xf3+9peLXNYkcw2ennfL2Hf0e5ARiQCA1k518sAnJmG3WFs78vO+0r9T0WYVUl5Q
0K1IvS0wuQTbNFXfIfPr4wBqnG9fUaMiXxgbbo6r7eIDrNOSMLMy/6CtNw0QWi97
TdoZqxcLEOHulQSESLTM3Zy7hJjDJfOK1nlXNOIlI+hnsaF5+UnQN05qnCUpQtCc
0wFEzkkFaGwNDG43qA0DPa3YtyPngJIIC8aoYHKcL+eaJi83HcAMRYDjf8Y7dg62
Cttm7H3Os7B+Eq8PJt57NUrFbaMF52N0XJ76MXL58yFzazju+FForHRCG/Nb762p
OVXcIz7z+JFUi1oIq6PJqS0odqJEABsidYfSxOJHNUrr8Fzx1jcp9j7aNjSgntIW
dBIqM2FY+bRbMeA8HsqrqcdkwMYFd5/nHVNZdDnRYG7CPgOL20AblzhREtSIaUmW
dEGc/GMrIsGTag9FuTeVKUez0QNJj7kYqXeipuCWFsY0P6X0h0OQSYSriglLmWRs
eOOVAMyjJGGhQQohkqQf1Sc5Us5cKlRLnr9VoHBtkyhOuzKqgK8oG7lIsjl9O8cR
tzccHGS3IyDGNhe1uJTj
=bSDe
-----END PGP SIGNATURE-----

--rdeY6f/ml8+xnc5C--
