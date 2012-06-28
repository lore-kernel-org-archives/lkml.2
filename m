Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2F1MCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:02:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42226 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab2F1MCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:02:48 -0400
Date: Thu, 28 Jun 2012 13:02:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
Message-ID: <20120628120245.GF28922@opensource.wolfsonmicro.com>
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
 <20120628105148.GD28922@opensource.wolfsonmicro.com>
 <4FEC468A.3080607@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Content-Disposition: inline
In-Reply-To: <4FEC468A.3080607@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 28, 2012 at 05:26:58PM +0530, Laxman Dewangan wrote:

> Other driver which can use this API are davinci, OMAP, samsung but
> because they are not using the snd_dmaengine_pcm driver's api as of
> now so not be very much useful for them.

There's no reason why we can't factor out more common code - this is
essentially what Lars-Peter was saying.

> Should I send one patch per driver change or squash all 4 file
> changes in one patch? Whatever will be easy or recommended?

It doesn't really matter that much, but please take on board
Lars-Peter's comments.

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7EfdAAoJEBus8iNuMP3dEewP+wXK+vQib8Z5fIeTvXnlcACG
aAlljJByLuZGrRq5RZXN0yeTQgo84VHqZZ9F/uQEjFSWAV7FmEFiazOmL/fydPPB
q5vvFxofByU4xc5U4QsMpFSxqcHaqEA3N9CV4/Sxr7dAa1AYEU1cBJozy9fo28DP
I+oQTy2/5/2ucdwDXPoiIDuo5kAYp+iN/qRP4UVJx8b1ycHeKgNBUJ/ICEaZQH67
Osa9Kf1vnwtGkgsznT6iS/2Pf/UOSYpJoVUBQkn0oBW2MvMgPhxiMQEdvtNpFo1J
sEdoRNkKcSMQLXVGkdU9tq0MtAUJ0RmDRhih574KVh6LpyhGsnXM8NP+Fn53bnfI
tnLZ5quWXn7RK1/XkQnGdHo61NKBxXYOvlbNDY1ObrWZ4kVze+aqtJ1+Ygn1aTxZ
WNTImaN2OAbMVqMNF7qtPPTz1XrL2Rb8vYVwhwaKwhQrs0WgiGGqnHpLDVjtYwk+
2cVMS8AoHhPJ1NW7O1P1r5mZ3UiZHZ/xGG59wHUY+5DlnEVIy2jHruie2YFQBlEm
xvAW39QSSwOX+Cpm/2ck320ijt+6GRfrm+8Xdk9QSiVcarLW5c94KlMPyyx8ompe
lJFJwM5EavTMPVCL/eIMNjZ5BqRhi4kSTObc5iozK7hdm/B/xpjU3QL1ig2i+F+N
A4/LDKEBTs897uk2G9sk
=0mAZ
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
