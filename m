Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2CPTHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:07:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42366 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755703Ab2CPTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:07:01 -0400
Date: Fri, 16 Mar 2012 19:06:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/lapis: add machine driver for ML7213
 Carrier Board
Message-ID: <20120316190654.GF3158@opensource.wolfsonmicro.com>
References: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
 <1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
 <20120314144524.GT3133@opensource.wolfsonmicro.com>
 <CANKRQni-8w+2p6=ZisQ+GXhGpNmYhesKfTHfOjWGGrQrhvTFGA@mail.gmail.com>
 <20120315105048.GF3138@opensource.wolfsonmicro.com>
 <CANKRQnhg21hjKjSOtDwbfK9shNsdcEu-aiSs1zVGNtAdaHdMHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <CANKRQnhg21hjKjSOtDwbfK9shNsdcEu-aiSs1zVGNtAdaHdMHw@mail.gmail.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 01:07:03PM +0900, Tomoya MORINAGA wrote:
> On Thu, Mar 15, 2012 at 7:50 PM, Mark Brown

> > That means "Codec bit clock master frame clock slave". =A0Are you sure
> > that's what you want?

> Let me clarify the above.
> Does the above "frame clock" mean "data line" of I2S?
> If yes, I should have used 'SND_SOC_DAIFMT_CBS_CFS'.

No, it means the clock which runs at sample rate (usually called the
frame clock or LRCLK).

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPY48dAAoJEBus8iNuMP3d9n8P/34cYlobXtbmis18gU/qEomo
u6wcyrAERpY1dDAHRxN9Sr+aAyxD2UGiETLYIucSpWXYXj1AX3UPT0c5zNyxSgRn
VGO6Dso4bfGe6K26OHTk9WisXD0q/lyprlxYAT8j8HyIfm3cuvt4pqdBHw5WP41b
I7R9ZQqv0mgjolt75WT3b8vzWCBWOo5/SG66fUePPDYswInh7USNMotdFLx7Iouh
TlthySeg1CtrqiDRXN0TVlAuZW7ERuThicOlmqh5V8/euALt3WX1LCuuHKuvWavM
fWxfcM0Y+719BxwdgE0W1bTaV+dIrm50G0hXaC9KveBandKycjIqlFV0GJsSfgLm
AGEy4TbzYTsh7b92ZfN8cXx99yvw2dLe309jfwBtOZRfpRGC5NL1Q7+huPm8XqPs
9LyjBPHtDiCiPg0S0joX4/OUAbSLuBM4SuWdvBfBd0lZwH05KYc7hQ6Mk1o+yjpN
2p9d63CgzQ2NAl9dZLK8GHSp9QqhihKX8bDfxgh3twUNo2d/3NpeOZA9c9bf4ole
Jt5AZF6aGf0yL5qCbwH77gEzWasqWQGw/jF4oNHSDjtFp6c3sRy9Kj4t8OcokLoB
PdcLOInvuXelo8BusNP/7ihTNhfkIijO5mNwOjCX1gwQLuER6KkyU2D74h0c6z5H
PMzIL3W8d+SdT9b3CUCn
=JnYb
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
