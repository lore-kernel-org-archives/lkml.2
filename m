Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0KZO1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:27:48 -0500
Received: from wrar.name ([109.74.195.39]:54672 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0KZO1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:27:47 -0500
Date: Fri, 26 Nov 2010 19:27:37 +0500
From: Andrey Rahmatullin <wrar@wrar.name>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.36 regression for ALC892
Message-ID: <20101126142737.GA3522@belkar.wrar.name>
References: <20101125211803.GA4236@belkar.wrar.name>
 <s5h7hg0sk04.wl%tiwai@suse.de>
 <20101126091211.GA3505@belkar.wrar.name>
 <s5heia8qvry.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <s5heia8qvry.wl%tiwai@suse.de>
X-Operating-System: Debian Sid
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 26, 2010 at 10:28:01AM +0100, Takashi Iwai wrote:
> Try the very latest alsa-driver snapshot or sound-2.6 git tree.
> You should have an individual "Headphone" volume as well.
Yes, that makes difference: I was able to use the headphones after raising
that new volume.

--=20
WBR, wRAR

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBCAAGBQJM78PZAAoJEOih81koZvPBS+4H/ilBPQen1LXKUrbw4BT1TMqS
p3uyNlMkzUYl+zZSRncizkADwNtqiGsIMgk+sZXj1DqiDpB3DkZn5zEw3QlVhRSx
y/U800nJJ4/bAZUk/eIH7CxEleAfDLGV2YJDDwP4S0DeBfT0fsJlEKZnKv+nO8pg
2EM56qBAIaNyw14P6bFhvl+Ye/cYYmpc1eIGsTpbLstpug/gSR+KQjb2tTwQ5HP/
j3Iucn+EZTjEnS9kUlSaqkd7RD6ahiVts6lbiGcTl7uydrvLM1SxszTAjdY2ls0/
WFJzUtMPFYeK13w9bZkPKLP0YaJjyaIMzdfvYJpTKTid5gLYgYYEOyOrX/hoPLM=
=RnoN
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
