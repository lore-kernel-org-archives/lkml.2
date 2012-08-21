Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab2HUMj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:39:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40085 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab2HUMjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:39:54 -0400
Date: Tue, 21 Aug 2012 13:39:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120821123951.GC7995@opensource.wolfsonmicro.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-9-git-send-email-lee.jones@linaro.org>
 <s5h628lu0q9.wl%tiwai@suse.de>
 <20120820113427.GN8450@gmail.com>
 <20120820143653.GE26991@opensource.wolfsonmicro.com>
 <20120821115123.GE26899@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20120821115123.GE26899@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 12:51:24PM +0100, Lee Jones wrote:
> On Mon, Aug 20, 2012 at 03:36:53PM +0100, Mark Brown wrote:

> > > From: Lee Jones <lee.jones@linaro.org>
> > > Date: Fri, 27 Jul 2012 08:50:05 +0100

> > Please resend this series with all the acks you've got rather than
> > mixing incremental updates in like this.

> I'm waiting until I have a few more Acks before I resend the entire
> patch-set again. Actually it's you and one other that I'm waiting for
> to review (and Ack as necessary) the ones requested by Linus, then=20
> resend with the corrections.

Well, I'm the person who's going to apply the patches so I'm unlikely
to ack them...  I was waiting for arch/arm review before I looked at
them due to the number of resends.

> > Please also send patches in
> > the format documented in SubmittingPatches.

> That's a big document, most of which I guess I'm adhering to. Care to
> be a little more specific?

The bit I quoted is the main example, you're including random mail
headers in the body of the mail.

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM4FEAAoJEFJkBDiqVpZ4ZbwP/3Rrw6cfLXtYAQRAOcQSyPrz
8VTcx+RAof1yWzgwx4wYArNN4XWicdlktJLP3cc0fA7wAwTAPR9gu2fuSraU5NnQ
GSi5X7F0KbdPrJt6UeMdFEW/xSjTFq6yEltutW8NGJfcbsBarF/xXclrnJdhA00r
5WP6mcUIDkZUsmLnMXPKH60uTbHmttejy5l5NL0t1XuE9BwFwr8+Ms0rmxPLNhDL
RLFvmXRVBoO2Z7+2d4xsVCpO1DT5xnbmTfiWOHwEg5UH8k7YpqixYNBSQ4odQnlt
cKlp0a8ctwZLpt8Aw9HWyj9mf5yoHHpdpKR8g0xYfqW0V1THqkdyUiRKBoJBcca0
9Nko1eDF+H80ajC8rMHGOiwTDQ+6oqoe/j1UKM/DaF5WLC4ThQqOBytgccEEw2p/
tlj/3SCjMSWFQut/0G9I61r6NDrCILpRwTCVny/dNXkzQtZtkBQR6eHunlqAEUvH
Q3gXaY/5t5Nd6MEwawORvS17Syou4nYNE7jYn8ZsEuIvs/PoLIN3PHc5PK1a3P9x
JwpOu8FIHLMZ/UZAaKI+G6v1Hf2l/QhVL1MByIa9M+sA8IzQthOOrM2wEcqTv8H8
Q8FTxCPD8RAJiBVHWDiA81zO7avq5YW29vrFyIvL8ZtZUeE9rEsfN/PI1P0I9Bu0
+8T0p5SjC9SkiTmGt1JZ
=oWck
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
