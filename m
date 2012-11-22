Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2KVVFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:05:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2KVVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:05:21 -0500
Date: Thu, 22 Nov 2012 22:05:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 08/11] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Message-ID: <20121122210504.GF16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-9-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65ImJOski3p8EhYV"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-9-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:vWbQucaEw4sOEhNE4ouIets9zUYMLMEH1RFw14YXDbN
 LcsC29PLXkEGiXB/bJQszz7yNQ8Kpwz7ZA66VLeryesNW0Z2eM
 /31MbybjoR0gS9Sl5YVbKDxdCc8LXbv9ev0YAu+Nw2icU51bRO
 3D8IAoiQjjK6dA+eXvFm5AXwRI6RwzXYFA/whmm+UV14IR5fBC
 QDGeKyDF5GG7RXaz+WXiMKD+zN0/69CWz70bTY85HuxFbmv5U6
 wnWGRprBZSxu21GDUY+5QA41MknRhMWLI37lgWF57Q+36Nj2im
 OwgcNBvbkwqC69w5qr0FwBET/heCfXHCAF2py90Q4XAnzmGiKo
 lyJpGBwQfzpwy5RRd24qNB64GMqcsP0zRUBJocMVaRMULjFcWU
 mSkQgpz6L/Ar4nBMpIfzqYLgq95IW3CKoEZ6ssvkUcs0O1Qztp
 JZT2m
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--65ImJOski3p8EhYV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 06:41:05PM +0530, Philip, Avinash wrote:
> Some platforms (like AM33XX) requires clock gating from control module
> explicitly for TBCLK. Enabling of this clock required for the
> functioning of the time base sub module in EHRPWM module. So adding
> optional TBCLK handling if DT node populated with tbclkgating. This
> helps the driver can coexist for Davinci platforms.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> Changes since v2:
> 	- Remove DT property for tbclkgating
> 	- Use devm_clk_get instead of clk_get
>=20
> Changes since v1:
> 	- Moved TBCLK enable from probe to .pwm_enable & disable from
> 	  remove to .pwm_disable
>=20
> :100644 100644 23fd3c3... 6e90829... M	drivers/pwm/pwm-tiehrpwm.c
>  drivers/pwm/pwm-tiehrpwm.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)

Looks good.

Thierry

--65ImJOski3p8EhYV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpOAAAoJEN0jrNd/PrOhxB8QAKBPb7m2rDe17YCp187jyJx/
aYv6cqyoQBvgVL0WjOW4o+iAzoPFmUctoe5PD48VY5UMpzIdjGqLM+7alEQtdeAW
OP4ClHzsleKmzkIhnUMjw/zLDMal3qAYBCQwhTL/z0i/oTd5fnTrY2t+c708vVTN
y1xodUqFevACtAsjspUFZT1o8te1+erpMJhv3tK1amQ4/lfq/rEQ2S1J3gji0Njn
YIvlkSsmJ+/QYgq2JBi2ZrVIJawn0GAyOLt3h93CTIKg5g3mQtv4rANQUs+lK+lN
8qqqpHL9FKQoqa0xUjopgt8SF+DP7UA+xdJ2lNud5RBeLTno1dGYVaayzItKuaca
aSftUvACcNR8CFJ+7Z6Jt3QW3ktLkwcW2woWSRa+YUXtfT3Kje8zR5aOAI4jGR4M
BwjPQ4LMK2OrVCZGXjVKb03kSO5Hbz5UZxvffqPV5m/iLHEpOf4ARE2bpbb/tZ+S
6KKQAUrZ5lqlf0AYAZBx5W45llZ2NQLrJuyH/xsKGXmROXSddfB1bg3rDn8/K8cj
+RHoRT96Tv3hmQ15a7cRWwS6DIIBgPl+aeIzg8BgsrtmOM6jQ3HF9dcHw7aHT9so
wiYpx6vR7q5zyiwqQAyOVgCUdUMwyQlk4zT1BUV3SqnSi9jRXdjgX58xSLAg15aU
/aOR70BXyb5CtIJhOaJ2
=TXBX
-----END PGP SIGNATURE-----

--65ImJOski3p8EhYV--
