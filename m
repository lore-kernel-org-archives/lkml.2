Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2DQOLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:11:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab2DQOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:11:34 -0400
Date: Tue, 17 Apr 2012 15:11:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120417141128.GG6652@opensource.wolfsonmicro.com>
References: <1334666046.32225.8.camel@matrix>
 <20120417134351.GD6652@opensource.wolfsonmicro.com>
 <1334672460.13279.3.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUPx2O/K0ibUojHx"
Content-Disposition: inline
In-Reply-To: <1334672460.13279.3.camel@matrix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GUPx2O/K0ibUojHx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 07:51:00PM +0530, Ashish Chavan wrote:
> On Tue, 2012-04-17 at 14:43 +0100, Mark Brown wrote:

> > I've applied but this would be a lot clearer if it were writen as a
> > single if statement with &&s.

> Actually I implemented it like that first. But then realized that
> because of the 80 chars limit and long conditions, readability was
> hampered. Let me submit a patch to convert it to single if, if that is
> preferred way of doing it.

Hrm?  The major problem with multiple if statements is that it introduces
massive levels of indentation which are hard to parse.

--GUPx2O/K0ibUojHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjXn4AAoJEBus8iNuMP3dOWQP/RoPmtS26zmfly2LfgqlZXxk
mxUZA+P+EDG27haGuB6O9sjGvpbIJvL2C60kHPBiISdOa1v13ujduzBt5ZVDrKH6
zuYbJlwTohNmm0qsRvFaFfQEzlAwM3MzZfxyModbGQjxWZTBkFyYoJU66RRsRzdE
ZlTq+1tYuFztXiOEsNjapUpL3Nvu7t5yunzIjwxqgB9rP+ftp17ieO5x5AoJqEHJ
JgjfB/PCvJjFCOA49hzngmHSm7jqHcwcFKm5eJ8AQatfVfmN6t1fen2QVmK8WOQq
js5oHQctmU5F7ReyregQ2hDfpkz4XZ+LJ53o8sGK/3aMPPCcBz1gU6bYv33kExuZ
9ZZ5+5AmtWvLgLAL0Fluak0MdlZR4nDnUO8zIiatn/32ky75sElxdPh7J/k16uUl
uyAnrQjiVybYqyTFFJirBkKqNmyiiD0umRjJkSFR8RtG51sqbrd7DxD026FPRnNe
Bjx/lYPxbJ6vyU2pm7y/R83G1wBZRPayIZU/ibx+9gADYSRBw2gud/Dg8HILlEoU
MMOmbpW9pWTfYo8m/15uiPRtt5s7L1QFeLc9RJ52ZjS8jY/34oBDrMLyDctIHQkg
OpyGJNYKMjAXkwU2tCywwO9NMj6Y0Grf0BRQ2i7fAYlA7qfpq9vrIrU8yfz6qZab
r6crsU1pvWA5Rl1qFQyO
=+TjB
-----END PGP SIGNATURE-----

--GUPx2O/K0ibUojHx--
