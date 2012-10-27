Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2J0Vob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:44:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58361 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323Ab2J0Voa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:44:30 -0400
Date: Sat, 27 Oct 2012 22:44:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3.7-rc1] omap zoom2.c: Fix compile error by including
 correct header files
Message-ID: <20121027214421.GG4564@opensource.wolfsonmicro.com>
References: <1349274686-45668-1-git-send-email-tim.gardner@canonical.com>
 <506C5124.3050200@ti.com>
 <20121003155900.GA4840@atomide.com>
 <20121003163102.GB4840@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m972NQjnE83KvVa/"
Content-Disposition: inline
In-Reply-To: <20121003163102.GB4840@atomide.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m972NQjnE83KvVa/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 03, 2012 at 09:31:02AM -0700, Tony Lindgren wrote:

> Actually we can also drop "#include <mach/hardware.h>" too,
> it's now empty for mach-omap2. I've updated Tim's patch below
> for you guys to queue via the ASoC fixes. It's against the
> current linux next.

Applied.  Tim, you should send patches using subject lines appropriate
for the subsystem you're submitting against *especially* if the patch is
to be deferred for some future time as it makes it harder to search for
the patch.  If your changelog looks different to the other changelogs
for the thing you're patching that should be a warning.

--m972NQjnE83KvVa/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFWVAAoJELSic+t+oim9ibcP/R2yTacJ476LTN4hyrf0jACS
M+oPVa51w9Ijj3WdnyiwZNlRwLLiaiALgq+u2bu1s73AeFteLp4C8L2JTDfZqf6V
ZGhsQfgEdsl4swrPUvf6sj86lfIu95NtMkpdB/yPch/K3StEPXxS93GY/IIN8OF0
f5X1pucHw5WuN19bOE67cLbQzEFGZZwh9PAPnxJ+2iT/m6hZCvtj0sAedl1qgI75
ulyu90y0jAtOhoOpjJbS2VVIIS7cSK9Z3sP2BsIX8JOn4J9pauJaTosoqP9EVxVI
6vISiKJPZ0YuOVFifMxpzONdOeMNT1mBpg9JcnckgoONg/GvafucDlsrJkRWtq72
UI8i2P3VewciEOcF/pUJrX2VO2DPfUeiObyTFrIUWwDXsLk6MJmMsVZpmx5yCd4s
JGcM9Fn+i538ldPji58l0tT82g/CG2t0hLB8bJw34zflRZY00wHyMkZL+5dNpR1E
SB7D94PR5KpqXt2Cu+birTe3R4zC9MviWH7tnrfA260IATaUL0AFemKksFg2Z7Q4
j0PhUAVTNyxV2ffDZv0vNs2W+PlYx/Nw12XLFFi1LyYFMgQ6+APmFI3A3RjAL97Y
Nb6HCU1SXruKXaE6z2TCjtw/Q4VBCWhBYrFagcE6EQD2AHeBPha7IK8WNkCWCHWw
zm2CtQakw89fbgMs6xcg
=8ywV
-----END PGP SIGNATURE-----

--m972NQjnE83KvVa/--
