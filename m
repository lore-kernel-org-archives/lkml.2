Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2BBMmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:42:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab2BBMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:42:06 -0500
Date: Thu, 2 Feb 2012 12:42:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/7] ASoC: twl6040: Remove dependency on twl4030 from
 Kconfig
Message-ID: <20120202124203.GH7428@opensource.wolfsonmicro.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
 <1328185019-29575-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bygAmIonOAIqBxQB"
Content-Disposition: inline
In-Reply-To: <1328185019-29575-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bygAmIonOAIqBxQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2012 at 02:16:55PM +0200, Peter Ujfalusi wrote:
> twl6040 no longer needs twl4030.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Not applying since this needs to follow on from (or be integrated with)
the patch splitting the twl6040 to avoid build breaks.

--bygAmIonOAIqBxQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKoSVAAoJEBus8iNuMP3d4s0P/RKQoodtSpsLSXSV9u4wsmkE
lKx1J51ymoH0PfxXXp4sth28DfX9mlhKXlYAtOAqq0TL/urXGBjD/tsxnD3MAJkZ
BMIPmHr9E7tZXjq9c/appk7Db1YWqjwLqnP++y67OffvUiE3NcYCpOqqMjNIAY0H
8s624QiRrvAXZKChPhvySkm2cfcG3Wqred6AsBJQidsgIWNWQzJgBAxhw3/depWh
2/R5M5KHnmtkWJ5ACTh2SJXU5fMk1WtGEvg4sAYsGrPlSFKwkqkG1r3IIxLrZEGy
9RsrzT2mcrb+EP7jmzi4s7u5yjjzWcBRKZaF+h2xXYt0LWBXg89fIN6rOMSMbM7P
P6TUB/CFaDMsQGKlGfg/lHvu6Z+WV7E5TCYZxeOtY4/Qu+c2a7MZmng9XpfT7InQ
HKMRAScuEczOImbhi03e7VfKcxCvIASHsc2lXWrqCXHa362PN4F0jB2wvfRXl3Ri
n/3bimFLSZFLzOCR9dPxkX3/CFnNp4jA9qVAvH8Fat5iDGQvuwd+BsW9Cun8XKC3
lrtKVmJbbvoLVczK3otrSduylyqvQkeYpNXgHPjdGTHUX+ngWaqXuE/npl47DqWf
P/alcU7tlZWYsYH7cXdtU3nTfkm2KrMONpL6G49g9tD6crUuG3R0YUy9Vkk+xlQ+
RmfjXrhHvMysOZHwo0ji
=brAZ
-----END PGP SIGNATURE-----

--bygAmIonOAIqBxQB--
