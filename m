Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2KWOqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:46:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52813 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab2KWOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:46:06 -0500
Date: Fri, 23 Nov 2012 23:45:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: mxs-saif: export
 mxs_saif_put_mclk,mxs_saif_get_mclk
Message-ID: <20121123144541.GT4529@opensource.wolfsonmicro.com>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
 <1353587470-11994-4-git-send-email-LW@KARO-electronics.de>
 <20121123020635.GK4385@opensource.wolfsonmicro.com>
 <20655.9202.288388.343758@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E5HUUwS3R9LcK7+r"
Content-Disposition: inline
In-Reply-To: <20655.9202.288388.343758@ipc1.ka-ro>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E5HUUwS3R9LcK7+r
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 08:21:22AM +0100, Lothar Wa=DFmann wrote:
> > On Thu, Nov 22, 2012 at 01:31:09PM +0100, Lothar Wa=DFmann wrote:

> > Why?

> I thought that was obvious... To be able to compile the mxs sound
> driver as module.

Do you want to add new users of these functions, or are there existing
users which currently fail to link when built as modules?

--E5HUUwS3R9LcK7+r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr4wNAAoJELSic+t+oim9ruQQAIpyCcqJ0xRh4NcTtckNzG16
MnbWKs9quLHqKmkfv5BQeR1YSkelEUn4JHWWRn4Nk6GCfkcWCC9MjC7uT5XEfB+L
V+ijx9kb6kGsQvF92nQguMSJgvlN7XqCv87YLt8/gKNtGVX97iU+LHWSxiriPk/y
HjTfi2IRFL3yObXBKHnjaRDT+11ZIIGPl9MC7T2GZGSbsPFKlzGjQ/B7ZBzP2zp5
ODuOLXUJFoFq19iYk/TGRvbXWj+XiHzesEzXOYep4HOD9WbOjGzwbtpeGDNB5On9
bTURPkIAQvySJEL8PihmILLC74uIRS7bU9Q8T9+4eqSpzHSxZuCnSPJvzVVmsg3/
v59UpqxZ9EXrz5GLdWwR6jVu0pYAVrxRvDKBtEAyUpbqMsZBPygYJfxdbWAvpHVm
TSl+A9xJ+dk79GPZ8fYl07vFDHtIhlCeUbNXNebRlMVv34Sax0c3COBUwwgAzpKe
vvoVcnCnsXlg5vgDp+zEYK5zG0oVsm/OY7/VidqLPFspBTwleAOPeeV8cxlTUzTn
Y/8V1d/Z459AcY+O/GbbINbzLEw069X2ZNUFy24diqtqbmWqJtajjLzBF6miPiXQ
GBW9jh0w2C2MLDKxEa3CbpyHrxsnn/VdeKcj9hjVaaw2LMrZwiRnuVBrO1QcEXA5
9K/PB55xo6qEKNOqkMlB
=zeF8
-----END PGP SIGNATURE-----

--E5HUUwS3R9LcK7+r--
