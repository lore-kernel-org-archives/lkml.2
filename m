Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab2GCKkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:40:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47636 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449Ab2GCKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:40:49 -0400
Date: Tue, 3 Jul 2012 11:09:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, "tiwai@suse.de" <tiwai@suse.de>,
        "perex@perex.cz" <perex@perex.cz>, Stephen Warren <swarren@nvidia.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
Message-ID: <20120703100943.GG29030@opensource.wolfsonmicro.com>
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com>
 <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
 <4FF1D083.7060207@wwwdotorg.org>
 <4FF2914B.1000601@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Content-Disposition: inline
In-Reply-To: <4FF2914B.1000601@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qxfKREH7IwbezJ+T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 11:59:31AM +0530, Laxman Dewangan wrote:

> Are you taking this patch?
> I have other independent patch for the writecombine dma support in
> pcm memory library and wanted to avoid any merge conflicts.
> So if it goes in your tree then the other patch also need to go in
> your tree.

You've not even left 24 hours for me to respond!

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8sTYAAoJEBus8iNuMP3d3BsP/0bUbFwwz8ky1BHf3puU+0hO
MXHEIerCJfUk3T50cRUy/Xt9VINRcb2QaW+KaxhP63gpopcJkWDxdlIhjZAiiYAY
HKulS/E36PWokG6wFT5KdOp2BCsgxL2r1ejT2rKAS4aIAQllR4yilPdR/RLHQRTZ
TpCbM7bht9cs9S9CcE2qw5xlZHfnCiebLedMlHt3kax4Ra93fRVSsD98vM1m99jh
fe28ayF7oGEME+zdJiQlDEtFCYW8B85Q++sNyTaPeYrkpUFIt+L0eS7ndK4ITwm4
6+UITZNS6Utvo4/62YtdKqGtb1KwwpjjGcMrNJBDpxlAUROMi//9LJH0zqJAPd0x
kW7OVjxci2LGwBBR1UecB+3He7o8cXoLMTZUm9devi/slA7Z4EUQxmj4ZZVPK4Nz
LXyWg/u7Q9RXg6frWFlG2cnLQMvq0tbquLk5B5wECU0Z/ps8CohdiJNzsSEqySzj
TvwodwcU1oc/eog64uM/fM8nqVh3cjyEybECzbc8WZ1Ubnev+3qEZxA4vFCcrYug
CSLbRFVSCPOXm/e8RL53WDNyGlYsGQPAjVuOffUaBlGVReqqGbv3ueEkeMcS25JO
sVwEiqometxOqIrLt7AhYG0qtFfozxDqGKaRbDx5Ko/0hqcCIq8qJl0myD3hxGOv
f7SztCkczc1dUUd1xWoP
=gZ5d
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
