Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2I0IVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:21:31 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55423 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962Ab2I0IV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:21:28 -0400
Date: Thu, 27 Sep 2012 11:16:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: balbi@ti.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 1/7] dmaengine: dw_dmac: use helper macro
 module_platform_driver()
Message-ID: <20120927081627.GP12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-2-git-send-email-andriy.shevchenko@linux.intel.com>
 <20120927074039.GH12592@arwen.pp.htv.fi>
 <CAOh2x==i26PjSWzFYE+qzAThUL1fiFy8D17NtQGZqznGzRVApw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2lX4GznBIrto1wi"
Content-Disposition: inline
In-Reply-To: <CAOh2x==i26PjSWzFYE+qzAThUL1fiFy8D17NtQGZqznGzRVApw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2lX4GznBIrto1wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 01:46:17PM +0530, viresh kumar wrote:
> On Thu, Sep 27, 2012 at 1:10 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>=20
> >> @@ -1700,6 +1700,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
> >>  #endif
> >>
> >>  static struct platform_driver dw_driver =3D {
> >> +     .probe          =3D dw_probe,
> >
> > probe's in __init section. This is wrong. You need to change probe
> > __devinit.
>=20
> Good one. How can i miss it. :(
>=20
> @Andy: Please add my Acked-by: after this change.

after this change you can also add:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--s2lX4GznBIrto1wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAtbAAoJEIaOsuA1yqREMlkQAJu/K+VyidvYAncAzUuNYkmK
CrAK0bhoCLUF46uO9mHN0cENepgHUpXvPJoe//sEmJ7Xkshodsx2w50qV2Ii33YG
/9AWIXUvmucjP4HDmUfYFJ0HGX0yhX5yyvvbwl80OhnSTzf+bGUVzxtJH4PRSVPY
QshPTPly6CIpQB46sf7w32kVAM1vpGJvHQv2MlWgbytXand217rMFzhHppYnuo/5
CR+qmmcn8+NMwiFJSil8sglKlgzl5IN6guOxXuMInn0hYJBlQzrK/rt3ylOA4MX6
A7jL3VDrQR6dbSuZ+EQi3Gq/7gYlNjxdaqwXeadPfpDVkGKfMGNHOQ66tE8kr22Y
8Omh6dRTYMkIkTptRbXno+AGX7mCcyx8IssTlKZPz6ztn8Ssnto07f2ulzpNxpn2
j4td/iNuzSn3Jz/wh7kRepYpqDm7aKNlocTueZdHa8bSJeeuBwKq7JREkUf9BTxf
5jjvIaqPxaW8dAMDM7Kz1angkfPlg3kKhAvKZkAbsNVps2EXwLtxhXmgi6ET2Pjo
euxCzzwxZHd9N7P4tZfwlgCC3tV9A2T27XYqbBLX9/8+OSYgt/rhgoW/X+6st4vU
HdLgIfhCHucV35WV8vsN31u7ECVzTGX49CMo4sD9BEzSm6YnPd4Xmh2e3nqfqX7X
l7Nx/NYCVEtQyMy8MVnW
=YaF5
-----END PGP SIGNATURE-----

--s2lX4GznBIrto1wi--
