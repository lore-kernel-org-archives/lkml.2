Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2FQSMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:12:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33971 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757752Ab2FQSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:12:13 -0400
Date: Sun, 17 Jun 2012 19:12:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philip Rakity <philipspatches@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Philip Rakity <prakity@marvell.com>,
        Pankaj Jangra <jangra.pankaj9@gmail.com>
Subject: Re: [PATCH 1/2] regulator: core.c Pass voltage to notifier when
 setting voltage
Message-ID: <20120617181211.GC4267@opensource.wolfsonmicro.com>
References: <1339784856-1779-1-git-send-email-prakity@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <1339784856-1779-1-git-send-email-prakity@marvell.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 15, 2012 at 11:27:36AM -0700, Philip Rakity wrote:

> V3
> --

Applied, thanks (though this changelog should've come in the --- after
the main changelog rather than before so it didn't appear in the
changelog).  I made the spelling fix Pankaj pointed out as well.

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3h3vAAoJEBus8iNuMP3d3wMP/3MWGs3uuhMF2i51REQamcZN
5YH0n/kl4AkaaUsw1OwJrTyWw9CFGXhIco02+b3JLyo+JwBh0sYRDtI0tKrwMhuR
rerqSm+YDX4T6ZgFGOvq2T9DZAWVeEJJJki5Kq8R3XUfvdnuaG3i+UJ3vxQS/zFR
lB6+4S5iGrv7nwvfCkGJ3RUfWJOkBC7Du2NInawZYXyKITg7Zrsy+O/KiuscejOT
av40Vc78LLPWcTAvebSkVdRdsPB+9JJfnmR3tDfL5OllwajUWycOVyW75E9Jf2V+
xrH3q7x428ZVmYT230yBde5wheDf/vUsKBcVRtAopI8ho6zH7radvHbelD/0570D
jxVnCt4PBPC1J+zTTT6U8JD8v59cjUrRIgg2QREMnSeMQryDxwFmRZfffpjnjip6
Hi19gUQaHklqD0hHRo58Q73UKjECcVeFY4FDyvzcjus9qOEXnKqRk01D1AQ8ZRZK
v/grFKsGvAF14yIVra+RG6Ior2ITWyIPRRf31uMiJjLxcMEyJr3xP0V8LbXZ10mL
DG6JRV20SL5wozXTTufgxTcSye6jc1dkfRN6p5/YCnqu3lPDxiwwywePG+yKMniW
PPcJJMLUsUtl+LqExrZiduFSmtgwYKD0yiMx3EaPvBFKqxiIcl9O0HmICFgUaPQb
BgI/GQCogylXJUGoTl8g
=4dcx
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
