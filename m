Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2K1L4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:56:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39817 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489Ab2K1L4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:56:40 -0500
Date: Wed, 28 Nov 2012 11:56:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Navada Kanyana, Mukund" <navada@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Message-ID: <20121128115638.GO32691@opensource.wolfsonmicro.com>
References: <n>
 <1354094577-14967-1-git-send-email-navada@ti.com>
 <20121128092924.GJ32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
 <20121128113443.GM32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959B6C@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/+Vq7w28QOSGzSM"
Content-Disposition: inline
In-Reply-To: <6817C817C9581447825BFB369EAC42163E959B6C@DBDE01.ent.ti.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/+Vq7w28QOSGzSM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 28, 2012 at 11:52:22AM +0000, Navada Kanyana, Mukund wrote:

> static const struct regmap_range_cfg aic325x_ranges[] = {
>         { .name = "CONF", .range_min = 128,
>           .range_max = 383,
>           .selector_reg = 0x0,
>           .selector_mask = 0xff,
>           .selector_shift = 0,
>           .window_start = 0, .window_len =128,
>         },
>         { .name = "MINIDSP_A_CM_A", .range_min = AIC325X_ADSP_CM_A_BASE,
>           .range_max = AIC325X_ADSP_CM_A_BASE + 1152,
>           .selector_reg = 0x0,
>           .selector_mask = 0xff,
>           .selector_shift = 0,
>           .window_start = 0, .window_len =128,
>         },
> };

You appear to have two different ranges with the same selector and
window.  I'm really not sure why you expect this to work...  what
happens when someone reads from the two different ranges simultaneously?

--2/+Vq7w28QOSGzSM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtfvvAAoJELSic+t+oim9wTgQAJG3xqz75GuGpB6vLTJv1WF2
iCWyF3cx0poORWKoYsQo+xmDPph3s3PaS8qxZO59tQMNhBlZjynS56HWZ0t2WzMZ
ZSWejrgylEeY89pIGxmyYpzocZZdNUkGVk0lUqcS6ryshXaS9m0vp8mNVFq/Fcge
CYSit966+AOov3SGk0yYOLuuNS+VuV1DckRB5r7iBaiHlVV+n8veRlD5P4QuaUln
KvKbReZM+mgP3DQB0cJsGGJRO7ZQYtU34s2NXmyRzu+hv2XE/cQxo/1FnKGGubEA
FgyGWxx88hVP/BUTPyFbjxFeBOcgyo4McVzI6TeBY3Re3mef5itNENAd50zF1pZM
v6vbQYmLAH8uQUULOMGEpIsKqWUhvRAJMGgSnsOW4/+3NI9J7P+gUqsJfqRs5UJQ
kbDbBX733MVPQ0GSnIjSViI9mBET94wNGMrh3Q74VSSwhA5vffaGgBZHGbVIuYsW
KKSD66sMYKG90JlHQooNh5H5UF1rn7rOZyXIYdyFe/pdX1JL5qkgMaCBONlzVxbD
PiQI4H6A9kdil4hHLfBEhhR5XRUFlEFIzpIDzGLdH6wYaCSPj4d86ZT0IYFBhyQ+
vldbDuyS+ZnE7esJX5M4h80b8F5R67K6hk8bARRQ9mtwdjBIP9cZVD2E4G31oYgz
BsUzsqVDhL3PT56RDM5D
=V/qb
-----END PGP SIGNATURE-----

--2/+Vq7w28QOSGzSM--
