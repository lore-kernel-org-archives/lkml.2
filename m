Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1LQQnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 11:43:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61588 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1LQQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 11:42:59 -0500
Message-ID: <1324140266.4240.81.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 5/15] sm_ftl: fix module parameter.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Date: Sat, 17 Dec 2011 18:44:26 +0200
In-Reply-To: <87y5uesfea.fsf@rustcorp.com.au>
References: <87y5uesfea.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4oYHUPoVB8uAA5yxpqo6"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4oYHUPoVB8uAA5yxpqo6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-12-15 at 13:35 +1030, Rusty Russell wrote:
> You didn't mean this to be a bool.
>=20
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Pushed to l2-mtd-2.6.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-4oYHUPoVB8uAA5yxpqo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO7MbrAAoJECmIfjd9wqK0ij8P/07DGU/5C3HJABBfGTvVN4qZ
2YOY+m+DbItx7fpTZZciWR8xkPcbmTPu1hdGybDFsLjPQfqUlbeLDt+75f1GzsHu
9XbvmimBHb3Euy1qIyRuHYTWx/kplJRrDEhnl1pqovHSZmtyBDnnQH9zaKCCSsLf
ofxAd7K3wvEoKqJ/rbz0gL4T/9q5n75Ves8xL+0VrIVTsFH7xhbkqFDXatwr2mlv
1r/9oUxedBxyTtjlRErIbPC6fR2XIRIb8c3WFXLk0KS3EpeWwRWttob7/X9xQhFV
46Y7Y3W3gvi9MFF5FZepBHwBThy9fW4xqxGxdJEQHHZMHUIgd9V6ML67tPOQvnDA
aH6qBjfyRv99MDrI4SFjktfAD2D+9T6TgDt82DM+qvCQ4ejT5ew+Zu+2RidCqyWp
yINY+hmE0kOYVbUYzbtmgbCadD91p8B1WnHqCcGWwAOUrHwbHPzqIhGWL8tMs4ko
q+GU0xY/hExGc+N2xRinusTsCOkwjanb5X9FkWSM47f9O19c14Y7iuVDr5Mva0Qr
rawflWw2uf3x0oksebBB6yIZrbLJTeTXVnRk3RuDbbzkyHZM0MmvSWCmVJBxdxp9
QFRiSNcRDLT7Ittg5zIvCqo29x9lZ/GabRa8SjBI1nyoGdXprVg//i+dr7dwNWgJ
bLBq3T+JbmOc+2KzPL3r
=9SCf
-----END PGP SIGNATURE-----

--=-4oYHUPoVB8uAA5yxpqo6--

