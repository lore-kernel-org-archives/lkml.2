Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab1KBQDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:03:04 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52011 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932383Ab1KBQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:03:00 -0400
Date: Wed, 2 Nov 2011 09:02:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/7] drm/i915: Move common PCH_PP_CONTROL
 setup to ironlake_get_pp_control
Message-ID: <20111102090255.09fa9a61@jbarnes-desktop>
In-Reply-To: <1320214830-12696-2-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-2-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TEXI+Ttf/5wnmC+hIY+mUjP"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TEXI+Ttf/5wnmC+hIY+mUjP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:24 -0700
Keith Packard <keithp@keithp.com> wrote:

> Every usage of PCH_PP_CONTROL sets the PANEL_UNLOCK_REGS value to
> ensure that writes will be respected, move this to a common function
> to make the driver cleaner.
>=20
> No functional changes.
>=20
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |   37 +++++++++++++++++++--------------=
----
>  1 files changed, 19 insertions(+), 18 deletions(-)

Can't we just set UNLOCK_REGS at load time and have asserts sprinkled
here and there?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/TEXI+Ttf/5wnmC+hIY+mUjP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsWmvAAoJEIEoDkX4Qk9htS0P/jFlkY/Q8wT6qqsTtB+qZSne
X8mipwdUXFOTEsnEXLx/8jaEhJyySaREHGs+tbwLn8WsfeDn/lcWh/RdHqMp4jxZ
Y2QMduz/k++3BJkNIgKY1iLW915khUIPss3nwgm1OW3V3AJopjHRIZv8oUgee1E1
094SaTwcqsOL8Y2Mg/l+KrRGwnxQicR29/yKF+CeqCX2qmIQR4FXPGc1NbRoLdbO
vstgw72S4tGkKjfG6D3RbxsrjTdbSbZRlVh4cnUgeX48xswzTasZdYWMuDKrwSmt
l9AgKmQTkdbwlVQXcNJYfgn6hYhN1RU+Td3sG7Lms0nzLRmynehWIx9OK265rOih
7uTmML5SZ+25yJy+1GlaLpYRWhxifv9O9PXWTTYQbRAzkeGiJYdbtVoY51LwwFpu
4Wf8IOcrP052GawY67W3fqvBLG4pS1sWvx73oCxryU59I752FFpP+T8/4yGgUbAe
CsW9vm9WqCbKO5nfQLPB758Ne3MbalC6KlBYXDjRKtB4yTflKlOZq/9N2HPIpDlw
DJtUnHIfc6QH5qQN3/xpbzhJ1Z2YK4mUQH3+H31g7FSWUFWrwpDsnpFdpVRw8N2A
ImjswLFtrN+Kg9OqIPWH7CxTGP8q0fr9VbY4yuYZkSQqdoLoYLfHQUkmZiLx3J83
NxVqwxnFjvuxOO7Nr4pk
=lxJy
-----END PGP SIGNATURE-----

--Sig_/TEXI+Ttf/5wnmC+hIY+mUjP--
