Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2DJKIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:08:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39687 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492Ab2DJKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:08:17 -0400
Date: Tue, 10 Apr 2012 11:08:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 24/26] ASoC: wm8994: Don't test for NULL before
 release_firmware()
Message-ID: <20120410100813.GG7499@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204092243450.14420@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204092243450.14420@swampdragon.chaosbits.net>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 09, 2012 at 10:52:19PM +0200, Jesper Juhl wrote:
> release_firmware() does its own NULL ptr testing, it's redundant to
> also test before calling it.

Applied, thanks.

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhAaGAAoJEBus8iNuMP3dXnwP/1ednHaejrBF4X8LF2n7qRZu
7Uz3FQm27n7/nAkH0FNJmA3KSAfYjdWEWEUZHh5o0W4pDhUJnuJRRedhLfDmzFAI
xZT67q0lP1icrSG6qqTYTF7bX6YIX3TMywTtEYUgSeDyKrY6hJ7IdSQTGa3RMeAW
uqjxXcXwhu63Hj9BZyUJzuAL7nKHWguRMlwXxS+bRoWA9CHvW9nW7Vmz1jr7Geiw
ZdZ25JwQ+LRHk+SAmKZhlbhecmNnnBCgNXInHOfF8hAw4V+JMER6GpalMsDUNUKQ
Mz1546GRwUStCqaILyGwAUakgBUSa28yIdRwp5CRTW6YtGAYrIt0F9xsDuMQb0WM
0VTLeyRWaCJKBlLjhnGUxlzpBAusB2DP1p4/oGkOzYB9UiA8ZduMttUmBJvycTY1
SeKx9ye/u9In+oxYP10DuT+TXBa5RYj9hTlGF6O66Kv6aZyMTl09Gx5jgq2NEQe/
Oiz9Q3JkWBWDbiJYu/ciXIq385Mk8JiwOJE+5abNqbx5PLxIgtvPE4XAzRrvEo/v
HVd8xpYE7OYgeleX31tmlOKl4o1sthNMWD6vfsMvtyHIKPBxDP9mf0kGjQTA/kf2
MlAotlLZe1eFg5/NFQxrifQvvS2NBp3fPxu3P6WNZkPUhenQuQkeBkebFWm6LYZH
A1WQuPnOA5i650y4Jd1X
=dUeq
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
