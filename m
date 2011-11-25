Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1KYBt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:49:26 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37466 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1KYBtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:49:24 -0500
Date: Fri, 25 Nov 2011 12:49:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Clark <rob.clark@linaro.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
In-Reply-To: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__25_Nov_2011_12_49_13_+1100_i2qrpGQKO2ekhjEW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Nov_2011_12_49_13_+1100_i2qrpGQKO2ekhjEW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 16 Nov 2011 11:30:07 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> drivers/staging/gma500/framebuffer.c: In function 'psb_user_framebuffer_c=
reate':
> drivers/staging/gma500/framebuffer.c:558:44: error: 'struct drm_mode_fb_c=
md2' has no member named 'handle'
>=20
> Caused by commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes
> a pixel format v5").  Please build test *before* publishing code.  :-(
>=20
> I have used the drm tree from next-20111115 for today.
>=20
> I also get the following warnings in that file:
>=20
> drivers/staging/gma500/framebuffer.c: In function 'psb_framebuffer_init':
> drivers/staging/gma500/framebuffer.c:297:2: warning: passing argument 2 o=
f 'drm_helper_mode_fill_fb_struct' from incompatible pointer type [enabled =
by default]
> include/drm/drm_crtc_helper.h:121:12: note: expected 'struct drm_mode_fb_=
cmd2 *' but argument is of type 'struct drm_mode_fb_cmd *'
> drivers/staging/gma500/framebuffer.c:564:2: warning: passing argument 2 o=
f 'psb_framebuffer_create' from incompatible pointer type [enabled by defau=
lt]
> drivers/staging/gma500/framebuffer.c:314:32: note: expected 'struct drm_m=
ode_fb_cmd *' but argument is of type 'struct drm_mode_fb_cmd2 *'

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Nov_2011_12_49_13_+1100_i2qrpGQKO2ekhjEW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzvQZAAoJEECxmPOUX5FE0PsQAJt+Gj2Vfr2DERZQElphX9F6
d0zCwsJDm/kpNzkwGxzWMLf2TVAx7GlDPTZW2hA8PGcXLo5K/mC/RRgxk/Ghl9RV
6pBh4H6blVu0gWaHt05D6SEj5wAuxN5aY1WczVWYUV/YgqU2CIGSH8sDFT+Ub3td
NTbuG7+iNWBYex0FVt+Iv7/jnYn2ZlE69U7PfAwx1qgZKWgSUNLlNo1CatRPIGnF
0IOlXkj1Kv+SfKgCDiaAnQgmLNA8At1P+bVNYCB8/ynqc9iIT0tkZk3VT4Pbc5B5
K7q3j7TNrvLPexqZ5eyyKzGLAV7FqYMFhxZwtDGyxrf+QK8DXx89ABQjmi4XCoJ3
bGseRDIzuo+emm/b8XsBQRl3Pbx8HIgHhEeZezCI60Uhgs3qesBynReLFuBOV0sM
1g5petfz3pXPzBvLes4CzSuUHNJUdNfxvSlu7eEG8fSo4XIOqt5rhGkI4ginAqLO
+TnsFDtSXliE29llXQM9d1gfg4+TcNk1F9+I9K3N41q3XNnMaxMRG57Allt3x0dF
Nsg9dcEeJSY7rQjAm+zGxINA9HEiWWKYOf2DfVo3X/9HdLQYnDSuNSwKfNtc1ViM
p6bUNlfXNlEUGAbzgynUNekP+/5reyr7oBH4hwyU2U9rv3W0bl4l8i4+GZ6xii+V
MQvllM5sz9CgpkE5IX9L
=Q7EZ
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Nov_2011_12_49_13_+1100_i2qrpGQKO2ekhjEW--
