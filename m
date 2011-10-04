Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab1JDTcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:32:48 -0400
Received: from home.keithp.com ([63.227.221.253]:58783 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752Ab1JDTcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:32:47 -0400
From: Keith Packard <keithp@keithp.com>
To: Alex Davis <alex14641@yahoo.com>,
        "terraluna977\@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
In-Reply-To: <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com>
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 04 Oct 2011 12:32:43 -0700
Message-ID: <yun1uuslfhg.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Oct 2011 14:10:10 -0700 (PDT), Alex Davis <alex14641@yahoo.com> w=
rote:

> The following patch fixed my backlight issues:
>=20
> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/in=
tel_panel.c
> index a9e0c7b..6f56676 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -262,8 +262,6 @@ void intel_panel_disable_backlight(struct drm_device =
*dev)
> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev_priv->backlight_level =3D=
 intel_panel_get_backlight(dev);
> =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev_priv->backlight_enabled =
=3D false;
> =C2=A0=C2=A0=C2=A0=C2=A0 }
> -
> -=C2=A0=C2=A0=C2=A0 intel_panel_set_backlight(dev, 0);
> =C2=A0}
> =C2=A0
> =C2=A0void intel_panel_enable_backlight(struct drm_device *dev)
>=20
> I've been using it since yesterday morning with no issues.

Matthew -- if we cannot resolve this backlight issue, we're going to
need to disable the new backlight code for 3.1. Do you want to try and
fix it? Or should we bail for now?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTotfWzYtFsjWk68qAQhlUxAA22H834alTbn6CuVEH+40/KusNprsrpL8
20ZOHu9v0OA1lBgSbeLsxTP7qZe7PaHQnlNaXUS9lc5sr42pv3Gq+nq7I5Txeqix
icGkCgTbBW3S1MYBMVGwmeCWegyYHmzKzhM68KoGwD9pOD9XRA9fW10A9xfsb3Oh
B5D1YFR88qRFDP359wVteMo8X28vmKmhNltiV/SjOIExjdjLktxXsCN4owbnSzaZ
2FbFwucJdLmle2GpM4ukLqOP3Wb/Y7O/yza4qLjPxWIRsqGwavATvaOcmK+eXdcy
mFTBIwnH2p7sr4196FvNxvBxoCe3+NmS0r/UynX2G2dJShp/hDO20zfmbXav5E5/
CgwVSLmW9P0rr2FpE07GXoyZHwmePATi3j3X5HESzy/0FeaKfElQSdoik4bTZfbw
zQIDL96Jgtz69Iyxu4uCvhZoUfhg6Yln0wW5/cC9bWm6Cd5ccwtacsgX7PueBgOD
dc2fRJPhAhZns5wNPn7jMypVQD44rN4T8jNmQ9yMZMOxidWxP2vqdUFDAOf+Phoe
W/ZpKyqAwb8uT5lms1XFkH0GpmRcreQ2dIvfLTw9cNnz17W9M7r/hGh8r79m3g8g
Ym5aL28fSXJWHkc0Ho9j8aA72BHpBHUwie9ZWr1LNiaeIZWYeDl8ywQ4xQV5Pf7w
Kx271yZPLPM=
=au/W
-----END PGP SIGNATURE-----
--=-=-=--
