Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2KWB6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:58:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53782 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039Ab2KWB6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:58:45 -0500
Date: Fri, 23 Nov 2012 10:58:39 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Ola Lilja <ola.o.lilja@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [RESENDING] [PATCH 07/22] ASoC: Ux500: Initialise PCM from MSP
 probe rather than as a device
Message-ID: <20121123015838.GH4385@opensource.wolfsonmicro.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-8-git-send-email-lee.jones@linaro.org>
 <CACRpkdbc6bGC4Yp7Bcdfev=Uc=1h4L1v+Lj9RbmJV3F+knQOZQ@mail.gmail.com>
 <20120919133343.GH25694@gmail.com>
 <505ADBE6.6080509@stericsson.com>
 <20120920125259.GA2755@gmail.com>
 <20121122140540.GA10986@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
Content-Disposition: inline
In-Reply-To: <20121122140540.GA10986@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2012 at 02:05:40PM +0000, Lee Jones wrote:
> On Thu, 20 Sep 2012, Lee Jones wrote:

> > > > Can we have some closure on this patch please, as it's blocking the
> > > > patch-set? I'm fairly sure the patch is doing the correct thing, as
> > > > seconded by Mark.

> > > I still don't like this. It is the dai_link-struct that bothers me. W=
e have
> > > "ux500-msp-i2s.1" as name of the platform AND the cpu_dai. The MSP I2=
S-block is
> > > not the platform and it is certainly not both platform and cpu-DAI at=
 the same time.
> > > Mark: Did you have a solution for this? Couldn't we just put NULL on =
the
> > > platform_name instead?

> > There are other drivers which do this already.=20

> > I don't think it's an issue to do this.

> Has anyone had any more bright ideas on how we might handle this?

> The device is still being handled in platform code and I'm desperate
> to get it out of there.

Why do we need any ideas?  Just implement it already.

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrtgfAAoJELSic+t+oim9sdAP/3V7ir3NK4SmTh4DVdndL9z2
Jdfp3PRQ/Xtrw+D0AlWWITcaLUMotlQ826rlp2KTaKSIfF/tgBu8v8ZHbCAHH52f
GgcA86BdFqfPImBIWn0I9O593LCi9jUZSGBiWel4ImpoRSasS4Lcf/T5Nl28cKff
24Ul+9k46kp0/muVpZbv9IiWUm9T5PKSjHuOQsNDt0uXZqqk+iA53Rg8h40Ho5BG
P70rVbo4Br9s7WSjwxTt0KtoAxyD0OnzwKndt6M/A0CClcRdRhcgtgB9vOOlaApM
xdXFwK8FgsEcjVBrsDQadaYuh0WpuBTrBHVplpU5xeIPg7pdrUviPe4c/3tEMGXA
cHwGRdfDezX6sqPwnUQLA2dRGu3Hgi4CKLdiMFVnoV81POo6K3Z5uztocFgdP+Se
4X9UTkkDA+DSH4iOKLio0U4q0MlqbUMzXn5VquRKZFWkp9yw8a6Gyj3wIOBXn7A7
wXko2cx+Uyeqtam8UQ0uyWaRu14xONXF21BQPSo+3z1u8/J4T8hEv2oZORlDRRxJ
0z7/aEIs/yfaOpYkulRRnswrYlDYI6WKrJXpgHq9HpGIlF36yan2OV81O0yEE1Qg
On1Raxoc7XT7bNI8BIaJtOQkrPxS3+sXIXQJPeNIVT8fx8FGkoyHDxhaeBQ605x7
tfEkllma9PdJtx29HeZR
=6UW0
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--
