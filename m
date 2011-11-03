Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1KCUDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 16:03:55 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:51113 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751016Ab1KCUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 16:03:53 -0400
Date: Thu, 3 Nov 2011 13:03:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 7/7] drm/i915: Remove trailing white space
Message-ID: <20111103130349.594aa200@jbarnes-desktop>
In-Reply-To: <1320214830-12696-8-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-8-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hXO2d80Mn5wOzs13cLj3tGq"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hXO2d80Mn5wOzs13cLj3tGq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:30 -0700
Keith Packard <keithp@keithp.com> wrote:

> Found a couple of bare tabs in intel_dp.c
>=20
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel=
_dp.c
> index bf20a35..7ebeb01 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1054,7 +1054,7 @@ static void ironlake_edp_panel_vdd_off(struct intel=
_dp *intel_dp, bool sync)
> =20
>  	DRM_DEBUG_KMS("Turn eDP VDD off %d\n", intel_dp->want_panel_vdd);
>  	WARN(!intel_dp->want_panel_vdd, "eDP VDD not forced on");
> -=09
> +
>  	intel_dp->want_panel_vdd =3D false;
> =20
>  	if (sync) {
> @@ -2402,7 +2402,7 @@ intel_dp_init(struct drm_device *dev, int output_re=
g)
> =20
>  		cur.t8 =3D (pp_on & PANEL_LIGHT_ON_DELAY_MASK) >>
>  			PANEL_LIGHT_ON_DELAY_SHIFT;
> -	=09
> +
>  		cur.t9 =3D (pp_off & PANEL_LIGHT_OFF_DELAY_MASK) >>
>  			PANEL_LIGHT_OFF_DELAY_SHIFT;
> =20

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/hXO2d80Mn5wOzs13cLj3tGq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsvOmAAoJEIEoDkX4Qk9hrhYP/0+HRIuhZ/QJpetpQ/h8cJd3
OreartCNFp41dz9WCIcjrqCPV6H0R/rx3bEyMJu+funyJmlZRW5tGEkxcu9igiqL
rJfee9CNuuV7s85tRjFX1ejRMFanXk+q7/+FePaq1IwtQuuQ9UKMKDmmKHZCR66T
FUDB1malbdcTmIxIPgFFuhxGVjUyQvkvN3mnusrWr0icSVWFpCXE3Pil4zhNtnTi
ZANweC8UZKpN0o2tLKqfSX8CRxMo26iGWAEPzncMCeeBJjfwb99YpvsH4wSEvF3y
j5wvZH0PoD1tu460KDEmtF5CgP6qwd6M8pmxxQNwUFJDevYi0L7fxQKCE+ivg+cl
nNukc/gTni00lTLn6KHhmF8/F/QDi+WrV2et1ju/SBpt0Pw0xddfhnxJ8XOTWIgz
lZIPbVBv/4IOlY4JQbjbLcVH7972Q8RpXRLyFWJk2WRlD+w9m6TEDBnxkyRlVxWK
erX5ErSXAzed3GGonrlTlg3GQj+RPASdsPC2clXMvNwsPAB5nTpu/g7VAXhXarz3
txUN4eDbZqucl5B82mjVWQx7SHD16lD9yAnhEQLSPUPMhIfmYswVdVmhzPSn5cLS
B/f2S1cc+fDN6NPIRCAOSG8hAHWPnanRQ8PibTfLwyR0fXk/3WyfsQCt189wAn13
0PmSukSfE7npsjIr7Bqo
=iet0
-----END PGP SIGNATURE-----

--Sig_/hXO2d80Mn5wOzs13cLj3tGq--
