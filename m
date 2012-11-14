Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2KNBgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:36:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37197 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063Ab2KNBg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:36:27 -0500
Date: Wed, 14 Nov 2012 10:36:02 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ASoC: arizona: Add support for multiplexer with no
 associated mixer
Message-ID: <20121114013600.GG4415@opensource.wolfsonmicro.com>
References: <1352824834-11224-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64j1qyTOoGvYcHb1"
Content-Disposition: inline
In-Reply-To: <1352824834-11224-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--64j1qyTOoGvYcHb1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 04:40:32PM +0000, Charles Keepax wrote:
> The Asynchronous Sample Rate Converters on the wm5102/wm5110 have no
> mixer attached to their input, but they do allow the input to be
> selected from a number of sources via a multiplexer. Currently the
> platform assumes the presence of 4 multiplexers and a mixer for each
> block.

Applied all, thanks.

--64j1qyTOoGvYcHb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQovVyAAoJELSic+t+oim9mRQP/1XE363r1gpkjMDWuM+LwJBo
SEg/6U7RAByT6xfzBNAlOhRGYV6tmOpkvKyF3/kq58Pu9hI55YujokVFPqCN8+34
s9l6KiGXAd4WRpiAs7t7LCViRWklspiSHFP71jecF2rDBrb4e2QPhWXcdWjv1zzJ
/8H0SCV2xjGf0hSdUddwXbb4h/xYVSVmmJYACY4kRwvJ5UhvBxMLRqyQaBZTW/6e
wdPkALnugJi+I/epNi9Umh6GEdWU0m0GPN1DVTAppvt0T6aEdhF68Oqj0OzG03bY
isS6AX1JJmiGKqN2xLnOa/bP7R91taNAGahxbDDiKLLH9pYag03Oug1XFHhxrb4A
UQdtx4vhA+FrrDFmUFYVtwGtG+7v1bdQfXhj+X5IwDMGLH8evl7TiGzde8xW3T3d
RNzmzKRNtrbPjAAM+iaXEPNmaKVmVf8kdDAUHYChwIq9cOUEcDyRgtEblVK5dh8A
vbpsoF4Cewr4+DyXJE9WnKlXrwf75DY7QFqzV4sj72i5SjyGmeRWsw8iNMs96Em4
hbHEcBz0zPR1DcZWLgRqM7yagCx73BThlRHXzwiy9Dhc0S5XYva9wU7ncbkLQB4M
pUs5DRi46Zqff3bnZuFS/R34b9A7DCAd50gl0RXftMz/Vkbd+FXfz9Q6HEJBSQ72
RhdoptjhRpaLMaMMJxet
=9vP5
-----END PGP SIGNATURE-----

--64j1qyTOoGvYcHb1--
