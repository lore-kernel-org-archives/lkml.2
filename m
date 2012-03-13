Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2CMLXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:23:38 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38561 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752723Ab2CMLXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:23:36 -0400
Date: Tue, 13 Mar 2012 13:23:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        linus.walleij@stericsson.com, leoli@freescale.com, zw@zh-kernel.org,
        STEricsson_nomadik_linux@list.st.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, mchehab@infradead.org,
        ludovic.desroches@atmel.com, cjb@laptop.org, g.liakhovetski@gmx.de,
        ian@mnementh.co.uk, dwmw2@infradead.org, grant.likely@secretlab.ca,
        alan@linux.intel.com, balbi@ti.com, FlorianSchandinat@gmx.de,
        perex@perex.cz, tiwai@suse.de, viresh.kumar@st.com,
        baohua.song@csr.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 1/2 V2] dmaengine/dma_slave: introduce inline wrappers
Message-ID: <20120313112327.GI9251@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1331241078-29977-1-git-send-email-alexandre.bounine@idt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7Ke/meiCZutM6I/"
Content-Disposition: inline
In-Reply-To: <1331241078-29977-1-git-send-email-alexandre.bounine@idt.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7Ke/meiCZutM6I/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 08, 2012 at 04:11:18PM -0500, Alexandre Bounine wrote:
> Add inline wrappers for device_prep_slave_sg() and device_prep_dma_cyclic=
()
> interfaces to hide new parameter from current users of affected interface=
s.
> Convert current users to use new wrappers instead of direct calls.
> Suggested by Russell King [https://lkml.org/lkml/2012/2/3/269].
>=20
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>

for musb:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--C7Ke/meiCZutM6I/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXy4vAAoJEIaOsuA1yqREdPUP/04jy9L0O2g5nykhk2Kucnud
mI3c+n2AFt7vsMwxCz0Ggv0MmxH9ShcQvq9b/ToZ0cXlLpgt/jJj/gCrnRh+wqQX
Iv+rxOJwCqYD+2yHbERAN2V4TeLvgR08Altju6nyFk5esgdkotl3RCyefrFGEDxG
yt9sVOXb+pHB9DT+pprLQi5+fmgKJ5ZoTONq6uBtG/vwJqUG9l3qs03gRiuqMlH1
7HWAchCPenawqcoKfmPaQMhprLePUqxq9KoH5VBRbA5/8kGZb9Dg7WJdMzakbL+v
bhGw6w2107ebEunCgRlPWIxN0atG73pL8CEoT5Q0XDgp1d+tX2WCBFWXVd3fU6Nk
6V2p9Wh+Dpwa4C1crWuSLvvcqXJQ3GO+T+lL8tfpmy7XiG+nPEYtYFI63xsaY7Ry
ESCx7rwtbav+ZIKJ4C2vW3grnxOugGTUWPLtTzY4Xa2RIXB1qERd7gGeQnZkm6WS
3zLyXEyYjeoAB3HIltQCD/ustSO6yzq81FNdO1ondnLiUQ70gxuozDfdD2OiRoST
UbmGqDsKXmgr2D/B8bxrEIv7hOGmEe9WwVqJwlJB7g5tr9n7Ad05oG7xSmBbi8fb
obc9jbieNnIGTbWLyDxNA0cQL3KlUqVB8TfkezZT7yud+af7Oi+QSSLnoZT2T44K
5S20+jO/slMskdGLlmNe
=s7+6
-----END PGP SIGNATURE-----

--C7Ke/meiCZutM6I/--
