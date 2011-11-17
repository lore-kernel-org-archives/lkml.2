Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1KQWpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:45:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1KQWps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:45:48 -0500
Message-ID: <1321569940.18123.7.camel@atropine>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hook up Ivybridge eDP
From: Adam Jackson <ajax@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Thu, 17 Nov 2011 17:45:40 -0500
In-Reply-To: <1321489780-17085-1-git-send-email-keithp@keithp.com>
References: <1321489780-17085-1-git-send-email-keithp@keithp.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1YQYR0II2ykGspSgx3RX"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1YQYR0II2ykGspSgx3RX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-11-16 at 16:29 -0800, Keith Packard wrote:
> The Ivybridge eDP control register looks like a cross between a
> Cougarpoint PCH DP control register and a Sandybridge eDP control
> register.

Your silicon people worry me.

> +/* IVB */
> +#define EDP_LINK_TRAIN_400MV_0DB_IVB		(0x24 <<22)
> +#define EDP_LINK_TRAIN_400MV_3_5DB_IVB		(0x2a <<22)
> +#define EDP_LINK_TRAIN_400MV_6DB_IVB		(0x2f <<22)
> +#define EDP_LINK_TRAIN_600MV_0DB_IVB		(0x30 <<22)
> +#define EDP_LINK_TRAIN_600MV_3_5DB_IVB		(0x36 <<22)
> +#define EDP_LINK_TRAIN_800MV_0DB_IVB		(0x38 <<22)
> +#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x33 <<22)
> +
> +/* legacy values */
> +#define EDP_LINK_TRAIN_500MV_0DB_IVB		(0x00 <<22)
> +#define EDP_LINK_TRAIN_1000MV_0DB_IVB		(0x20 <<22)
> +#define EDP_LINK_TRAIN_500MV_3_5DB_IVB		(0x02 <<22)
> +#define EDP_LINK_TRAIN_1000MV_3_5DB_IVB		(0x22 <<22)
> +#define EDP_LINK_TRAIN_1000MV_6DB_IVB		(0x23 <<22)

I don't even.  Unless you're looking at some other version of the DP
spec than me, I was pretty sure those weren't legal voltage values.  And
3.5dB preemph on 1000mV gives you 1500mV at the peak, which is
definitely outside the spec.

- ajax

--=-1YQYR0II2ykGspSgx3RX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7FjpQACgkQW4otUKDs0NN6KwCglvzXHaDtky4CISZh79mUCZ8M
zsYAn2Ks3RySVdGAbvrmenX3JiMrwo17
=rrb3
-----END PGP SIGNATURE-----

--=-1YQYR0II2ykGspSgx3RX--

