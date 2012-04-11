Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2DKIOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:14:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38506 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab2DKIOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:14:53 -0400
Date: Wed, 11 Apr 2012 09:14:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regmap: Fix build by removing extra parameter from
 regmap_debugfs_init()
Message-ID: <20120411081449.GA3163@opensource.wolfsonmicro.com>
References: <1334100546-2534-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1334100546-2534-1-git-send-email-festevam@gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 08:29:06PM -0300, Fabio Estevam wrote:
> commit b4eb511 (Merge branches 'regmap-mmio', 'regmap-naming' and 'regmap-linus' into regmap-next)
> added an extra paramter to the prototype of regmap_debugfs_init() in the case of !CONFIG_DEBUG_FS.

No it doesn't.  Some commit on one of the branches that got merged adds
the parameter, and this was already fixed on that branch.

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhT1wAAoJEBus8iNuMP3dEmoP/1KgysLfGuGjba7baxd4dBKL
2/q8+RQ1Lfd7qvGyMSQxFXtqSI/0NlqgM7/49/uItf+mJs9YvaL/5tqLuAJM16VP
qajqDQPizYUV1mCFkDffBSZubvX+PC6mtvK8Qvq/ip/myZYBBSkC0d0GZw8mt+lA
XfocEKUP21Wtse5DfpIz/reoscXQ9igBOv5hUGI5XhMnJVzzgCURPcyn5Eusc3tt
WjJMy8iv0RaezsxG9Mz0yF+SVTA8K54fTqIGAFyxSwtaWHVAeOdB2MQxWbAaGvaA
J2wwVKQGoszm5S5pFIdZeT9BCoxtuNOKtZeEpV3ncIWoywgS+eOo0yLYuSNOWvII
BcmOHJz0afgMYkZbmjb1ih1WEZt79HmOCRjp08ocQkpTngV9C4RdT2AwmXwvsVWd
1Ibce/O9tziF41wAZNZIku7x7aFj4hOIFZ9aPutPryhYoKWJPZLbwPqNI4aHavI6
o3Ulnvwe8q5dRwVpSg2CjN1qIa4kn+V06WpLhWUVH7Z+nNp9+BpQikpcwSXdkd31
i7nTTGxOSQrOXup49507haRslfC1YaiRuJAGbLj67tPGrySYtsIvlrQcl1t5BWCI
p3fIcp8yYT+nrO7BnqHwL/633Ck9oFoJGC2rpMB+0BnPkvWIIPrzlJuaZ/MfKyjF
nZu9uQEfVU0Ygf6HbYIP
=gNCt
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
