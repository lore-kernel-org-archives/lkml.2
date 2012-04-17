Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab2DQSWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:22:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50997 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab2DQSWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:22:08 -0400
Date: Tue, 17 Apr 2012 19:22:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] Add Wolfson Microelectronics WM8776
 codec ALSA driver
Message-ID: <20120417182204.GV6652@opensource.wolfsonmicro.com>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <20120417170431.GT6652@opensource.wolfsonmicro.com>
 <s5h3982p71g.wl%tiwai@suse.de>
 <201204172015.14582.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NBQMqqtZQBFxm+aD"
Content-Disposition: inline
In-Reply-To: <201204172015.14582.linux@rainbow-software.org>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NBQMqqtZQBFxm+aD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2012 at 08:15:06PM +0200, Ondrej Zary wrote:
> On Tuesday 17 April 2012 20:06:19 Takashi Iwai wrote:

> > Yeah, these stuff can be better put in pci/ice1712/ directory only
> > for ice1724 driver.  In that way, you can avoid unnecessary exported
> > symbols, too.

> Xonar (oxygen) has a private version of these drivers too. It could be=20
> converted to use common code instead.

Can we make a sound/legacy-codec or something?  Or fix these drivers if
they're actively developed...

--NBQMqqtZQBFxm+aD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjbSuAAoJEBus8iNuMP3dxEgP/jJQRq8WAj4cAGjedX4TTpfZ
VUvkHmI1HKIgB+va5RDWF/65HuerotczlpffydZss+LGkPqTYqQGJgHUvymfuinM
gIFbGkW/d6K1O7c7huCTUqbsH8SIAfxLAlXHLJTqzJ8uofc+HGqFP7gf5VcfYaFt
v0JAOWFOxh5rH09+x7iM4y8kDg4DK35UP5Xgl7TgbelFsh+I57XKKY04kOzzoMAU
qh1/3+MQkQ4JVxKxx9sf/BfRCMrbSlRqRtIgGg6WKVrtL8Gc9CNeTIxFL9sOHDYw
jqjc0bjheB9ZdExGc9FQuWsYlHTvmFnpHnuJB8D7fG7HIgY7qDSePLJjMXx6LNET
wMi4CplLwhGi2Gf0sbFAMCj19fJ45p/ML2ZqDuy0OMVmCppSija4GxaLQnYKWbxa
XPkoXka9NByJZLqkCycOFsifPQl4IWFsNCKwA10Vou5yevY5XAPpo1dAHivmRs14
d5LgCK+vq8sfzz68evDz/3cvdlM2laWeyvzhkTo0HYAihKqIuG9rxgcFcG7HJpap
C59ElVCbvsMN4+PR6L5kg6qden6SFy/xdx0ewvU2dDTPbd1kVkiqipLTCcajJhv9
OdQeh8qOSAcaTdHKVy0KMdV9hu+5FYxug03/zn7doXR0EcugkinHezXgMB6FdVUG
LM5aVQafzcZAXhobf/v5
=xGZI
-----END PGP SIGNATURE-----

--NBQMqqtZQBFxm+aD--
