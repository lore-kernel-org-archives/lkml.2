Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1J1RKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:10:31 -0400
Received: from home.keithp.com ([63.227.221.253]:33423 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1J1RKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:10:30 -0400
From: Keith Packard <keithp@keithp.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] drm/i915: fix if statement (bogus semi-colon)
In-Reply-To: <20111028114241.GA13603@elgon.mountain>
References: <20111028114241.GA13603@elgon.mountain>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 28 Oct 2011 10:10:26 -0700
Message-ID: <yund3dh9h4t.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2011 14:42:41 +0300, Dan Carpenter <dan.carpenter@oracle.com=
> wrote:

> -	if (needs_idle_maps());
> +	if (needs_idle_maps())

how embarrassing is that?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTqriAjYtFsjWk68qAQji8g//UCtOMpHmUV7rfypGhf/ipPaYcuI2d896
Hlxy7s4mXvy9nyt+tNieskCGdvt1z5d92JR63a4uO2SjVEqp4czLF3UaAknXhw8y
2IyytfVN8lXla1nowbbcfNDVwAq/0b1rdyBXRzPKXuKkcjBXjR63V7ijSy8H7tXg
fb4ATb/05ql11rzy7MjD702hZoz30rwG6lfp5XeZlCQoVig2xri80ktQ0h5dFqHa
AdFYMyYGbmjMnphJnK0Er2oJD299YqwvJ3owmNEKdlGZfNsxhtnwDTOH8tnzdMU0
tmR7fI3KqjaVX5UtITtpUgi0UaDFtX0e+7kKA8/yTZdDhCZpoCUFE2WWVUuMxDoM
hwd/tbzNXPaGL1yL4x+8+Kyc71SGldKxR3i9aKDahNIlAA3kvjx/T2vWKQMyzu3Z
XEdkM8Au4YLTOzNoqycGWopnbEm1saPHuyr7/BchU0/VE1gdWoxW6Ymgpq8LPkyc
TAvnBIGaF0ESzXAFSDaVPyai1aTFDkEWF72S57TzFRLYIAmUwWujgUqfoPiciZQ7
auzSW87UqeNB8SkFZbLmcj08kkCEzIxPD4BmrpPErmWqO/RM+detG7Sr8BNss07Y
Bg/CfBiz9Ij7ypfFZ0/1+xX5AWlSAFJecwQiXJLlqx2+Rs6CsJycZZ0eGkStMXuR
Hcuzm+/FS4k=
=9QBY
-----END PGP SIGNATURE-----
--=-=-=--
