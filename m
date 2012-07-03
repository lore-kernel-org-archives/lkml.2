Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab2GCTHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:07:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32932 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab2GCTHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:07:48 -0400
Date: Tue, 3 Jul 2012 20:07:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: tiwai@suse.de, perex@perex.cz, swarren@nvidia.com, lrg@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
Message-ID: <20120703190746.GB29030@opensource.wolfsonmicro.com>
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com>
 <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qD80nKKiJWXm4UaL"
Content-Disposition: inline
In-Reply-To: <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qD80nKKiJWXm4UaL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 29, 2012 at 05:04:33PM +0530, Laxman Dewangan wrote:
> Use the dmaengine based Tegra APB DMA driver for
> data transfer between SPI fifo and memory in
> place of legacy Tegra APB DMA.

Applied, thanks.

--qD80nKKiJWXm4UaL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP80L5AAoJEBus8iNuMP3dXa0P/2DvVqppo8KzSaFeEyA2afvX
wcBoJKP8JqS7IvQo+WLI4jsRSbWg+zfCguzyOVBLXLuawUF3Pfy7KSiIUAxrvuJN
cxthQh0/zk7GYFTpo/nGN5f1gHq4oRd/txodLkW8c15Z1uauIwSus9U+cueVAkHq
2Kc6qpxJt8yEw3RaQPDYEePHtQUcxJj2a5b/128mnH/a2j4iEkGQ+QG83kv7G5Rp
iwpYDJ5PpPaPqbvGC4K/fY0mSZHGyD0+nsOpqLR/vLUsIwuRke0gRmVdfhrC4Lgo
EPGMJcB28N765JqLJ1HN1WKHFH5qgVdoDqX+LGFThTkO0PUDV1pgg/4YWCKlVS64
uPjPeOqiUprFZg4veT7N0Cqr9QxnIpPDJRE3MQGX7xIgckK9JllKO7gh2DEHuZc4
LIGQipgWZ2VnX1LwdYiVW5Y7FvT24aI7z23qM7Knedci7osp8r+nhJD6ATRom3/T
9wYVUUlwE0PEyoCBdtsF5jJLQoLFRoZb2F4/stltQoImM1r6DCqIjuJhu1gfVzzA
+uv4IbbpcNbwRHvI1ZF7lVSuUzVDMtzLoMVwu7x8wcHry/bL+DWuA/zix+ddwZDz
jIYBraQmM5ArdXnSBRg3VqYjbjFfyGbf/FjYFQ5888NWSybf2iOwjul3EO2L62sp
Krfof+PDaCAOoZZJaknZ
=xG/L
-----END PGP SIGNATURE-----

--qD80nKKiJWXm4UaL--
