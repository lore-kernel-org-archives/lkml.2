Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab2FUJq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:46:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37656 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab2FUJqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:46:24 -0400
Date: Thu, 21 Jun 2012 10:46:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
Message-ID: <20120621094621.GM4037@opensource.wolfsonmicro.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au>
 <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2012 at 08:13:15AM +0000, Kim, Milo wrote:
> > Caused by commit 809d310c7e69 ("regulator: lp872x: Don't allow modular
> > build") but that was done to fix a different build problem.
>=20
> Sorry for this conflict.
>=20
> Build config of lp872x driver has been changed as tristate.
> And related undefined symbol error has been fixed.
> (don't use devm_gpio_request_one() at this moment because it can not be e=
xported.)

I'm not going to apply those patches, they're a step back in terms of
driver quality.  We just need to bodge the Kconfig dependencies until
the fix for gpiolib gets merged.

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4u1XAAoJEBus8iNuMP3duQMP/jHitsD5/Sn1trjquNNmMDMP
cWHzp5HawaREK650PZ9STE35k9CYtC/op9oE1S5hKfCjY31BspGKqJ6F+CuliRvT
DMZmtZq0uuxlvLDFZ5UfN26SqDEJ280ZBxiNSWWwElUD55VQP6jlLa2iPHd/ggFH
V07POT4mlRCeKJQ+y+5bhT+jtTGMvXr+RUOUFMz4Kb/9KoQbD0XfudOl5m87fe7f
9ufypjWYUP/eE7vdfczIIAYH6skuhh5ucsMdrqCyVnYh3k6xf7mPeLGAe3qhnGT+
jNLO+JGkMNGf4n/lFPMB4Do1KEj/hn8x7PvtmNkRhU/TjcPEcXy0RYv3oM0OnMDY
b1qUx+RdK9XsntTEPVGHnpELrjJlqZbqTWqwAIWkVAKpx1wM7rSGOUp7SXZhv2IG
ZFQrpizTVRs6US48FrAwCIyvqSpTijPGHSsXWUgZOiBtMDuP9Q/wxsP7osT8JrMv
24PqhUUfcmzYZfmSK5m/VXvbSvwmovV8wbWkyiU/wDk7DioRp34hNiQHuWtoTMf8
Cbf0tgut8cS/630vLUWBsNc6OmlLWhHPpfagjzGYlUAVw8syVywvp8U413vjY76n
RhU7vX4QxG34eq6OrlB5p3Px2eTeMbZ2kYcK7V77Con2/zVOxe4TJLMvkALFmGqK
cdrR/HAN4EnO4rqnAUgB
=pDvW
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--
