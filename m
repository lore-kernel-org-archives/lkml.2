Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2F1M2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:28:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab2F1M2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:28:33 -0400
Date: Thu, 28 Jun 2012 13:28:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
Message-ID: <20120628122830.GJ28922@opensource.wolfsonmicro.com>
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
 <4FEC3B70.5030902@metafoo.de>
 <s5hobo3zl79.wl%tiwai@suse.de>
 <20120628121816.GB21029@sirena.org.uk>
 <4FEC4E62.3020101@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x0KprKst+ZOYEj2z"
Content-Disposition: inline
In-Reply-To: <4FEC4E62.3020101@metafoo.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x0KprKst+ZOYEj2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 28, 2012 at 02:30:26PM +0200, Lars-Peter Clausen wrote:
> On 06/28/2012 02:18 PM, Mark Brown wrote:

> > Oh, dear - this means we don't actually have a generic API at all.  Is
> > there any effort being made to make this generally available?

> Yes there is, and in fact in next/master there is generic
> dma_mmap_writecombine. I'm not quite sure how it behaves on non ARM archs
> though. But in theory it should fallback to a normal coherent mapping. Marek
> did a lot of work on this, I've put him on Cc.

OK, that's not so bad.  Where is this code, can we merge it into ALSA?
If not it's probably best to punt until after the merge window.

--x0KprKst+ZOYEj2z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7E3lAAoJEBus8iNuMP3dFk8P/1KXEXgMFvv/gOq420U6HbdH
hzPvm0f1xnfLWkrbUEarbfXiFjShJ0xF2dIerxkuq0gqtN+zgX6g12pUfNfAyCy7
rzrd0nLfZj51Q+uLuVdsgl68ewOOQPofGU+PRAmXU80AczVUonaSI/hlEVHTzCzD
x9QwjLBSCaoakJdnGGtMZfhcaXOyRGZHMfB5sH5nPRKSObsKFDrk6t3NWRL3Zkq7
fJvB/wHHo8fvJQxIKharLLX86QSJHf3MCCeNw2djcItR7+CFGHoZDRb96y6oAAdA
9/wZqho2kh/Y1GVu4sGO4hzpIO8z4Bh/JghApvBAy2/bKi9TgtYsvpvnZTPPa7Yu
ud13p7npOg6ySGyORie+UKh4wXyY6Kco8nteqMYOmChZz3EgdfeeKzjNrDX45jM/
itFLqTfPwMUuz2DTAJlqvtMMp5EOUsZRvc+2eBv+PGolXvkebqKZG39K67MqB9B3
o18gQEgLgwYmZKRSTuxQPyCUbJEOLb460hASYwfcjs1lDp8w2cAb+7k4W2s9Ube3
XUP5G0mPWAva5fefRhKOfzmk2yj2++B6crsgHhv2Wfs3onCv6yIKnhkyQFsQySVg
kO7cRWGpY1cTcus64LgPMzc5FpHBeid5bB+HQ3PDGgeOlxoBYQWCW7yEwvAc2Hf7
nEazcyjs4fm3bC1OtPHS
=2Wgx
-----END PGP SIGNATURE-----

--x0KprKst+ZOYEj2z--
