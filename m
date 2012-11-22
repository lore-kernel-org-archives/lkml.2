Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2KVVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:09:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2KVVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:09:17 -0500
Date: Thu, 22 Nov 2012 22:08:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 09/11] ARM: dts: AM33XX: Add PWMSS device tree nodes
Message-ID: <20121122210857.GH16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-10-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/pVXlBMPtxfSuJG"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-10-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:oyxL5LbudohnvgAcufS8AZqd4jBcv3BoV5Hxa5ipEoz
 WBatIMluiulptUkvNWGjGgZx5djzC4D2wQSUYEQbKAkrsCwkY+
 9FOE2G+1AU1vCnlrYPS7+CW2qjpzho/CbjkCnlsANkCQgv7UVX
 mOGYrkH23zfOLj8S2PPatz5hCrYenjV4cNZboMake1AlbAI3CK
 SoC6uEpea2mmcCWZsTbcNVQUnqsPjZnyy4+YwKAUchdlEVbVfz
 WtR56vf7yJiYooMdX800vWCgaei+dbPoG5gwqV5sAGWaPXKWSY
 BI9a0G8a2eXT0ffCTqqAAJtgBqJfrUurQfVjuWjpyDoN5YkP4e
 4oY3sCDSuRVM3kim/OC8jhvK0cXTASD6PEx80Qmm1AwrJO/NNu
 Xi6ghUzcKcYjpriKqCyczL5WMPn/wsD5Sc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8/pVXlBMPtxfSuJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 06:41:06PM +0530, Philip, Avinash wrote:
> Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
> AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
> adding necessary properties like pwm-cells, base reg & set disabled as
> status.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> Changes since v2:
> 	- ranges property populated to handle child devices address range
>=20
> :100644 100644 20a3f29... 4393161... M	arch/arm/boot/dts/am33xx.dtsi
>  arch/arm/boot/dts/am33xx.dtsi |   84 +++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 84 insertions(+), 0 deletions(-)

Looks good to me,

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--8/pVXlBMPtxfSuJG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpRpAAoJEN0jrNd/PrOhEvwP/3Fxsbbdh+3U/XaMi+df3SPu
v+FhtZMtoL/7nUkhk9VOUpbnmokcx+Cgl8D7ApHEgnWvp90Y4HaJNEk9xxgNevKc
YvNrtg+6zL2Yx4gZIOdQDHXEMiBNBBfmeXFwUwmZUxjz/1HgqY0o1j+bm9GBsbD5
RCi8NT+f9pw/QdKK7/nWvl++6ZHRG6eVW5l0Z+usN5XAFQJxYOh5XsoDVF+JkZ5q
yJrkx8jXuc2xvPH/NIcSsTILs74/mvle3pBv6LaeIT4HN/3ac6M3a4LfljNqO2ZP
g1arIfSeI4cqpptEekCFDvUoDS2H7pV18DbN/s/2rICt2r2nmQIJGArVe1sH9Hrs
PCANVlyOtINYxk95oYhMNIEBDiOmuphcat8YGMhr19YSeBSqtZa0hHV43mc52ZTz
2GB68u6i/SSkLpJTOKWDr5Mw8BOSCBJruONyyUPQBXIEBsTDF7o6WZdZK9lnU2JE
r7kFCTQiUItktg2d89AgZ3BCStkRL7Z4mFpFFNWfVmPL8AQZTVJUOk3WE/sIxhP3
PRge095DGL0sYLrY1OLrp7AANO7OVAodpnN5v2ADrbNefJrkEE4creGFeWhLSou3
gZHzmXsqbIMaYkTYE74ZIhtZRe0zSDy/RTQqHkZajnrrzvnwBYYYEUpA95nmZbSi
JXxlxKYPglzfMop+FQD3
=/RVl
-----END PGP SIGNATURE-----

--8/pVXlBMPtxfSuJG--
