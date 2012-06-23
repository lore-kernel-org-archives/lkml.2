Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2FWKvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:51:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab2FWKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:51:21 -0400
Date: Sat, 23 Jun 2012 11:51:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ola Lilja <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org,
        Joshua Kroll <joshkroll@google.com>
Subject: Re: [PATCH] sound: fix MODULE_LICENSE typos
Message-ID: <20120623105118.GR4037@opensource.wolfsonmicro.com>
References: <20120622232149.GA29819@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CgyvWwj/llZsteoZ"
Content-Disposition: inline
In-Reply-To: <20120622232149.GA29819@www.outflux.net>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CgyvWwj/llZsteoZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 22, 2012 at 04:21:49PM -0700, Kees Cook wrote:
> include/linux/license.h does not recognize "GPLv2", so adjust these
> declarations to add the needed space before the version.

This patch isn't against current -next which doesn't have this issue,
I've no idea what you generated against as a version with this has never
even been in -next.  Please do also use subject lines that resemble
those used in the rest of the subsystem, having to hand edit commit logs
is tedious.

It seems more sensible to fix license.h, GPLv2 is a pretty common way of
writing the license name in the wider community.

--CgyvWwj/llZsteoZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5Z+ZAAoJEBus8iNuMP3drasP/3Gla6S0lk/I+hnjaZSjuV/k
7ViReikJ8I4npwDez88ijvpmY+T88GE4bAe8uzqluzraVjLmLWykxG3eilvLrjRs
xB2eSo6kCL50dNUeja+qCtx57iwE1sA09RBDz+OhX7G1e4Xc8JV/cp7lYIYVbSp8
WaaoxGyst2JYfwdKZCeS4wJSmQynC+7zdy1QEgJ++RnU3YCW1UQ/Vzb0cqaQ+SOT
lTwRNQ3uK9N3PHodBoQa4koxAfXT5Kyne0rIl/q3RRFft9xXac5Ahiy4jBdtoBd0
aWhlQN7rpdkhovbdt6uJNjQPBiugHuo+K8ZLPfXSjdSFmrga4CDwSwZNQ1FueBjY
o3tDngw8a3jmHrn40jkVBbnJ5BlzPYySPMsSIpmJYxz5/MsfqAh1dUpo1C3IuQJs
ABJzfE3TQEtRMo9X39u5JnuV2t0/9z0asBB0ahYQhfM7VsUw3dfhFzPXXam1I7Jn
/fHUzt1H1zWz73pPVI7mZ8PhToTFvEJusswiCrdD/lIt+yzWTL1Zkzgoxd1O6htp
L2R7oVxOPMsh5x6nLPLTF8pTDYZFf1gHtw2z0sAYSDzX1DHy8IR+J/TgHzrLIRBC
otNIyvpXBr0HRnhTzcEshxMGCRL9mNNIalMqiorAUklYNf536m9eq9YKR+yX3TBR
uh5AgzDWan790ablu9Bm
=U2Zf
-----END PGP SIGNATURE-----

--CgyvWwj/llZsteoZ--
