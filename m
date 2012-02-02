Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab2BBWWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:22:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35934 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932694Ab2BBWWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:22:41 -0500
Date: Thu, 2 Feb 2012 22:22:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 11/11] sound/soc: add context parameter to prep_slave_sg
 and prep_dma_cyclic calls
Message-ID: <20120202222158.GA3112@opensource.wolfsonmicro.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
 <1328218341-31436-12-git-send-email-alexandre.bounine@idt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1328218341-31436-12-git-send-email-alexandre.bounine@idt.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 04:32:21PM -0500, Alexandre Bounine wrote:
> Fixups for calls affected by adding the new context parameter to DMA_SLAVE
> and DMA_CYCLIC interfaces.

This really ought to be squashed in with the original commit both to
avoid build breaks in bisection and to let people review what this
parameter does.

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKwx/AAoJEBus8iNuMP3dFf0P/01v08e45KsVsXJtMdRzt25C
9tIIqTgv+aVztM/9zWOJ77XCmxV3u1Z5YpcJ4tKzX87uJropXx/TtsZcxdUXzFW/
+ejUP8dONCxNTR3/yLeAhx+SScAZlDmJ+0MjjmlExD2jtSPOUvAWuFZTXcgcCMeS
0MtmgGds2ZSx73Z3Eo9g0EC0/wOv9UqO16/knWJ/JPauMIdSjwgQ9qFNueGZ21bd
MW0JXt2JX4Zg6R37F1ek7J762Wz6RTN0f4uuc4m2FpVv/QuBClaRTaamKCOuz0jO
lNJSjCAO3qFzGUZ91kUbNy2dKzixlP08l+g/5Ssc8FzV37XjjfFRlHQV30PdZQ3B
usF3O4lAYnzl1ynD89VFKX3SJhwxX8HzKaY2w7c35z/psBHSsSie7vM3/b1Z+nGm
bvXTTQ/TwkOGmSq66iy6fPeM7tsfedAJgTOhYaIf/CcfpdidCWYw//bwXqvXna0T
/whZKCGBdBO32fMPWEzunLMPoR7Eaaa6sziJDjW/g1l/hK8Lm1opt0ogflShWIAI
3tNapuiRJUq9gd6vroYVv5HeDGdm+YgV1/7ZkNL7Osq02Fqar5OVBzhovio3oh90
DSUWC7M/Bc7BH04wn96c1KRbt45nLF51H8R/c3/7K6Kr8Vk36KG8vYZKNbC31Wl0
JPoH25vBGJTA1PCTiW+8
=sljo
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
