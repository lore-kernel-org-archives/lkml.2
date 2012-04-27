Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901Ab2D0Rmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:42:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50612 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760425Ab2D0Rml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:42:41 -0400
Date: Fri, 27 Apr 2012 18:42:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Minor bugfix for non pll
 slave mode
Message-ID: <20120427174235.GM18260@opensource.wolfsonmicro.com>
References: <1335525244.22171.16.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kunpHVz1op/+13PW"
Content-Disposition: inline
In-Reply-To: <1335525244.22171.16.camel@matrix>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kunpHVz1op/+13PW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 27, 2012 at 04:44:04PM +0530, Ashish Chavan wrote:
> This patch fixes a bug discovered during testing of non pll slave mode.
> Due to the bug chip was not getting correctly configured and as a result
> there was no sound output while playback. After applying this patch,
> both pll and non pll modes work fine.

Applied, thanks.

--kunpHVz1op/+13PW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmtneAAoJEBus8iNuMP3dvzkP/1qTRPYHAB9q1uOHUE9C6xlY
4SFUhN6uz6XS2MBwXkqapld9qmeCTTcp4e5lxaPS/37Yy4OeZKDBgg8xC/z/sDnq
alGYaSKfZuie5qE0enBnvDdlFAEwg31jzIGWhv9cRwoSE66rAtuWaP2XiPMZGqil
RRnoiDfj6pa2li8nmZSPMPwPHy9z1v17kZkHA5iwrFaBPDFiGhJQ/YhSwBPu6Qru
O7RCnQbdec3n1nTnVTbIc2IZQFx2oMB/CtZbA35IxN5789VCalbv8ELcWzFwtMnc
rteZcbjcTx4ik0nhQqCzIFO7zNB/WCdmg0WWYfZeT/ZyZBUqeXpinRgutKY2B/zL
ByVgQJLftC0tTUCDCt0kSFfwGEh4/3hKrC3GhKfEQDiUeuDHT6qlE9tR7C9N1pnq
bTXu/9VmQNcH5vzIUKkSIAIStdkM+YxuY80J6E0uGMqLjRyVjzql7kJNKiW/EmhA
m08m2RmMGiNTDEUn/OQ0KYlRnYoMthE3oQqyfeIwKb++dsjS1COQMeq0P0xw9Dfn
vx57iSpjOqgEsG5T9ch0h4i1YTx2IFj46tZ1zzYXkvYMtabUissss6hvh5J70vjV
73nv83NObVzB1zxB/2HZaZRYhqZ6kM8/ViNIrdWB3tFhQca7XOKD3Nixq32/Ebsd
Vrzfu9Wzn+GtY9ZaJr/o
=wgYu
-----END PGP SIGNATURE-----

--kunpHVz1op/+13PW--
