Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1F2Jap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:30:45 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:55591 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab1F2Jaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:30:39 -0400
Date: Wed, 29 Jun 2011 12:30:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Felipe Balbi <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110629093033.GB2760@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
 <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
 <4E09C573.2030607@atmel.com>
 <20110628122650.GK2612@legolas.emea.dhcp.ti.com>
 <20110628160252.GQ17355@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <20110628160252.GQ17355@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 28, 2011 at 06:02:52PM +0200, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
> > yet you will prevent the driver from being easily used by other
> > architectures. What will happen is that a certain amount of:
> >=20
> > depends on (ARCH_AT91SAM9X5 || ARCH_FOO || ARCH_BAR || ARCH_BAZ)
> no I disagree this is done to allow only the drivers on proper arch
>=20
> and we do not need the multiple depend we usally create a HAVE_xxx config
> that the ARCH select and we just depend on it

I still think it isn't good enough. Ideally, drivers will always be
portable without any arch dependency or the HAVE_XXX trick. Still, it's
not worth to continue this discussion, I rather look at a driver which
now depends on ARCH_AT91SAM9X5.

--=20
balbi

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCvC5AAoJEAv8Txj19kN1whgH/jyYq0PqnyCdL7xeYx57sq1E
DF1umABxAkxelJ3JixMoEGPZhYoxLqI3AEfd7iat3+jL1JWdEZkg8Vji/0INeCKa
jSniFGFYzGtyUrELCLVwJC620m6HM0AGw/x9U+uT89cIZ2g9j1IcwVvuHyfsVFlw
HweQvcWqALn6J3s/rpLokflps+Ql1p6ewu2L3LSGq/aGyWUWXZZ3F1S/oelzO916
Kl0eLlysSMPPP1COeCq75QmsVI+r82M2gMz8jhwWZWztDCMRRyAiueBbFJu7/dT7
9krNrXTSfV/gS85sRCfL9Hfjd7KJ3TmnQv8ARXX4mE3Mn4MvFjaXsosuZKgZN2w=
=PmYq
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
