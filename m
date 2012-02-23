Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2BWM2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:28:21 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:58190 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550Ab2BWM2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:28:19 -0500
Date: Thu, 23 Feb 2012 14:28:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] gpio/omap: remove saved_fallingdetect,
 saved_risingdetect fields
Message-ID: <20120223122814.GE18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
 <1329999031-6914-2-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QXAv++6zoyBcX2gv"
Content-Disposition: inline
In-Reply-To: <1329999031-6914-2-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QXAv++6zoyBcX2gv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2012 at 05:40:26PM +0530, Tarun Kanti DebBarma wrote:
> Since we already have context.fallingdetect and context.risingdetect
> there is no more need to have these additional fields. Also, getting
> rid of extra reads associated with them.
>=20
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Looks trivial and correct:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--QXAv++6zoyBcX2gv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRjDeAAoJEIaOsuA1yqRE2K4QAKnXrTHsIDc50w2Eg0gTvYSS
34zPBHfYhx2ulrLS9A1Nsn8em98+fOitulaVN1E5MnGg3mJvF8tjHj5nZ3ljJHJM
hxS6JHb2G7vZFMnUdpywEKUkIJYx0q5z5OjIt/19lutNYWvTgMXQwv0eR3cZITj2
bYjBqx3n+IqIEcp8iBc6+Io+7UH5pQhXHOvPfbIOLp1eJ1Rgig/dxhDqwojM0p71
MJtF1+b+cmpCwV+CgPaGub1jg/Rlt0kiukXRBQkU4DJJxD9pQ4YkgscikLJpZX0O
2gVfggoFcTffuM98uaJj+uUJWCI8xTC3wXTkR40dssTab5VuYIqbAZZAsZHIHyso
tDSYHA7Hcc/0tetW1inXRLZkt6KnG7edJ3Kv9DcgKWIrjhcrGzFvQvBGy7YWy8JI
gZ5m5UoNLcsqCLH9wt2xzpyxiMhOZoNDNwpgGEOfpaChccgjetI2ygjfKgiW/F4u
eEVtaGs9lABx8i4Wy+TQLLkPwFTfPfXkSVBC1UcHcQ0O4aGHBrJXOW6C376/xu27
UL+gLYS+L7LiH3PYpWuw5KUwMgdiScp/5FJZR/YeZP7J/vr/FcC6cEWwrDEhie63
0dqVai9IqmwJYIhwq/Enc0xIczhY2y4hQlr6ToVd6T1q+HCusIjAKq8DGIlI5wvv
oEa5y1L+qknyJ8fS+fWp
=2TUa
-----END PGP SIGNATURE-----

--QXAv++6zoyBcX2gv--
