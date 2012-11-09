Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2KIL6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:58:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2KIL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:58:40 -0500
Date: Fri, 9 Nov 2012 12:58:33 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: spear: Staticize spear_pwm_config()
Message-ID: <20121109115833.GA22618@avionic-0098.mockup.avionic-design.de>
References: <1352461942.9150.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1352461942.9150.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:876B5V10bDgx8Iua5bNyARLSbG3LoL7Y14960UxuPL0
 y82p6GsnAUHCG6G6FmqdrNtJj5ROBm6AM6Z6+EwYEoAsKtla24
 QbLkL4XgbZEyxHW9ljPjRFACRWim2kpMHjaOuekx5mrsMMvdg3
 PLX1DoBrS8m/098sw/EKPwnbO8xq4KkpRZ/yWMmMp0Hs7cv+Au
 s1KdqoNWBjMYWnmQ46jZ3YOKKT96oSO9Ukf4GkMJ28e5sgXU69
 IZZU1qzlU5d/IbuY1/Slostr+E3IlJjBDw4n9LXbEmAyRCFByc
 17x2dY4yjAGHXxXtUQ+dL8k+wxbxNiXM3BfCtR2e4/KHwTwGyy
 C3+upxtj9QVi4nCoYZ3OIdUGD8VIUMJiNQzA5qBgx9oq5aqk7p
 UbzaeuaI9arFuQsVrCoKCcZx9KRKFH/JkJEzkjQxOgTrgyx24H
 81FOP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 07:52:22PM +0800, Axel Lin wrote:
> spear_pwm_config() is not referenced outside of this file, make it static.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-spear.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> index 6a8fd9b..83b21d9 100644
> --- a/drivers/pwm/pwm-spear.c
> +++ b/drivers/pwm/pwm-spear.c
> @@ -76,8 +76,8 @@ static inline void spear_pwm_writel(struct spear_pwm_ch=
ip *chip,
>  	writel_relaxed(val, chip->mmio_base + (num << 4) + offset);
>  }
> =20
> -int spear_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm, int =
duty_ns,
> -		     int period_ns)
> +static int spear_pwm_config(struct pwm_chip *chip, struct pwm_device *pw=
m,
> +			    int duty_ns, int period_ns)
>  {
>  	struct spear_pwm_chip *pc =3D to_spear_pwm_chip(chip);
>  	u64 val, div, clk_rate;

Applied, thanks.

Thierry

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnO/pAAoJEN0jrNd/PrOhaC4QAJ4j59AA8C3BEprdRwAdAY7e
0HY0Wsn+/4dYPeymOeny/hU6TzcY9ZtARwoBHxJvpzfipJ3+zdJ5Zf4gCgx44A1q
BWPIksCePdFNiB98kHfc+p90V/r3utd9cy5Z/vh+bi88h+CB3efOUcadZ1W/Ggtl
g89XpWg4Ov/6j45jDYGNpaDdOett6R1lRyNFt5HCpjNks/J0Z78KWeEn7eA33k4N
nnLjSoJsYvUF+pn9ZuL1rdsVPJaUb1rxXRoDHwICAcRlRvy8yRsvymvIi9JUhqzc
DLsd2h3nES9JLUlLmPtbPEC7+6BWxMex6z5xbklbA+aEFKMrUTo1gJidbkuLvFZX
tgyLX+0rZXCMfJd5nq3nTsKn6HR0P0a9RWni1z6vmhbpJ+vEei+kXL5BPXd65NfR
owu+ZlY8p/nzCQBmKJr9Skw02gPBIDRKCjQ7IYeOTb9taNHAiw3Az0wo2lvpP2qo
uh7bzsoZEPEbeLTUzaLi8/Bc/KHCEP4NMjm9Ik+1uvqO8dJS1xv87Jb0nY1ou1oP
HwpmpPeTPu0AVSbPF47Jc0tRfagws6wmOHT1VrLAnCPcJd/BjsLXi4H+YHVoJulB
rEtGdHqL8zE/PZodKDRfqMs7W/G2w4ZKGD74n3asrqTpq0WqyCoXpVz9+BH6hDiu
SHaxfHHObTP6JCWG9HvC
=6iwE
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
